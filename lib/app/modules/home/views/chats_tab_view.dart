import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../data/models/chat_model.dart';
import '../../../global_widgets/custom_avatar.dart';
import '../../../global_widgets/empty_state.dart';
import '../home_controller.dart';

class ChatsTabView extends GetView<HomeController> {
  const ChatsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.chatsList.isEmpty) {
        return EmptyState(
          icon: Icons.chat_bubble_outline,
          title: 'No conversations yet',
          subtitle: 'Tap the button below to start a chat with your contacts.',
          actionButton: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryDark),
            onPressed: () => Get.toNamed(AppRoutes.NEW_CONVERSATION),
            child: const Text('Start Chatting', style: TextStyle(color: Colors.white)),
          ),
        );
      }

      final myUid = controller.currentUser.value?.uid ?? '';

      return ListView.separated(
        itemCount: controller.chatsList.length,
        separatorBuilder: (context, index) => const Divider(indent: 72),
        itemBuilder: (context, index) {
          ChatModel chat = controller.chatsList[index];
          final isPinned = chat.pinnedBy.contains(myUid);
          final isMuted = chat.mutedBy.contains(myUid);
          final unread = chat.unreadCounts[myUid] ?? 0;
          final timeStr = DateFormat('h:mm a').format(chat.lastMessageTime);

          // Find peer uid for 1-on-1
          final peerUid = chat.participants.firstWhere(
            (id) => id != myUid,
            orElse: () => myUid,
          );

          final peerUser = controller.allContacts.firstWhereOrNull((u) => u.uid == peerUid);
          final title = chat.isGroup ? 'Group Chat' : (peerUser?.name ?? 'WhatsApp User');
          final avatarUrl = chat.isGroup ? '' : (peerUser?.photoUrl ?? '');

          return Dismissible(
            key: Key(chat.chatId),
            background: Container(
              color: AppColors.accentGreen,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20),
              child: const Icon(Icons.archive, color: Colors.white),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (dir) {},
            child: ListTile(
              leading: CustomAvatar(
                imageUrl: avatarUrl,
                name: title,
                radius: 24,
                isOnline: peerUser?.isOnline ?? false,
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    timeStr,
                    style: TextStyle(
                      fontSize: 12,
                      color: unread > 0 ? AppColors.accentGreen : AppColors.textSecondaryLight,
                      fontWeight: unread > 0 ? FontWeight.bold : FontWeight.normal,
                    ),
                  )
                ],
              ),
              subtitle: Row(
                children: [
                  if (chat.lastMessageSenderId == myUid)
                    const Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: Icon(Icons.done_all, size: 16, color: AppColors.tickBlue),
                    ),
                  Expanded(
                    child: Text(
                      chat.lastMessage.isEmpty ? 'No messages yet' : chat.lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: unread > 0 ? AppColors.textPrimaryLight : AppColors.textSecondaryLight,
                        fontWeight: unread > 0 ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (isMuted)
                    const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(Icons.volume_off, size: 16, color: Colors.grey),
                    ),
                  if (isPinned)
                    const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(Icons.push_pin, size: 16, color: Colors.grey),
                    ),
                  if (unread > 0)
                    Container(
                      margin: const EdgeInsets.only(left: 6),
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: AppColors.unreadBadge,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$unread',
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    )
                ],
              ),
              onTap: () {
                if (chat.isGroup) {
                  Get.toNamed(AppRoutes.GROUP_CHAT, arguments: {'chatId': chat.chatId});
                } else {
                  Get.toNamed(AppRoutes.INDIVIDUAL_CHAT, arguments: {
                    'chatId': chat.chatId,
                    'peerUser': peerUser,
                  });
                }
              },
            ),
          );
        },
      );
    });
  }
}
