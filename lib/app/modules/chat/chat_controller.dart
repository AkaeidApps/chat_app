import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../config/app_routes.dart';
import '../../data/models/message_model.dart';
import '../../data/models/user_model.dart';
import '../../data/models/group_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/chat_repository.dart';

class ChatController extends GetxController {
  final ChatRepository _chatRepository = ChatRepository();
  final AuthRepository _authRepository = AuthRepository();

  final textController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  late String chatId;
  Rx<UserModel?> peerUser = Rx<UserModel?>(null);
  Rx<GroupModel?> groupModel = Rx<GroupModel?>(null);

  RxList<MessageModel> messages = <MessageModel>[].obs;
  Rx<MessageModel?> replyToMessage = Rx<MessageModel?>(null);

  var isTyping = false.obs;
  var isGroup = false.obs;
  String get currentUserId => _authRepository.currentUser?.uid ?? '';

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments ?? {};
    chatId = args['chatId'] ?? '';
    if (args['peerUser'] != null) {
      peerUser.value = args['peerUser'];
    }
    if (args['isGroup'] == true || Get.currentRoute == AppRoutes.GROUP_CHAT) {
      isGroup.value = true;
      _listenToGroup();
    }

    _listenToMessages();
    _markRead();
  }

  void _listenToMessages() {
    if (chatId.isNotEmpty) {
      _chatRepository.getChatMessages(chatId).listen((list) {
        messages.value = list;
      });
    }
  }

  void _listenToGroup() {
    _chatRepository.streamGroup(chatId).listen((g) {
      groupModel.value = g;
    });
  }

  void _markRead() {
    final uid = _authRepository.currentUser?.uid;
    if (uid != null && chatId.isNotEmpty) {
      _chatRepository.markChatAsRead(chatId, uid);
    }
  }

  void onTextChanged(String text) {
    final uid = _authRepository.currentUser?.uid;
    if (uid != null) {
      bool typingNow = text.trim().isNotEmpty;
      if (typingNow != isTyping.value) {
        isTyping.value = typingNow;
        _chatRepository.updateTypingStatus(chatId, uid, typingNow);
      }
    }
  }

  void sendTextMessage() async {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    final myUid = _authRepository.currentUser!.uid;
    final receiverId = peerUser.value?.uid ?? chatId;

    textController.clear();
    onTextChanged('');

    await _chatRepository.sendMessage(
      chatId: chatId,
      senderId: myUid,
      receiverId: receiverId,
      text: text,
      type: 'text',
      replyToMessageId: replyToMessage.value?.id,
      replyToText: replyToMessage.value?.text,
    );

    replyToMessage.value = null;
  }

  void sendImageMessage(ImageSource source) async {
    final XFile? file =
        await _picker.pickImage(source: source, imageQuality: 70);
    if (file != null) {
      final myUid = _authRepository.currentUser!.uid;
      final receiverId = peerUser.value?.uid ?? chatId;

      await _chatRepository.sendMessage(
        chatId: chatId,
        senderId: myUid,
        receiverId: receiverId,
        text: '📷 Photo',
        type: 'image',
        mediaFile: File(file.path),
      );
    }
  }

  void sendVideoMessage() async {
    final XFile? file = await _picker.pickVideo(source: ImageSource.gallery);
    if (file != null) {
      final myUid = _authRepository.currentUser!.uid;
      final receiverId = peerUser.value?.uid ?? chatId;

      await _chatRepository.sendMessage(
        chatId: chatId,
        senderId: myUid,
        receiverId: receiverId,
        text: '🎥 Video',
        type: 'video',
        mediaFile: File(file.path),
      );
    }
  }

  void sendDocumentMessage() async {
    final pickedFile = await FilePicker.pickFile();
    if (pickedFile != null && pickedFile.path != null) {
      final file = File(pickedFile.path!);
      final fileName = pickedFile.name;
      final sizeInBytes = await pickedFile.length() ?? 0;
      final fileSize =
          '${(sizeInBytes / 1024).toStringAsFixed(1)} KB';

      final myUid = _authRepository.currentUser!.uid;
      final receiverId = peerUser.value?.uid ?? chatId;

      await _chatRepository.sendMessage(
        chatId: chatId,
        senderId: myUid,
        receiverId: receiverId,
        text: fileName,
        type: 'document',
        mediaFile: file,
        fileName: fileName,
        fileSize: fileSize,
      );
    }
  }

  void reactToMessage(MessageModel message, String emoji) {
    final myUid = _authRepository.currentUser!.uid;
    _chatRepository.addReaction(chatId, message.id, myUid, emoji);
  }

  void toggleStarMessage(MessageModel message) {
    _chatRepository.toggleStarMessage(chatId, message.id, !message.isStarred);
  }

  void deleteMessage(MessageModel message) {
    _chatRepository.deleteMessage(chatId, message.id);
  }

  void forwardMessage(MessageModel message) {
    Get.toNamed(AppRoutes.FORWARD_MESSAGE, arguments: message);
  }

  void initiateAudioCall() {
    if (peerUser.value != null) {
      Get.toNamed(AppRoutes.OUTGOING_AUDIO_CALL, arguments: {
        'peerName': peerUser.value!.name,
        'peerPic': peerUser.value!.photoUrl,
      });
    }
  }

  void initiateVideoCall() {
    if (peerUser.value != null) {
      Get.toNamed(AppRoutes.OUTGOING_VIDEO_CALL, arguments: {
        'peerName': peerUser.value!.name,
        'peerPic': peerUser.value!.photoUrl,
      });
    }
  }
}
