import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../../global_widgets/custom_button.dart';
import '../../../global_widgets/custom_textfield.dart';
import '../auth_controller.dart';

class OtpVerificationView extends GetView<AuthController> {
  const OtpVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Phone Number'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'Waiting to automatically detect an SMS sent to your phone number.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondaryLight),
            ),
            const SizedBox(height: 32),
            CustomTextField(
              controller: controller.otpController,
              hintText: '6-digit code',
              prefixIcon: Icons.security,
              keyboardType: TextInputType.number,
            ),
            const Spacer(),
            Obx(
              () => CustomButton(
                text: 'VERIFY',
                isLoading: controller.isLoading.value,
                onPressed: controller.verifyOtp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
