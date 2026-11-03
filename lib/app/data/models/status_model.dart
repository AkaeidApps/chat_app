import 'package:cloud_firestore/cloud_firestore.dart';

class StatusItemModel {
  final String id;
  final String type; // text, image, video
  final String content; // text content or media URL
  final String caption;
  final String backgroundColorHex;
  final DateTime timestamp;
  final List<String> viewerIds;

  StatusItemModel({
    required this.id,
    required this.type,
    required this.content,
    this.caption = '',
    this.backgroundColorHex = '0xFF075E54',
    required this.timestamp,
    this.viewerIds = const [],
  });

  factory StatusItemModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return StatusItemModel(
      id: docId ?? map['id'] ?? '',
      type: map['type'] ?? 'text',
      content: map['content'] ?? '',
      caption: map['caption'] ?? '',
      backgroundColorHex: map['backgroundColorHex'] ?? '0xFF075E54',
      timestamp: map['timestamp'] != null
          ? (map['timestamp'] is Timestamp
              ? (map['timestamp'] as Timestamp).toDate()
              : DateTime.tryParse(map['timestamp'].toString()) ?? DateTime.now())
          : DateTime.now(),
      viewerIds: List<String>.from(map['viewerIds'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'content': content,
      'caption': caption,
      'backgroundColorHex': backgroundColorHex,
      'timestamp': Timestamp.fromDate(timestamp),
      'viewerIds': viewerIds,
    };
  }
}

class UserStatusModel {
  final String userId;
  final String userName;
  final String userPic;
  final List<StatusItemModel> items;
  final DateTime updatedAt;

  UserStatusModel({
    required this.userId,
    required this.userName,
    required this.userPic,
    required this.items,
    required this.updatedAt,
  });

  factory UserStatusModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    var rawItems = map['items'] as List? ?? [];
    List<StatusItemModel> statusItems = rawItems
        .map((i) => StatusItemModel.fromMap(Map<String, dynamic>.from(i)))
        .toList();

    return UserStatusModel(
      userId: docId ?? map['userId'] ?? '',
      userName: map['userName'] ?? 'User',
      userPic: map['userPic'] ?? '',
      items: statusItems,
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] is Timestamp
              ? (map['updatedAt'] as Timestamp).toDate()
              : DateTime.tryParse(map['updatedAt'].toString()) ?? DateTime.now())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userPic': userPic,
      'items': items.map((i) => i.toMap()).toList(),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
