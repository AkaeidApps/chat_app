import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../models/group_model.dart';
import '../services/storage_service.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageService _storageService = StorageService();
  final Uuid _uuid = const Uuid();

  // Get or Create 1-on-1 Chat
  Future<String> getOrCreateIndividualChat(String currentUid, String peerUid) async {
    final query = await _firestore
        .collection('chats')
        .where('isGroup', isEqualTo: false)
        .where('participants', arrayContains: currentUid)
        .get();

    for (var doc in query.docs) {
      List participants = doc.data()['participants'] ?? [];
      if (participants.contains(peerUid)) {
        return doc.id;
      }
    }

    // Create New Chat
    final chatId = '${currentUid}_$peerUid';
    ChatModel newChat = ChatModel(
      chatId: chatId,
      isGroup: false,
      participants: [currentUid, peerUid],
      lastMessage: '',
      lastMessageSenderId: '',
      lastMessageTime: DateTime.now(),
      unreadCounts: {currentUid: 0, peerUid: 0},
    );

    await _firestore.collection('chats').doc(chatId).set(newChat.toMap());
    return chatId;
  }

  // Create Group Chat
  Future<String> createGroupChat({
    required String creatorUid,
    required String name,
    required String description,
    required List<String> memberIds,
    File? groupPicFile,
  }) async {
    final groupId = _uuid.v4();
    String groupPicUrl = '';

    if (groupPicFile != null) {
      groupPicUrl = await _storageService.uploadChatMedia(
        chatId: groupId,
        file: groupPicFile,
        fileType: 'group_pic',
        extension: 'jpg',
      );
    }

    final allMembers = {...memberIds, creatorUid}.toList();

    GroupModel group = GroupModel(
      groupId: groupId,
      name: name,
      description: description,
      groupPic: groupPicUrl,
      createdBy: creatorUid,
      adminIds: [creatorUid],
      memberIds: allMembers,
      createdAt: DateTime.now(),
    );

    await _firestore.collection('groups').doc(groupId).set(group.toMap());

    Map<String, int> unreadMap = {};
    for (var id in allMembers) {
      unreadMap[id] = 0;
    }

    ChatModel chat = ChatModel(
      chatId: groupId,
      isGroup: true,
      participants: allMembers,
      lastMessage: 'Group created',
      lastMessageSenderId: creatorUid,
      lastMessageTime: DateTime.now(),
      unreadCounts: unreadMap,
    );

    await _firestore.collection('chats').doc(groupId).set(chat.toMap());
    return groupId;
  }

  // Send Message
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String text,
    String type = 'text',
    File? mediaFile,
    String? fileName,
    String? fileSize,
    String? audioDuration,
    String? replyToMessageId,
    String? replyToText,
  }) async {
    final messageId = _uuid.v4();
    String? mediaUrl;

    if (mediaFile != null) {
      final ext = mediaFile.path.split('.').last;
      mediaUrl = await _storageService.uploadChatMedia(
        chatId: chatId,
        file: mediaFile,
        fileType: type,
        extension: ext,
      );
    }

    MessageModel message = MessageModel(
      id: messageId,
      senderId: senderId,
      receiverId: receiverId,
      text: text,
      type: type,
      mediaUrl: mediaUrl,
      fileName: fileName,
      fileSize: fileSize,
      audioDuration: audioDuration,
      timestamp: DateTime.now(),
      status: MessageStatus.sent,
      replyToMessageId: replyToMessageId,
      replyToText: replyToText,
    );

    // Save message doc
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());

    // Update last message in Chat doc
    String displayLastMsg = text;
    if (type == 'image') displayLastMsg = '📷 Photo';
    if (type == 'video') displayLastMsg = '🎥 Video';
    if (type == 'audio') displayLastMsg = '🎤 Voice note';
    if (type == 'document') displayLastMsg = '📄 Document';

    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': displayLastMsg,
      'lastMessageSenderId': senderId,
      'lastMessageType': type,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'unreadCounts.$receiverId': FieldValue.increment(1),
    });
  }

  // Stream Chats
  Stream<List<ChatModel>> getUserChats(String uid) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: uid)
        .snapshots()
        .map((snapshot) {
      final chats = snapshot.docs
          .map((doc) => ChatModel.fromMap(doc.data(), docId: doc.id))
          .toList();
      chats.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
      return chats;
    });
  }

  // Stream Messages in a Chat
  Stream<List<MessageModel>> getChatMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MessageModel.fromMap(doc.data(), docId: doc.id))
          .toList();
    });
  }

  // Update Typing Indicator
  Future<void> updateTypingStatus(String chatId, String uid, bool isTyping) async {
    await _firestore.collection('chats').doc(chatId).update({
      'typingStatus.$uid': isTyping,
    });
  }

  // Reset Unread Count
  Future<void> markChatAsRead(String chatId, String uid) async {
    await _firestore.collection('chats').doc(chatId).update({
      'unreadCounts.$uid': 0,
    });
  }

  // Toggle Pin Chat
  Future<void> togglePinChat(String chatId, String uid, bool isPinned) async {
    if (isPinned) {
      await _firestore.collection('chats').doc(chatId).update({
        'pinnedBy': FieldValue.arrayUnion([uid])
      });
    } else {
      await _firestore.collection('chats').doc(chatId).update({
        'pinnedBy': FieldValue.arrayRemove([uid])
      });
    }
  }

  // Toggle Mute Chat
  Future<void> toggleMuteChat(String chatId, String uid, bool isMuted) async {
    if (isMuted) {
      await _firestore.collection('chats').doc(chatId).update({
        'mutedBy': FieldValue.arrayUnion([uid])
      });
    } else {
      await _firestore.collection('chats').doc(chatId).update({
        'mutedBy': FieldValue.arrayRemove([uid])
      });
    }
  }

  // Message Reactions
  Future<void> addReaction(String chatId, String messageId, String uid, String emoji) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .update({'reactions.$uid': emoji});
  }

  // Toggle Starred Message
  Future<void> toggleStarMessage(String chatId, String messageId, bool isStarred) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .update({'isStarred': isStarred});
  }

  // Delete Message
  Future<void> deleteMessage(String chatId, String messageId) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .update({
      'isDeleted': true,
      'text': 'This message was deleted',
    });
  }

  // Edit Message
  Future<void> editMessage(String chatId, String messageId, String newText) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .update({
      'text': newText,
      'isEdited': true,
    });
  }

  // Get Group Details
  Stream<GroupModel?> streamGroup(String groupId) {
    return _firestore.collection('groups').doc(groupId).snapshots().map((doc) {
      if (doc.exists && doc.data() != null) {
        return GroupModel.fromMap(doc.data()!, docId: doc.id);
      }
      return null;
    });
  }
}
