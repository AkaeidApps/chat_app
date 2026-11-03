import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  final String groupId;
  final String name;
  final String description;
  final String groupPic;
  final String createdBy;
  final List<String> adminIds;
  final List<String> memberIds;
  final DateTime createdAt;

  GroupModel({
    required this.groupId,
    required this.name,
    this.description = '',
    this.groupPic = '',
    required this.createdBy,
    required this.adminIds,
    required this.memberIds,
    required this.createdAt,
  });

  factory GroupModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return GroupModel(
      groupId: docId ?? map['groupId'] ?? '',
      name: map['name'] ?? 'New Group',
      description: map['description'] ?? '',
      groupPic: map['groupPic'] ?? '',
      createdBy: map['createdBy'] ?? '',
      adminIds: List<String>.from(map['adminIds'] ?? []),
      memberIds: List<String>.from(map['memberIds'] ?? []),
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] is Timestamp
              ? (map['createdAt'] as Timestamp).toDate()
              : DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'name': name,
      'description': description,
      'groupPic': groupPic,
      'createdBy': createdBy,
      'adminIds': adminIds,
      'memberIds': memberIds,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
