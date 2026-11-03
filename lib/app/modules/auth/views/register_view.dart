import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../global_widgets/custom_button.dart';
import '../../../global_widgets/custom_textfield.dart';
import '../auth_controller.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            CustomTextField(
              controller: controller.nameController,
              hintText: 'Full Name',
              prefixIcon: Icons.person,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: controller.emailController,
              hintText: 'Email address',
              prefixIcon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: controller.passwordController,
              hintText: 'Password',
              prefixIcon: Icons.lock,
              obscureText: true,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: controller.aboutController,
              hintText: 'About / Status',
              prefixIcon: Icons.info_outline,
            ),
            const SizedBox(height: 40),
            Obx(
              () => CustomButton(
                text: 'CONTINUE',
                isLoading: controller.isLoading.value,
                onPressed: controller.registerWithEmail,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
