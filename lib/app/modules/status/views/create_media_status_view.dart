import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../config/app_colors.dart';
import '../../../global_widgets/custom_button.dart';
import '../status_controller.dart';

class CreateMediaStatusView extends GetView<StatusController> {
  const CreateMediaStatusView({super.key, this.isVideo = false});

  final bool isVideo;

  @override
  Widget build(BuildContext context) {
    final type = isVideo ? 'video' : 'image';
    return Scaffold(
      appBar: AppBar(title: Text(isVideo ? 'Video status' : 'Photo status')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Obx(() {
                    final file = controller.selectedMedia.value;
                    if (file == null) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isVideo
                                ? Icons.videocam_outlined
                                : Icons.image_outlined,
                            color: AppColors.primaryDark,
                            size: 72,
                          ),
                          const SizedBox(height: 12),
                          Text(isVideo
                              ? 'Choose a video to share'
                              : 'Choose a photo to share'),
                        ],
                      );
                    }
                    if (isVideo) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.video_file_outlined,
                              size: 72, color: AppColors.primaryDark),
                          const SizedBox(height: 12),
                          Text(file.path.split(Platform.pathSeparator).last,
                              textAlign: TextAlign.center),
                        ],
                      );
                    }
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(file, fit: BoxFit.contain),
                    );
                  }),
                ),
              ),
              TextField(
                controller: controller.textStatusController,
                maxLength: 200,
                decoration: const InputDecoration(
                  hintText: 'Add a caption',
                  prefixIcon: Icon(Icons.edit_outlined),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => controller.pickMedia(ImageSource.gallery,
                          isVideo: isVideo),
                      icon: const Icon(Icons.photo_library_outlined),
                      label: const Text('Gallery'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => controller.pickMedia(ImageSource.camera,
                          isVideo: isVideo),
                      icon: Icon(isVideo
                          ? Icons.videocam_outlined
                          : Icons.camera_alt_outlined),
                      label: const Text('Camera'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Obx(
                () => CustomButton(
                  text: 'POST STATUS',
                  isLoading: controller.isLoading.value,
                  onPressed: controller.selectedMedia.value == null
                      ? () => Get.snackbar(
                          'Choose media', 'Select a file before posting.')
                      : () => controller.postMediaStatus(type: type),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
