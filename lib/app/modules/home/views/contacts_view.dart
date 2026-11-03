import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../global_widgets/custom_avatar.dart';
import '../home_controller.dart';

class ContactsView extends GetView<HomeController> {
  const ContactsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Contact'),
            Obx(() => Text(
                  '${controller.allContacts.length} contacts',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                )),
          ],
        ),
      ),
      body: Obx(() {
        final contacts = controller.allContacts;
        return ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            final contact = contacts[index];
            return ListTile(
              leading: CustomAvatar(
                imageUrl: contact.photoUrl,
                name: contact.name,
                radius: 22,
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
    );
  }
}
