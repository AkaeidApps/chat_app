import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../config/app_colors.dart';
import '../../../global_widgets/custom_button.dart';
import '../auth_controller.dart';

class ProfilePhotoUploadView extends GetView<AuthController> {
  const ProfilePhotoUploadView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Profile Photo'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Spacer(),
            Obx(
              () => CircleAvatar(
                radius: 80,
                backgroundColor: AppColors.primaryDark.withValues(alpha: 0.15),
                backgroundImage: controller.profileImage.value != null
                    ? FileImage(controller.profileImage.value!)
                    : null,
                child: controller.profileImage.value == null
                    ? const Icon(Icons.person,
                        size: 80, color: AppColors.primaryDark)
                    : null,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => controller.pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                ),
                ElevatedButton.icon(
                  onPressed: () => controller.pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Gallery'),
                ),
              ],
            ),
            const Spacer(),
            Obx(
              () => CustomButton(
                text: 'FINISH SETUP',
                isLoading: controller.isLoading.value,
                onPressed: controller.saveProfile,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
