import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageStatus { sent, delivered, read }

class MessageModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String text;
  final String type; // text, image, video, audio, document
  final String? mediaUrl;
  final String? fileName;
  final String? fileSize;
  final String? audioDuration;
  final DateTime timestamp;
  final MessageStatus status;
  final bool isStarred;
  final bool isDeleted;
  final bool isEdited;
  final String? replyToMessageId;
  final String? replyToText;
  final Map<String, String>? reactions; // userId: emoji

  MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    this.type = 'text',
    this.mediaUrl,
    this.fileName,
    this.fileSize,
    this.audioDuration,
    required this.timestamp,
    this.status = MessageStatus.sent,
    this.isStarred = false,
    this.isDeleted = false,
    this.isEdited = false,
    this.replyToMessageId,
    this.replyToText,
    this.reactions,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return MessageModel(
      id: docId ?? map['id'] ?? '',
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      text: map['text'] ?? '',
      type: map['type'] ?? 'text',
      mediaUrl: map['mediaUrl'],
      fileName: map['fileName'],
      fileSize: map['fileSize'],
      audioDuration: map['audioDuration'],
      timestamp: map['timestamp'] != null
          ? (map['timestamp'] is Timestamp
              ? (map['timestamp'] as Timestamp).toDate()
              : DateTime.tryParse(map['timestamp'].toString()) ?? DateTime.now())
          : DateTime.now(),
      status: _parseStatus(map['status']),
      isStarred: map['isStarred'] ?? false,
      isDeleted: map['isDeleted'] ?? false,
      isEdited: map['isEdited'] ?? false,
      replyToMessageId: map['replyToMessageId'],
      replyToText: map['replyToText'],
      reactions: map['reactions'] != null ? Map<String, String>.from(map['reactions']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'type': type,
      'mediaUrl': mediaUrl,
      'fileName': fileName,
      'fileSize': fileSize,
      'audioDuration': audioDuration,
      'timestamp': Timestamp.fromDate(timestamp),
      'status': status.name,
      'isStarred': isStarred,
      'isDeleted': isDeleted,
      'isEdited': isEdited,
      'replyToMessageId': replyToMessageId,
      'replyToText': replyToText,
      'reactions': reactions,
    };
  }

  static MessageStatus _parseStatus(dynamic val) {
    if (val == 'read') return MessageStatus.read;
    if (val == 'delivered') return MessageStatus.delivered;
    return MessageStatus.sent;
  }

  MessageModel copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? text,
    String? type,
    String? mediaUrl,
    String? fileName,
    String? fileSize,
    String? audioDuration,
    DateTime? timestamp,
    MessageStatus? status,
    bool? isStarred,
    bool? isDeleted,
    bool? isEdited,
    String? replyToMessageId,
    String? replyToText,
    Map<String, String>? reactions,
  }) {
    return MessageModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      text: text ?? this.text,
      type: type ?? this.type,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      audioDuration: audioDuration ?? this.audioDuration,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      isStarred: isStarred ?? this.isStarred,
      isDeleted: isDeleted ?? this.isDeleted,
      isEdited: isEdited ?? this.isEdited,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      replyToText: replyToText ?? this.replyToText,
      reactions: reactions ?? this.reactions,
    );
  }
}
