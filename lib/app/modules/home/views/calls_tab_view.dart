import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../data/models/call_model.dart';
import '../../../global_widgets/custom_avatar.dart';
import '../../../global_widgets/empty_state.dart';
import '../home_controller.dart';

class CallsTabView extends GetView<HomeController> {
  const CallsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final calls = controller.callHistory;

      if (calls.isEmpty) {
        return EmptyState(
          icon: Icons.phone_outlined,
          title: 'No calls yet',
          subtitle: 'To start calling contacts who have WhatsApp, tap the call icon at the bottom.',
        );
      }

      final myUid = controller.currentUser.value?.uid ?? '';

      return ListView.separated(
        itemCount: calls.length,
        separatorBuilder: (context, index) => const Divider(indent: 72),
        itemBuilder: (context, index) {
          CallModel call = calls[index];
          final isOutgoing = call.callerId == myUid;
          final peerName = isOutgoing ? call.receiverName : call.callerName;
          final peerPic = isOutgoing ? call.receiverPic : call.callerPic;
          final timeStr = DateFormat('MMM d, h:mm a').format(call.timestamp);

          return ListTile(
            leading: CustomAvatar(
              imageUrl: peerPic,
              name: peerName,
              radius: 24,
            ),
            title: Text(peerName, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Row(
              children: [
                Icon(
                  isOutgoing ? Icons.call_made : Icons.call_received,
                  size: 16,
                  color: call.status == 'MISSED' ? Colors.red : AppColors.accentGreen,
                ),
                const SizedBox(width: 4),
                Text(timeStr),
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                call.callType == 'VIDEO' ? Icons.videocam : Icons.phone,
                color: AppColors.primaryDark,
              ),
              onPressed: () {
                if (call.callType == 'VIDEO') {
                  Get.toNamed(AppRoutes.OUTGOING_VIDEO_CALL, arguments: {'peerName': peerName, 'peerPic': peerPic});
                } else {
                  Get.toNamed(AppRoutes.OUTGOING_AUDIO_CALL, arguments: {'peerName': peerName, 'peerPic': peerPic});
                }
              },
            ),
            onTap: () => Get.toNamed(AppRoutes.CALL_HISTORY_DETAILS, arguments: call),
          );
        },
      );
    });
  }
}
