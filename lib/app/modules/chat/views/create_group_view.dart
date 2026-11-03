import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../global_widgets/custom_avatar.dart';
import '../../../global_widgets/custom_button.dart';
import '../../../global_widgets/custom_textfield.dart';
import '../../home/home_controller.dart';
import '../../../data/repositories/chat_repository.dart';
import '../../../data/repositories/auth_repository.dart';

class CreateGroupView extends StatefulWidget {
  const CreateGroupView({super.key});

  @override
  State<CreateGroupView> createState() => _CreateGroupViewState();
}

class _CreateGroupViewState extends State<CreateGroupView> {
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final ChatRepository _chatRepository = ChatRepository();
  final AuthRepository _authRepository = AuthRepository();
  final HomeController homeController = Get.find<HomeController>();

  final List<String> selectedMemberIds = [];
  bool isLoading = false;

  void createGroup() async {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter a group subject');
      return;
    }
    if (selectedMemberIds.isEmpty) {
      Get.snackbar('Error', 'Please select at least 1 member');
      return;
    }

    setState(() => isLoading = true);
    try {
      final creatorUid = _authRepository.currentUser!.uid;
      final groupId = await _chatRepository.createGroupChat(
        creatorUid: creatorUid,
        name: nameController.text.trim(),
        description: descController.text.trim(),
        memberIds: selectedMemberIds,
      );

      setState(() => isLoading = false);
      Get.offNamed('/group-chat', arguments: {'chatId': groupId});
    } catch (e) {
      setState(() => isLoading = false);
      Get.snackbar('Error', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New group'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              controller: nameController,
              hintText: 'Group subject',
              prefixIcon: Icons.group,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: descController,
              hintText: 'Group description (optional)',
              prefixIcon: Icons.description,
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Members',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Obx(() {
              final contacts = homeController.allContacts;
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  final isSelected = selectedMemberIds.contains(contact.uid);

                  return CheckboxListTile(
                    value: isSelected,
                    onChanged: (val) {
                      setState(() {
                        if (val == true) {
                          selectedMemberIds.add(contact.uid);
                        } else {
                          selectedMemberIds.remove(contact.uid);
                        }
                      });
                    },
                    secondary: CustomAvatar(imageUrl: contact.photoUrl, name: contact.name),
                    title: Text(contact.name),
                    subtitle: Text(contact.about),
                  );
                },
              );
            }),
            const SizedBox(height: 32),
            CustomButton(
              text: 'CREATE GROUP',
              isLoading: isLoading,
              onPressed: createGroup,
            ),
          ],
        ),
      ),
    );
  }
}
