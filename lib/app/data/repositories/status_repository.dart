import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/status_model.dart';
import '../services/storage_service.dart';

class StatusRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageService _storageService = StorageService();
  final Uuid _uuid = const Uuid();

  // Create Status (Text / Image / Video)
  Future<void> addStatus({
    required String uid,
    required String userName,
    required String userPic,
    required String type, // text, image, video
    required String content,
    String caption = '',
    String backgroundColorHex = '0xFF075E54',
    File? mediaFile,
  }) async {
    String finalContent = content;
    if (mediaFile != null) {
      finalContent = await _storageService.uploadStatusMedia(
        uid: uid,
        file: mediaFile,
        mediaType: type,
      );
    }

    final newItem = StatusItemModel(
      id: _uuid.v4(),
      type: type,
      content: finalContent,
      caption: caption,
      backgroundColorHex: backgroundColorHex,
      timestamp: DateTime.now(),
    );

    final statusDocRef = _firestore.collection('status').doc(uid);
    final docSnapshot = await statusDocRef.get();

    if (docSnapshot.exists) {
      await statusDocRef.update({
        'userName': userName,
        'userPic': userPic,
        'updatedAt': FieldValue.serverTimestamp(),
        'items': FieldValue.arrayUnion([newItem.toMap()]),
      });
    } else {
      UserStatusModel newStatus = UserStatusModel(
        userId: uid,
        userName: userName,
        userPic: userPic,
        items: [newItem],
        updatedAt: DateTime.now(),
      );
      await statusDocRef.set(newStatus.toMap());
    }
  }

  // Stream All Recent Active Statuses (within last 24h)
  Stream<List<UserStatusModel>> getActiveStatuses() {
    final cutoff = DateTime.now().subtract(const Duration(hours: 24));
    return _firestore.collection('status').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) {
            final status = UserStatusModel.fromMap(doc.data(), docId: doc.id);
            final activeItems = status.items
                .where((item) => item.timestamp.isAfter(cutoff))
                .toList();
            return UserStatusModel(
              userId: status.userId,
              userName: status.userName,
              userPic: status.userPic,
              items: activeItems,
              updatedAt: status.updatedAt,
            );
          })
          .where((status) => status.items.isNotEmpty)
          .toList();
    });
  }

  // Mark status item as viewed
  Future<void> markStatusViewed(
      String ownerUid, String statusItemId, String viewerUid) async {
    final docRef = _firestore.collection('status').doc(ownerUid);
    final doc = await docRef.get();
    if (doc.exists && doc.data() != null) {
      UserStatusModel userStatus =
          UserStatusModel.fromMap(doc.data()!, docId: doc.id);
      List<StatusItemModel> updatedItems = userStatus.items.map((item) {
        if (item.id == statusItemId && !item.viewerIds.contains(viewerUid)) {
          List<String> updatedViewers = List<String>.from(item.viewerIds)
            ..add(viewerUid);
          return StatusItemModel(
            id: item.id,
            type: item.type,
            content: item.content,
            caption: item.caption,
            backgroundColorHex: item.backgroundColorHex,
            timestamp: item.timestamp,
            viewerIds: updatedViewers,
          );
        }
        return item;
      }).toList();

      await docRef
          .update({'items': updatedItems.map((i) => i.toMap()).toList()});
    }
  }
}
