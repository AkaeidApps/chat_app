import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../call_controller.dart';

class GroupVideoCallView extends GetView<CallController> {
  const GroupVideoCallView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Group Video Call'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children: [
                RTCVideoView(controller.localRenderer, mirror: true),
                RTCVideoView(controller.remoteRenderer),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.red,
              child: IconButton(
                icon: const Icon(Icons.call_end, color: Colors.white),
                onPressed: controller.endCall,
              ),
            ),
          )
        ],
      ),
    );
  }
}
