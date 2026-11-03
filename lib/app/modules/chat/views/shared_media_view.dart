import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../chat_controller.dart';

class SharedMediaView extends GetView<ChatController> {
  const SharedMediaView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Media, Links, and Docs'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'MEDIA'),
              Tab(text: 'DOCS'),
              Tab(text: 'LINKS'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Media Grid
            Obx(() {
              final mediaList = controller.messages
                  .where((m) => m.type == 'image' || m.type == 'video')
                  .toList();

              return GridView.builder(
                padding: const EdgeInsets.all(4),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: mediaList.length,
                itemBuilder: (context, index) {
                  final msg = mediaList[index];
                  return CachedNetworkImage(
                    imageUrl: msg.mediaUrl ?? '',
                    fit: BoxFit.cover,
                  );
                },
              );
            }),
            // Docs List
            Obx(() {
              final docList = controller.messages.where((m) => m.type == 'document').toList();
              return ListView.builder(
                itemCount: docList.length,
                itemBuilder: (context, index) {
                  final msg = docList[index];
                  return ListTile(
                    leading: const Icon(Icons.insert_drive_file),
                    title: Text(msg.fileName ?? 'Document'),
                    subtitle: Text(msg.fileSize ?? ''),
                  );
                },
              );
            }),
            const Center(child: Text('No shared links')),
          ],
        ),
      ),
    );
  }
}
