import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../../global_widgets/custom_avatar.dart';
import '../call_controller.dart';

class IncomingVideoCallView extends GetView<CallController> {
  const IncomingVideoCallView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),
            const Text('Incoming Video Call',
                style: TextStyle(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 16),
            Text(
              controller.callModel?.callerName ?? 'Incoming Call',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            CustomAvatar(
              imageUrl: controller.callModel?.callerPic,
              name: controller.callModel?.callerName ?? 'C',
              radius: 65,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.red,
                  child: IconButton(
                    icon: const Icon(Icons.call_end,
                        color: Colors.white, size: 30),
                    onPressed: controller.endCall,
                  ),
                ),
                CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.accentGreen,
                  child: IconButton(
                    icon: const Icon(Icons.videocam,
                        color: Colors.white, size: 30),
                    onPressed: controller.acceptCall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
