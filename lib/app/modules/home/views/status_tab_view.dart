import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../global_widgets/custom_avatar.dart';
import '../../../global_widgets/status_ring.dart';
import '../home_controller.dart';

class StatusTabView extends GetView<HomeController> {
  const StatusTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = controller.currentUser.value;
      final statuses = controller.activeStatuses;

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // My Status Tile
            ListTile(
              leading: Stack(
                children: [
                  CustomAvatar(
                    imageUrl: user?.photoUrl,
                    name: user?.name ?? 'My Status',
                    radius: 26,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.accentGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add, size: 20, color: Colors.white),
                    ),
                  )
                ],
              ),
              title: const Text('My status', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Tap to add status update'),
              onTap: () => Get.toNamed(AppRoutes.CREATE_IMAGE_STATUS),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Recent updates',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondaryLight,
                  fontSize: 13,
                ),
              ),
            ),
            if (statuses.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32.0),
                child: Center(
                  child: Text(
                    'No recent status updates from your contacts',
                    style: TextStyle(color: AppColors.textSecondaryLight),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: statuses.length,
                itemBuilder: (context, index) {
                  final status = statuses[index];
                  return ListTile(
                    leading: StatusRing(
                      imageUrl: status.userPic,
                      name: status.userName,
                      hasUnseenStatus: true,
                      statusCount: status.items.length,
                      onTap: () => Get.toNamed(AppRoutes.STATUS_VIEWER, arguments: status),
                    ),
                    title: Text(status.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('Today, 12:45 PM'),
                    onTap: () => Get.toNamed(AppRoutes.STATUS_VIEWER, arguments: status),
                  );
                },
              )
          ],
        ),
      );
    });
  }
}
