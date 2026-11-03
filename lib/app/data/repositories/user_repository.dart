import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toMap());
  }

  Future<UserModel?> getUserById(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return UserModel.fromMap(doc.data()!, docId: doc.id);
    }
    return null;
  }

  Stream<UserModel?> streamUser(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((doc) {
      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data()!, docId: doc.id);
      }
      return null;
    });
  }

  Stream<List<UserModel>> getAllUsersExcept(String currentUid) {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs
          .where((doc) => doc.id != currentUid)
          .map((doc) => UserModel.fromMap(doc.data(), docId: doc.id))
          .toList();
    });
  }

  Future<List<UserModel>> searchUsers(String query, String currentUid) async {
    final snapshot = await _firestore.collection('users').get();
    return snapshot.docs
        .where((doc) => doc.id != currentUid)
        .map((doc) => UserModel.fromMap(doc.data(), docId: doc.id))
        .where((user) =>
            user.name.toLowerCase().contains(query.toLowerCase()) ||
            user.phoneNumber.contains(query) ||
            user.email.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<void> updateProfile({
    required String uid,
    String? name,
    String? about,
    String? photoUrl,
  }) async {
    Map<String, dynamic> updateData = {};
    if (name != null) updateData['name'] = name;
    if (about != null) updateData['about'] = about;
    if (photoUrl != null) updateData['photoUrl'] = photoUrl;

    if (updateData.isNotEmpty) {
      await _firestore.collection('users').doc(uid).update(updateData);
    }
  }

  Future<void> updateOnlineStatus(String uid, bool isOnline) async {
    await _firestore.collection('users').doc(uid).update({
      'isOnline': isOnline,
      'lastSeen': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updatePushToken(String uid, String token) async {
    await _firestore.collection('users').doc(uid).update({'pushToken': token});
  }

  Future<void> blockUser(String currentUid, String targetUid) async {
    await _firestore.collection('users').doc(currentUid).update({
      'blockedUsers': FieldValue.arrayUnion([targetUid])
    });
  }

  Future<void> unblockUser(String currentUid, String targetUid) async {
    await _firestore.collection('users').doc(currentUid).update({
      'blockedUsers': FieldValue.arrayRemove([targetUid])
    });
  }
}
