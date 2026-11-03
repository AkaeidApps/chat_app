import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/app_colors.dart';
import '../config/app_routes.dart';

/// Fallback screen shown when navigation targets an unregistered route.
///
/// Rendering this instead of an empty page avoids the "white blank screen"
/// that otherwise appears when a route name is missing from [AppPages].
class NotFoundView extends StatelessWidget {
  const NotFoundView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Not found')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.explore_off,
                  size: 56, color: AppColors.primaryDark),
              const SizedBox(height: 16),
              const Text(
                'This screen could not be found.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                Get.currentRoute,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondaryLight),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Get.offAllNamed(AppRoutes.SPLASH),
                child: const Text('Go back to start'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
