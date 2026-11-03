import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/home_controller.dart';
import '../../../global_widgets/empty_state.dart';

class StarredMessagesView extends GetView<HomeController> {
  const StarredMessagesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Starred Messages'),
      ),
      body: const EmptyState(
        icon: Icons.star_border,
        title: 'No Starred Messages',
        subtitle: 'Tap and hold on any message in any chat to star it, so you can easily find it later.',
      ),
    );
  }
}
