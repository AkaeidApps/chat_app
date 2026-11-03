import 'package:cloud_firestore/cloud_firestore.dart';

class CallModel {
  final String callId;
  final String callerId;
  final String callerName;
  final String callerPic;
  final String receiverId;
  final String receiverName;
  final String receiverPic;
  final String callType; // AUDIO or VIDEO
  final String status;   // OUTGOING, INCOMING, MISSED, CONNECTED, ENDED
  final DateTime timestamp;
  final int durationSeconds;
  final String? roomToken;

  CallModel({
    required this.callId,
    required this.callerId,
    required this.callerName,
    required this.callerPic,
    required this.receiverId,
    required this.receiverName,
    required this.receiverPic,
    required this.callType,
    required this.status,
    required this.timestamp,
    this.durationSeconds = 0,
    this.roomToken,
  });

  factory CallModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return CallModel(
      callId: docId ?? map['callId'] ?? '',
      callerId: map['callerId'] ?? '',
      callerName: map['callerName'] ?? 'Caller',
      callerPic: map['callerPic'] ?? '',
      receiverId: map['receiverId'] ?? '',
      receiverName: map['receiverName'] ?? 'Receiver',
      receiverPic: map['receiverPic'] ?? '',
      callType: map['callType'] ?? 'AUDIO',
      status: map['status'] ?? 'OUTGOING',
      timestamp: map['timestamp'] != null
          ? (map['timestamp'] is Timestamp
              ? (map['timestamp'] as Timestamp).toDate()
              : DateTime.tryParse(map['timestamp'].toString()) ?? DateTime.now())
          : DateTime.now(),
      durationSeconds: map['durationSeconds'] ?? 0,
      roomToken: map['roomToken'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'callId': callId,
      'callerId': callerId,
      'callerName': callerName,
      'callerPic': callerPic,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'receiverPic': receiverPic,
      'callType': callType,
      'status': status,
      'timestamp': Timestamp.fromDate(timestamp),
      'durationSeconds': durationSeconds,
      'roomToken': roomToken,
    };
  }
}
