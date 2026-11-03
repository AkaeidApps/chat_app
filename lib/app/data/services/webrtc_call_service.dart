import 'dart:async';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WebRTCCallService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RTCPeerConnection? _peerConnection;
  MediaStream? localStream;
  MediaStream? remoteStream;

  final List<StreamSubscription> _subscriptions = [];

  final Map<String, dynamic> _configuration = {
    'iceServers': [
      {'urls': 'stun:stun.l.google.com:19302'},
      {'urls': 'stun:stun1.l.google.com:19302'},
    ]
  };

  Future<void> initRenderers(
    RTCVideoRenderer localRenderer,
    RTCVideoRenderer remoteRenderer,
  ) async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();
  }

  Future<MediaStream> openUserMedia(
    RTCVideoRenderer localVideo, {
    bool isVideo = true,
  }) async {
    final mediaConstraints = {
      'audio': true,
      'video': isVideo
          ? {
              'mandatory': {
                'minWidth': '640',
                'minHeight': '480',
                'minFrameRate': '30',
              },
              'facingMode': 'user',
              'optional': [],
            }
          : false,
    };

    localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    localVideo.srcObject = localStream;
    return localStream!;
  }

  Future<String> createCall({
    required String callId,
    required RTCVideoRenderer remoteRenderer,
    required bool isVideo,
  }) async {
    _peerConnection = await createPeerConnection(_configuration);

    registerPeerConnectionListeners();

    localStream?.getTracks().forEach((track) {
      _peerConnection?.addTrack(track, localStream!);
    });

    final callDocRef = _firestore.collection('calls').doc(callId);
    final callerCandidatesCollection = callDocRef.collection('callerCandidates');

    _peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
      if (candidate.candidate == null || candidate.candidate!.isEmpty) return;
      callerCandidatesCollection.add(candidate.toMap());
    };

    _peerConnection?.onTrack = (RTCTrackEvent event) {
      if (event.streams.isNotEmpty) {
        remoteStream = event.streams[0];
        remoteRenderer.srcObject = remoteStream;
      }
    };

    RTCSessionDescription offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);

    Map<String, dynamic> roomWithOffer = {
      'offer': offer.toMap(),
      'isVideo': isVideo,
    };
    await callDocRef.set(roomWithOffer, SetOptions(merge: true));

    // Listen for remote answer
    final docSubscription = callDocRef.snapshots().listen((snapshot) async {
      final data = snapshot.data();
      if (data != null && data['answer'] != null && _peerConnection != null) {
        final currentRemote = await _peerConnection?.getRemoteDescription();
        if (currentRemote == null) {
          var answer = RTCSessionDescription(
            data['answer']['sdp'],
            data['answer']['type'],
          );
          await _peerConnection?.setRemoteDescription(answer);
        }
      }
    });
    _subscriptions.add(docSubscription);

    // Listen for remote ICE candidates
    final candidatesSubscription = callDocRef
        .collection('calleeCandidates')
        .snapshots()
        .listen((snapshot) async {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added && _peerConnection != null) {
          Map<String, dynamic> data = change.doc.data() as Map<String, dynamic>;
          await _peerConnection?.addCandidate(
            RTCIceCandidate(
              data['candidate'],
              data['sdpMid'],
              data['sdpMLineIndex'],
            ),
          );
        }
      }
    });
    _subscriptions.add(candidatesSubscription);

    return callId;
  }

  Future<void> answerCall({
    required String callId,
    required RTCVideoRenderer remoteRenderer,
  }) async {
    final callDocRef = _firestore.collection('calls').doc(callId);
    final callDoc = await callDocRef.get();

    if (callDoc.exists) {
      _peerConnection = await createPeerConnection(_configuration);
      registerPeerConnectionListeners();

      localStream?.getTracks().forEach((track) {
        _peerConnection?.addTrack(track, localStream!);
      });

      final calleeCandidatesCollection = callDocRef.collection('calleeCandidates');
      _peerConnection?.onIceCandidate = (candidate) {
        if (candidate.candidate == null || candidate.candidate!.isEmpty) return;
        calleeCandidatesCollection.add(candidate.toMap());
      };

      _peerConnection?.onTrack = (event) {
        if (event.streams.isNotEmpty) {
          remoteStream = event.streams[0];
          remoteRenderer.srcObject = remoteStream;
        }
      };

      final data = callDoc.data()!;
      var offer = data['offer'];
      await _peerConnection?.setRemoteDescription(
        RTCSessionDescription(offer['sdp'], offer['type']),
      );

      var answer = await _peerConnection!.createAnswer();
      await _peerConnection!.setLocalDescription(answer);

      Map<String, dynamic> roomWithAnswer = {
        'answer': {'type': answer.type, 'sdp': answer.sdp}
      };
      await callDocRef.update(roomWithAnswer);

      final candidatesSubscription = callDocRef
          .collection('callerCandidates')
          .snapshots()
          .listen((snapshot) async {
        for (var change in snapshot.docChanges) {
          if (change.type == DocumentChangeType.added && _peerConnection != null) {
            var data = change.doc.data() as Map<String, dynamic>;
            await _peerConnection?.addCandidate(
              RTCIceCandidate(
                data['candidate'],
                data['sdpMid'],
                data['sdpMLineIndex'],
              ),
            );
          }
        }
      });
      _subscriptions.add(candidatesSubscription);
    }
  }

  Future<void> hangUp(String callId) async {
    for (final sub in _subscriptions) {
      await sub.cancel();
    }
    _subscriptions.clear();

    localStream?.getTracks().forEach((track) => track.stop());
    await localStream?.dispose();
    localStream = null;

    remoteStream?.getTracks().forEach((track) => track.stop());
    await remoteStream?.dispose();
    remoteStream = null;

    if (_peerConnection != null) {
      await _peerConnection!.close();
      _peerConnection = null;
    }

    try {
      await _firestore.collection('calls').doc(callId).set(
        {'status': 'ENDED'},
        SetOptions(merge: true),
      );
    } catch (_) {
      // Ignore errors if document was already removed or unreachable
    }
  }

  void toggleMute(bool isMuted) {
    if (localStream != null && localStream!.getAudioTracks().isNotEmpty) {
      localStream!.getAudioTracks()[0].enabled = !isMuted;
    }
  }

  void toggleCamera(bool isCameraOff) {
    if (localStream != null && localStream!.getVideoTracks().isNotEmpty) {
      localStream!.getVideoTracks()[0].enabled = !isCameraOff;
    }
  }

  Future<void> switchCamera() async {
    if (localStream != null && localStream!.getVideoTracks().isNotEmpty) {
      await Helper.switchCamera(localStream!.getVideoTracks()[0]);
    }
  }

  void registerPeerConnectionListeners() {
    _peerConnection?.onIceGatheringState = (state) {
      // ICE gathering listener
    };

    _peerConnection?.onConnectionState = (state) {
      // Connection state listener
    };
  }
}
