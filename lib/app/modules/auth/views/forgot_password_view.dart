import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../../global_widgets/custom_button.dart';
import '../../../global_widgets/custom_textfield.dart';
import '../auth_controller.dart';

class ForgotPasswordView extends GetView<AuthController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'Enter your email address to receive a password reset link.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondaryLight),
            ),
            const SizedBox(height: 32),
            CustomTextField(
              controller: controller.emailController,
              hintText: 'Email address',
              prefixIcon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            const Spacer(),
            Obx(
              () => CustomButton(
                text: 'SEND RESET LINK',
                isLoading: controller.isLoading.value,
                onPressed: controller.resetPassword,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
