import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/app_colors.dart';
import '../../../global_widgets/custom_button.dart';
import '../status_controller.dart';

class CreateTextStatusView extends GetView<StatusController> {
  const CreateTextStatusView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text status'),
        actions: [
          IconButton(
            tooltip: 'Change background',
            onPressed: controller.changeBgColor,
            icon: const Icon(Icons.palette_outlined),
          ),
        ],
      ),
      body: Obx(() {
        final color = Color(int.parse(controller.backgroundColorHex.value));
        return Container(
          color: color,
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: TextField(
                    controller: controller.textStatusController,
                    autofocus: true,
                    maxLength: 700,
                    maxLines: null,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Type a status',
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                      counterStyle: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              ),
              Obx(
                () => CustomButton(
                  text: 'POST STATUS',
                  backgroundColor: AppColors.accentGreen,
                  isLoading: controller.isLoading.value,
                  onPressed: controller.postTextStatus,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
