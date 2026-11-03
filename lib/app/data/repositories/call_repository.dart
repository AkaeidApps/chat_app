import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/call_model.dart';

class CallRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> initiateCall(CallModel call) async {
    await _firestore.collection('calls').doc(call.callId).set(call.toMap());
  }

  Future<void> updateCallStatus(String callId, String status) async {
    await _firestore.collection('calls').doc(callId).update({'status': status});
  }

  Stream<CallModel?> listenToCall(String callId) {
    return _firestore.collection('calls').doc(callId).snapshots().map((doc) {
      if (doc.exists && doc.data() != null) {
        return CallModel.fromMap(doc.data()!, docId: doc.id);
      }
      return null;
    });
  }

  Stream<CallModel?> listenForIncomingCalls(String uid) {
    return _firestore
        .collection('calls')
        .where('receiverId', isEqualTo: uid)
        .where('status', isEqualTo: 'INCOMING')
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return CallModel.fromMap(snapshot.docs.first.data(), docId: snapshot.docs.first.id);
      }
      return null;
    });
  }

  Stream<List<CallModel>> getCallHistory(String uid) {
    return _firestore
        .collection('calls')
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs
          .map((doc) => CallModel.fromMap(doc.data(), docId: doc.id))
          .where((call) => call.callerId == uid || call.receiverId == uid)
          .toList();
      list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return list;
    });
  }
}
