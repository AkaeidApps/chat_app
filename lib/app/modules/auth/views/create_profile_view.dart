import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../config/app_colors.dart';
import '../../../global_widgets/custom_button.dart';
import '../../../global_widgets/custom_textfield.dart';
import '../auth_controller.dart';

class CreateProfileView extends GetView<AuthController> {
  const CreateProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Info'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'Please provide your name and an optional profile photo',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondaryLight),
            ),
            const SizedBox(height: 24),
            Obx(
              () => GestureDetector(
                onTap: () {
                  Get.bottomSheet(
                    Container(
                      color: Colors.white,
                      child: Wrap(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.camera_alt),
                            title: const Text('Camera'),
                            onTap: () {
                              Get.back();
                              controller.pickImage(ImageSource.camera);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.photo_library),
                            title: const Text('Gallery'),
                            onTap: () {
                              Get.back();
                              controller.pickImage(ImageSource.gallery);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primaryDark.withValues(alpha: 0.15),
                  backgroundImage: controller.profileImage.value != null
                      ? FileImage(controller.profileImage.value!)
                      : null,
                  child: controller.profileImage.value == null
                      ? const Icon(Icons.add_a_photo, size: 36, color: AppColors.primaryDark)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 32),
            CustomTextField(
              controller: controller.nameController,
              hintText: 'Type your name here',
              prefixIcon: Icons.person,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: controller.aboutController,
              hintText: 'About',
              prefixIcon: Icons.info_outline,
            ),
            const SizedBox(height: 48),
            Obx(
              () => CustomButton(
                text: 'SAVE PROFILE',
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
