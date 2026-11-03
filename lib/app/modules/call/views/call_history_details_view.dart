import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../config/app_colors.dart';
import '../../../data/models/call_model.dart';
import '../../../global_widgets/custom_avatar.dart';

class CallHistoryDetailsView extends StatelessWidget {
  const CallHistoryDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final CallModel? call = Get.arguments as CallModel?;

    return Scaffold(
      appBar: AppBar(title: const Text('Call Info')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            CustomAvatar(
              imageUrl: call?.receiverPic,
              name: call?.receiverName ?? 'Contact',
              radius: 45,
            ),
            const SizedBox(height: 12),
            Text(
              call?.receiverName ?? 'Contact',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.chat, color: AppColors.primaryDark),
                  onPressed: () => Get.back(),
                ),
                IconButton(
                  icon: const Icon(Icons.phone, color: AppColors.primaryDark),
                  onPressed: () => Get.back(),
                ),
                IconButton(
                  icon:
                      const Icon(Icons.videocam, color: AppColors.primaryDark),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const Divider(height: 32),
            ListTile(
              leading: Icon(
                call?.status == 'MISSED' ? Icons.call_missed : Icons.call_made,
                color: call?.status == 'MISSED'
                    ? Colors.red
                    : AppColors.accentGreen,
              ),
              title: Text(call?.status ?? 'OUTGOING'),
              subtitle: Text(call != null
                  ? DateFormat('MMMM d, h:mm a').format(call.timestamp)
                  : ''),
              trailing: Text('${call?.durationSeconds ?? 0} sec'),
            )
          ],
        ),
      ),
    );
  }
}
