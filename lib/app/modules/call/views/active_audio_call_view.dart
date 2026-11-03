import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../../global_widgets/custom_avatar.dart';
import '../call_controller.dart';

class ActiveAudioCallView extends GetView<CallController> {
  const ActiveAudioCallView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),
            Obx(() => Text(controller.formattedDuration,
                style: const TextStyle(color: Colors.white, fontSize: 18))),
            const SizedBox(height: 16),
            Text(
              controller.callModel?.receiverName ?? 'Contact',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            CustomAvatar(
              imageUrl: controller.callModel?.receiverPic,
              name: controller.callModel?.receiverName ?? 'C',
              radius: 65,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Obx(() => CircleAvatar(
                      radius: 28,
                      backgroundColor: controller.isMuted.value
                          ? Colors.white
                          : Colors.white24,
                      child: IconButton(
                        icon: Icon(
                            controller.isMuted.value
                                ? Icons.mic_off
                                : Icons.mic,
                            color: Colors.black),
                        onPressed: controller.toggleMute,
                      ),
                    )),
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
                  radius: 28,
                  backgroundColor: Colors.white24,
                  child: IconButton(
                    icon: const Icon(Icons.volume_up, color: Colors.white),
                    onPressed: () {},
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
