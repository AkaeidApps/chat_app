import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/app_colors.dart';
import '../../../global_widgets/custom_avatar.dart';
import '../home_controller.dart';

class ProfileView extends GetView<HomeController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Obx(() {
        final user = controller.currentUser.value;
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          children: [
            Center(
              child: CustomAvatar(
                  imageUrl: user.photoUrl, name: user.name, radius: 52),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.person_outline,
                  color: AppColors.primaryDark),
              title: const Text('Name'),
              subtitle: Text(user.name),
            ),
            ListTile(
              leading:
                  const Icon(Icons.info_outline, color: AppColors.primaryDark),
              title: const Text('About'),
              subtitle: Text(user.about),
            ),
            if (user.phoneNumber.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.phone_outlined,
                    color: AppColors.primaryDark),
                title: const Text('Phone'),
                subtitle: Text(user.phoneNumber),
              ),
            if (user.email.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.email_outlined,
                    color: AppColors.primaryDark),
                title: const Text('Email'),
                subtitle: Text(user.email),
              ),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.primaryDark),
              title: const Text('Log out'),
              onTap: controller.logout,
            ),
          ],
        );
      }),
    );
  }
}
