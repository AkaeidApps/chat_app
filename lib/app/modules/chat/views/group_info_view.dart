import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../../data/models/group_model.dart';
import '../../../global_widgets/custom_avatar.dart';

class GroupInfoView extends StatelessWidget {
  const GroupInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final GroupModel? group = Get.arguments as GroupModel?;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Info'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: CustomAvatar(
                imageUrl: group?.groupPic,
                name: group?.name ?? 'Group',
                radius: 50,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              group?.name ?? 'Group',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              'Group · ${group?.memberIds.length ?? 0} participants',
              style: const TextStyle(color: AppColors.textSecondaryLight),
            ),
            const SizedBox(height: 20),
            const Divider(),
            ListTile(
              title: const Text('Add description', style: TextStyle(color: AppColors.primaryDark)),
              subtitle: Text(group?.description.isEmpty ?? true ? 'No description' : group!.description),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${group?.memberIds.length ?? 0} participants',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondaryLight),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: group?.memberIds.length ?? 0,
              itemBuilder: (context, index) {
                final memberId = group!.memberIds[index];
                final isAdmin = group.adminIds.contains(memberId);
                return ListTile(
                  leading: CustomAvatar(name: memberId, radius: 20),
                  title: Text(memberId),
                  trailing: isAdmin
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.accentGreen.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text('Group Admin', style: TextStyle(color: AppColors.primaryDark, fontSize: 11)),
                        )
                      : null,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
