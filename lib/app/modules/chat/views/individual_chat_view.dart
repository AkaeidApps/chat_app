import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../data/models/message_model.dart';
import '../../../global_widgets/chat_bubble.dart';
import '../../../global_widgets/custom_avatar.dart';
import '../chat_controller.dart';

class IndividualChatView extends GetView<ChatController> {
  const IndividualChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.chatBackgroundLight,
      appBar: AppBar(
        leadingWidth: 30,
        title: Obx(() {
          final user = controller.peerUser.value;
          final title = user?.name ?? 'WhatsApp User';
          final isOnline = user?.isOnline ?? false;

          return Row(
            children: [
              CustomAvatar(
                imageUrl: user?.photoUrl,
                name: title,
                radius: 18,
                isOnline: isOnline,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      isOnline ? 'online' : 'last seen recently',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              )
            ],
          );
        }),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: controller.initiateVideoCall,
          ),
          IconButton(
            icon: const Icon(Icons.phone),
            onPressed: controller.initiateAudioCall,
          ),
          PopupMenuButton<String>(
            onSelected: (val) {
              if (val == 'search') Get.toNamed(AppRoutes.MESSAGE_SEARCH);
              if (val == 'media') Get.toNamed(AppRoutes.SHARED_MEDIA);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'search', child: Text('Search')),
              const PopupMenuItem(value: 'media', child: Text('Media, links, and docs')),
              const PopupMenuItem(value: 'mute', child: Text('Mute notifications')),
              const PopupMenuItem(value: 'clear', child: Text('Clear chat')),
            ],
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Messages List
            Expanded(
              child: Obx(() {
                final msgs = controller.messages;

                return ListView.builder(
                  reverse: true,
                  itemCount: msgs.length,
                  itemBuilder: (context, index) {
                    MessageModel msg = msgs[index];
                    bool isMe = msg.senderId != controller.peerUser.value?.uid;

                    return ChatBubble(
                      message: msg,
                      isMe: isMe,
                      onLongPress: (m) => _showOptionsBottomSheet(context, m),
                    );
                  },
                );
              }),
            ),

            // Reply Preview Banner
            Obx(() {
              final reply = controller.replyToMessage.value;
              if (reply == null) return const SizedBox.shrink();
              return Container(
                color: Colors.white,
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Container(width: 4, height: 36, color: AppColors.primaryDark),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Replying to', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          Text(reply.text, maxLines: 1, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => controller.replyToMessage.value = null,
                    )
                  ],
                ),
              );
            }),

            // Bottom Input Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              color: Colors.transparent,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.emoji_emotions_outlined, color: AppColors.greyIcon),
                            onPressed: () {},
                          ),
                          Expanded(
                            child: TextField(
                              controller: controller.textController,
                              onChanged: controller.onTextChanged,
                              decoration: const InputDecoration(
                                hintText: 'Message',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 10),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.attach_file, color: AppColors.greyIcon),
                            onPressed: () => _showAttachmentModal(context),
                          ),
                          IconButton(
                            icon: const Icon(Icons.camera_alt, color: AppColors.greyIcon),
                            onPressed: () => controller.sendImageMessage(ImageSource.camera),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.accentGreen,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: controller.sendTextMessage,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showAttachmentModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 250,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: GridView.count(
          crossAxisCount: 3,
          padding: const EdgeInsets.all(16),
          children: [
            _buildAttachmentOption(Icons.insert_drive_file, Colors.purple, 'Document', () {
              Get.back();
              controller.sendDocumentMessage();
            }),
            _buildAttachmentOption(Icons.camera_alt, Colors.pink, 'Camera', () {
              Get.back();
              controller.sendImageMessage(ImageSource.camera);
            }),
            _buildAttachmentOption(Icons.image, Colors.purpleAccent, 'Gallery', () {
              Get.back();
              controller.sendImageMessage(ImageSource.gallery);
            }),
            _buildAttachmentOption(Icons.videocam, Colors.red, 'Video', () {
              Get.back();
              controller.sendVideoMessage();
            }),
            _buildAttachmentOption(Icons.headset, Colors.orange, 'Audio', () {
              Get.back();
            }),
            _buildAttachmentOption(Icons.location_on, Colors.green, 'Location', () {
              Get.back();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption(IconData icon, Color color, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white, size: 26),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  void _showOptionsBottomSheet(BuildContext context, MessageModel message) {
    Get.bottomSheet(
      Container(
        color: Theme.of(context).cardColor,
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.reply),
              title: const Text('Reply'),
              onTap: () {
                Get.back();
                controller.replyToMessage.value = message;
              },
            ),
            ListTile(
              leading: Icon(message.isStarred ? Icons.star : Icons.star_border),
              title: Text(message.isStarred ? 'Unstar' : 'Star'),
              onTap: () {
                Get.back();
                controller.toggleStarMessage(message);
              },
            ),
            ListTile(
              leading: const Icon(Icons.forward),
              title: const Text('Forward'),
              onTap: () {
                Get.back();
                controller.forwardMessage(message);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Get.back();
                controller.deleteMessage(message);
              },
            ),
          ],
        ),
      ),
    );
  }
}
