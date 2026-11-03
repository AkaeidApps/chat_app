import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../data/models/message_model.dart';
import '../../../global_widgets/chat_bubble.dart';
import '../../../global_widgets/custom_avatar.dart';
import '../chat_controller.dart';

class GroupChatView extends GetView<ChatController> {
  const GroupChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.chatBackgroundLight,
      appBar: AppBar(
        title: Obx(() {
          final g = controller.groupModel.value;
          return Row(
            children: [
              CustomAvatar(
                imageUrl: g?.groupPic,
                name: g?.name ?? 'Group',
                radius: 18,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      g?.name ?? 'Group Chat',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${g?.memberIds.length ?? 0} members',
                      style: const TextStyle(fontSize: 11),
                    ),
                  ],
                ),
              )
            ],
          );
        }),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => Get.toNamed(AppRoutes.GROUP_INFO,
                arguments: controller.groupModel.value),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                final msgs = controller.messages;
                return ListView.builder(
                  reverse: true,
                  itemCount: msgs.length,
                  itemBuilder: (context, index) {
                    MessageModel msg = msgs[index];
                    final isMe = msg.senderId == controller.currentUserId;
                    return ChatBubble(message: msg, isMe: isMe);
                  },
                );
              }),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.textController,
                      decoration:
                          const InputDecoration(hintText: 'Group message'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: AppColors.accentGreen),
                    onPressed: controller.sendTextMessage,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
