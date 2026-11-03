import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../../global_widgets/custom_button.dart';
import '../../../global_widgets/custom_textfield.dart';
import '../auth_controller.dart';

class PhoneLoginView extends GetView<AuthController> {
  const PhoneLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter your phone number'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'WhatsApp will send an SMS message to verify your phone number.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondaryLight),
            ),
            const SizedBox(height: 32),
            CustomTextField(
              controller: controller.phoneController,
              hintText: '+1 234 567 8900',
              prefixIcon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            const Spacer(),
            Obx(
              () => CustomButton(
                text: 'NEXT',
                isLoading: controller.isLoading.value,
                onPressed: controller.sendPhoneOtp,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'This site is protected by reCAPTCHA and the Google '
              'Privacy Policy (policies.google.com/privacy) and '
              'Terms of Service (policies.google.com/terms) apply.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
