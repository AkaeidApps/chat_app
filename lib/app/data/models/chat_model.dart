import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String chatId;
  final bool isGroup;
  final List<String> participants;
  final String lastMessage;
  final String lastMessageSenderId;
  final String lastMessageType;
  final DateTime lastMessageTime;
  final Map<String, int> unreadCounts; // uid: count
  final List<String> pinnedBy;
  final List<String> mutedBy;
  final Map<String, bool> typingStatus; // uid: isTyping

  ChatModel({
    required this.chatId,
    required this.isGroup,
    required this.participants,
    required this.lastMessage,
    required this.lastMessageSenderId,
    this.lastMessageType = 'text',
    required this.lastMessageTime,
    this.unreadCounts = const {},
    this.pinnedBy = const [],
    this.mutedBy = const [],
    this.typingStatus = const {},
  });

  factory ChatModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return ChatModel(
      chatId: docId ?? map['chatId'] ?? '',
      isGroup: map['isGroup'] ?? false,
      participants: List<String>.from(map['participants'] ?? []),
      lastMessage: map['lastMessage'] ?? '',
      lastMessageSenderId: map['lastMessageSenderId'] ?? '',
      lastMessageType: map['lastMessageType'] ?? 'text',
      lastMessageTime: map['lastMessageTime'] != null
          ? (map['lastMessageTime'] is Timestamp
              ? (map['lastMessageTime'] as Timestamp).toDate()
              : DateTime.tryParse(map['lastMessageTime'].toString()) ?? DateTime.now())
          : DateTime.now(),
      unreadCounts: Map<String, int>.from(map['unreadCounts'] ?? {}),
      pinnedBy: List<String>.from(map['pinnedBy'] ?? []),
      mutedBy: List<String>.from(map['mutedBy'] ?? []),
      typingStatus: Map<String, bool>.from(map['typingStatus'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'isGroup': isGroup,
      'participants': participants,
      'lastMessage': lastMessage,
      'lastMessageSenderId': lastMessageSenderId,
      'lastMessageType': lastMessageType,
      'lastMessageTime': Timestamp.fromDate(lastMessageTime),
      'unreadCounts': unreadCounts,
      'pinnedBy': pinnedBy,
      'mutedBy': mutedBy,
      'typingStatus': typingStatus,
    };
  }
}
