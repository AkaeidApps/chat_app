import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/app_routes.dart';
import '../home_controller.dart';
import 'chats_tab_view.dart';
import 'status_tab_view.dart';
import 'calls_tab_view.dart';

class HomeDashboardView extends GetView<HomeController> {
  const HomeDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'WhatsApp',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined),
            onPressed: () => Get.toNamed(AppRoutes.CAMERA),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Get.toNamed(AppRoutes.SEARCH_USERS),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'new_group') Get.toNamed(AppRoutes.CREATE_GROUP);
              if (value == 'starred') Get.toNamed(AppRoutes.STARRED_MESSAGES);
              if (value == 'settings') Get.toNamed(AppRoutes.MY_PROFILE);
              if (value == 'logout') controller.logout();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'new_group', child: Text('New group')),
              const PopupMenuItem(value: 'starred', child: Text('Starred messages')),
              const PopupMenuItem(value: 'settings', child: Text('Settings')),
              const PopupMenuItem(value: 'logout', child: Text('Log out')),
            ],
          )
        ],
        bottom: TabBar(
          controller: controller.tabController,
          tabs: const [
            Tab(text: 'CHATS'),
            Tab(text: 'STATUS'),
            Tab(text: 'CALLS'),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: const [
          ChatsTabView(),
          StatusTabView(),
          CallsTabView(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          int index = controller.tabController.index;
          if (index == 0) {
            Get.toNamed(AppRoutes.NEW_CONVERSATION);
          } else if (index == 1) {
            Get.toNamed(AppRoutes.CREATE_IMAGE_STATUS);
          } else {
            Get.toNamed(AppRoutes.CONTACTS);
          }
        },
        child: AnimatedBuilder(
          animation: controller.tabController,
          builder: (context, _) {
            int index = controller.tabController.index;
            if (index == 1) return const Icon(Icons.camera_alt);
            if (index == 2) return const Icon(Icons.add_call);
            return const Icon(Icons.chat);
          },
        ),
      ),
    );
  }
}
