import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../global_widgets/custom_button.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                'Simple. Reliable. Secure.',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'With WhatsApp, you get fast, simple, secure messaging and calling for free, available on phones all over the world.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 14),
              ),
              const Spacer(),
              const Icon(Icons.security, size: 120, color: AppColors.accentGreen),
              const Spacer(),
              CustomButton(
                text: 'GET STARTED',
                backgroundColor: AppColors.accentGreen,
                onPressed: () => Get.offAllNamed(AppRoutes.WELCOME),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
