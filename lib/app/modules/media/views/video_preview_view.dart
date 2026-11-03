import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';

class VideoPreviewView extends StatelessWidget {
  const VideoPreviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Video Preview'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.play_circle_fill, size: 80, color: Colors.white),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentGreen),
              onPressed: () => Get.back(),
              child: const Text('Send Video', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}
