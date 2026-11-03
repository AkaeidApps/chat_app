import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../../data/models/call_model.dart';
import '../../data/services/webrtc_call_service.dart';
import '../../data/repositories/call_repository.dart';
import '../../data/repositories/auth_repository.dart';

class CallController extends GetxController {
  final WebRTCCallService _webrtcService = WebRTCCallService();
  final CallRepository _callRepository = CallRepository();
  final AuthRepository _authRepository = AuthRepository();

  final RTCVideoRenderer localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer remoteRenderer = RTCVideoRenderer();

  var isMuted = false.obs;
  var isCameraOff = false.obs;
  var isSpeakerOn = true.obs;
  var callDuration = 0.obs;
  var callStatus = 'Calling...'.obs;

  Timer? _timer;
  CallModel? callModel;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is CallModel) {
      callModel = args;
    } else if (args is Map) {
      final myUser = _authRepository.currentUser;
      callModel = CallModel(
        callId: DateTime.now().millisecondsSinceEpoch.toString(),
        callerId: myUser?.uid ?? '',
        callerName: myUser?.displayName ?? 'Me',
        callerPic: myUser?.photoURL ?? '',
        receiverId: args['peerUid'] ?? '',
        receiverName: args['peerName'] ?? 'Contact',
        receiverPic: args['peerPic'] ?? '',
        callType: args['isVideo'] == true ? 'VIDEO' : 'AUDIO',
        status: 'OUTGOING',
        timestamp: DateTime.now(),
      );
    }
    _initCall();
  }

  void _initCall() async {
    await _webrtcService.initRenderers(localRenderer, remoteRenderer);
    bool isVideo = callModel?.callType == 'VIDEO';

    await _webrtcService.openUserMedia(localRenderer, isVideo: isVideo);

    if (callModel != null) {
      if (callModel!.status == 'OUTGOING') {
        await _callRepository.initiateCall(callModel!);
        await _webrtcService.createCall(
          callId: callModel!.callId,
          remoteRenderer: remoteRenderer,
          isVideo: isVideo,
        );
        callStatus.value = 'Ringing...';
      }
    }

    _startTimer();
  }

  void acceptCall() async {
    if (callModel != null) {
      callStatus.value = 'Connected';
      await _callRepository.updateCallStatus(callModel!.callId, 'CONNECTED');
      await _webrtcService.answerCall(
        callId: callModel!.callId,
        remoteRenderer: remoteRenderer,
      );
      if (callModel!.callType == 'VIDEO') {
        Get.offNamed('/active-video-call', arguments: callModel);
      } else {
        Get.offNamed('/active-audio-call', arguments: callModel);
      }
    }
  }

  void toggleMute() {
    isMuted.value = !isMuted.value;
    _webrtcService.toggleMute(isMuted.value);
  }

  void toggleCamera() {
    isCameraOff.value = !isCameraOff.value;
    _webrtcService.toggleCamera(isCameraOff.value);
  }

  void switchCamera() {
    _webrtcService.switchCamera();
  }

  void endCall() async {
    _timer?.cancel();
    if (callModel != null) {
      await _webrtcService.hangUp(callModel!.callId);
    }
    localRenderer.dispose();
    remoteRenderer.dispose();
    Get.back();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      callDuration.value++;
    });
  }

  String get formattedDuration {
    int minutes = callDuration.value ~/ 60;
    int seconds = callDuration.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void onClose() {
    _timer?.cancel();
    localRenderer.dispose();
    remoteRenderer.dispose();
    super.onClose();
  }
}
