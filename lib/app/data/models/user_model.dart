import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String phoneNumber;
  final String email;
  final String name;
  final String about;
  final String photoUrl;
  final bool isOnline;
  final DateTime? lastSeen;
  final String? pushToken;
  final List<String> blockedUsers;
  final DateTime? createdAt;

  UserModel({
    required this.uid,
    this.phoneNumber = '',
    this.email = '',
    required this.name,
    this.about = 'Hey there! I am using WhatsApp.',
    this.photoUrl = '',
    this.isOnline = false,
    this.lastSeen,
    this.pushToken,
    this.blockedUsers = const [],
    this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return UserModel(
      uid: docId ?? map['uid'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? 'WhatsApp User',
      about: map['about'] ?? 'Hey there! I am using WhatsApp.',
      photoUrl: map['photoUrl'] ?? '',
      isOnline: map['isOnline'] ?? false,
      lastSeen: map['lastSeen'] != null
          ? (map['lastSeen'] is Timestamp
              ? (map['lastSeen'] as Timestamp).toDate()
              : DateTime.tryParse(map['lastSeen'].toString()))
          : null,
      pushToken: map['pushToken'],
      blockedUsers: List<String>.from(map['blockedUsers'] ?? []),
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] is Timestamp
              ? (map['createdAt'] as Timestamp).toDate()
              : DateTime.tryParse(map['createdAt'].toString()))
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'phoneNumber': phoneNumber,
      'email': email,
      'name': name,
      'about': about,
      'photoUrl': photoUrl,
      'isOnline': isOnline,
      'lastSeen': lastSeen != null ? Timestamp.fromDate(lastSeen!) : FieldValue.serverTimestamp(),
      'pushToken': pushToken,
      'blockedUsers': blockedUsers,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }

  UserModel copyWith({
    String? uid,
    String? phoneNumber,
    String? email,
    String? name,
    String? about,
    String? photoUrl,
    bool? isOnline,
    DateTime? lastSeen,
    String? pushToken,
    List<String>? blockedUsers,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      name: name ?? this.name,
      about: about ?? this.about,
      photoUrl: photoUrl ?? this.photoUrl,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      pushToken: pushToken ?? this.pushToken,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
