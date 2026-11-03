import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../global_widgets/custom_avatar.dart';
import '../home_controller.dart';

class NewConversationView extends GetView<HomeController> {
  const NewConversationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Chat'),
      ),
      body: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppColors.accentGreen,
              child: Icon(Icons.group, color: Colors.white),
            ),
            title: const Text('New group', style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () => Get.toNamed(AppRoutes.CREATE_GROUP),
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppColors.accentGreen,
              child: Icon(Icons.person_add, color: Colors.white),
            ),
            title: const Text('New contact', style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () => Get.toNamed(AppRoutes.CONTACTS),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Contacts on WhatsApp',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondaryLight),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              final contacts = controller.allContacts;
              return ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  return ListTile(
                    leading: CustomAvatar(
                      imageUrl: contact.photoUrl,
                      name: contact.name,
                      isOnline: contact.isOnline,
                    ),
                    title: Text(contact.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(contact.about, maxLines: 1, overflow: TextOverflow.ellipsis),
                    onTap: () {
                      Get.back();
                      controller.startNewChat(contact);
                    },
                  );
                },
              );
            }),
          )
        ],
      ),
    );
  }
}
