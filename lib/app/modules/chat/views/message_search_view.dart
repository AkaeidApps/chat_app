import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../global_widgets/custom_textfield.dart';
import '../chat_controller.dart';
import '../../../global_widgets/chat_bubble.dart';

class MessageSearchView extends GetView<ChatController> {
  const MessageSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final queryController = TextEditingController();
    var query = ''.obs;

    return Scaffold(
      appBar: AppBar(
        title: CustomTextField(
          controller: queryController,
          hintText: 'Search in chat...',
          prefixIcon: Icons.search,
          onChanged: (val) => query.value = val,
        ),
      ),
      body: Obx(() {
        if (query.value.isEmpty) {
          return const Center(child: Text('Search for text in this conversation'));
        }
        final results = controller.messages
            .where((m) => m.text.toLowerCase().contains(query.value.toLowerCase()))
            .toList();

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final msg = results[index];
            return ChatBubble(message: msg, isMe: msg.senderId != controller.peerUser.value?.uid);
          },
        );
      }),
    );
  }
}
