import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';

class ImagePreviewView extends StatelessWidget {
  const ImagePreviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final String path = Get.arguments as String? ?? '';
    final captionController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(icon: const Icon(Icons.crop_rotate), onPressed: () {}),
          IconButton(icon: const Icon(Icons.emoji_emotions_outlined), onPressed: () {}),
          IconButton(icon: const Icon(Icons.title), onPressed: () {}),
          IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: path.startsWith('http')
                ? Image.network(path, fit: BoxFit.contain)
                : (path.isNotEmpty ? Image.file(File(path), fit: BoxFit.contain) : Container()),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.black45,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: captionController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Add a caption...',
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: AppColors.accentGreen,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      Get.back();
                      Get.snackbar('Sent', 'Media file uploaded and sent');
                    },
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
