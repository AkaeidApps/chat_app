import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';

class MyStatusView extends StatelessWidget {
  const MyStatusView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Status')),
      body: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppColors.accentGreen,
              child: Icon(Icons.edit, color: Colors.white),
            ),
            title: const Text('Text status'),
            onTap: () => Get.toNamed(AppRoutes.CREATE_TEXT_STATUS),
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppColors.primaryDark,
              child: Icon(Icons.camera_alt, color: Colors.white),
            ),
            title: const Text('Image / Video status'),
            onTap: () => Get.toNamed(AppRoutes.CREATE_IMAGE_STATUS),
          ),
        ],
      ),
    );
  }
}
