import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../call_controller.dart';

class OutgoingVideoCallView extends GetView<CallController> {
  const OutgoingVideoCallView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          RTCVideoView(controller.localRenderer, mirror: true),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Obx(() => Text(controller.callStatus.value,
                    style: const TextStyle(color: Colors.white, fontSize: 18))),
                Text(
                  controller.callModel?.receiverName ?? 'Contact',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.cameraswitch,
                          color: Colors.white, size: 30),
                      onPressed: controller.switchCamera,
                    ),
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.red,
                      child: IconButton(
                        icon: const Icon(Icons.call_end,
                            color: Colors.white, size: 30),
                        onPressed: controller.endCall,
                      ),
                    ),
                    Obx(() => IconButton(
                          icon: Icon(
                              controller.isMuted.value
                                  ? Icons.mic_off
                                  : Icons.mic,
                              color: Colors.white,
                              size: 30),
                          onPressed: controller.toggleMute,
                        )),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          )
        ],
      ),
    );
  }
}
