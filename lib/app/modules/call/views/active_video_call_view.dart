import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../call_controller.dart';

class ActiveVideoCallView extends GetView<CallController> {
  const ActiveVideoCallView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Remote Video Fullscreen
          RTCVideoView(controller.remoteRenderer),

          // Local Video Floating Box
          Positioned(
            right: 16,
            top: 48,
            width: 120,
            height: 160,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: RTCVideoView(controller.localRenderer, mirror: true),
            ),
          ),

          // Overlay Controls
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Obx(() => Text(
                      controller.formattedDuration,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    )),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  color: Colors.black45,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.cameraswitch,
                            color: Colors.white, size: 28),
                        onPressed: controller.switchCamera,
                      ),
                      Obx(() => IconButton(
                            icon: Icon(
                                controller.isCameraOff.value
                                    ? Icons.videocam_off
                                    : Icons.videocam,
                                color: Colors.white,
                                size: 28),
                            onPressed: controller.toggleCamera,
                          )),
                      Obx(() => IconButton(
                            icon: Icon(
                                controller.isMuted.value
                                    ? Icons.mic_off
                                    : Icons.mic,
                                color: Colors.white,
                                size: 28),
                            onPressed: controller.toggleMute,
                          )),
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.red,
                        child: IconButton(
                          icon: const Icon(Icons.call_end,
                              color: Colors.white, size: 28),
                          onPressed: controller.endCall,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
