import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../global_widgets/custom_avatar.dart';
import '../../home/home_controller.dart';

class ForwardMessageView extends GetView<HomeController> {
  const ForwardMessageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forward message to...'),
      ),
      body: Obx(() {
        final contacts = controller.allContacts;
        return ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            final contact = contacts[index];
            return ListTile(
              leading: CustomAvatar(imageUrl: contact.photoUrl, name: contact.name),
              title: Text(contact.name),
              subtitle: Text(contact.about),
              trailing: const Icon(Icons.send, color: Colors.green),
              onTap: () {
                controller.startNewChat(contact);
                Get.snackbar('Forwarded', 'Message forwarded to ${contact.name}');
              },
            );
          },
        );
      }),
    );
  }
}
