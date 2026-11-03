import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../global_widgets/custom_avatar.dart';
import '../../../global_widgets/custom_textfield.dart';
import '../home_controller.dart';

class SearchUsersView extends GetView<HomeController> {
  const SearchUsersView({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: CustomTextField(
          controller: searchController,
          hintText: 'Search contacts...',
          prefixIcon: Icons.search,
          onChanged: (val) {
            controller.searchQuery.value = val;
          },
        ),
      ),
      body: Obx(() {
        final query = controller.searchQuery.value.toLowerCase();
        final filtered = controller.allContacts.where((u) {
          return u.name.toLowerCase().contains(query) ||
              u.phoneNumber.contains(query) ||
              u.email.toLowerCase().contains(query);
        }).toList();

        return ListView.builder(
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final user = filtered[index];
            return ListTile(
              leading: CustomAvatar(imageUrl: user.photoUrl, name: user.name),
              title: Text(user.name),
              subtitle: Text(user.about),
              onTap: () {
                Get.back();
                controller.startNewChat(user);
              },
            );
          },
        );
      }),
    );
  }
}
