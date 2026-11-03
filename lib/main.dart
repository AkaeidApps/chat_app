import 'dart:async';

import 'package:chat_app/app/modules/home/views/home_dashboard_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'app/config/app_pages.dart';
import 'app/config/app_colors.dart';
import 'app/config/app_theme.dart';
import 'app/data/services/hive_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Paint a themed splash immediately. Initialization happens inside the
  // widget tree so a slow (or hanging) plugin can never leave the user
  // staring at a blank white window.
  runApp(const BootstrapApp());
}

/// Shows a splash while Firebase and local storage are initialized, then
/// swaps to [ChatApp] (or a readable error screen if startup fails).
class BootstrapApp extends StatefulWidget {
  const BootstrapApp({super.key});

  @override
  State<BootstrapApp> createState() => _BootstrapAppState();
}

class _BootstrapAppState extends State<BootstrapApp> {
  Widget? _app;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    Widget next;
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ).timeout(const Duration(seconds: 20));
      await Get.putAsync<HiveService>(() => HiveService().init())
          .timeout(const Duration(seconds: 20));
      next = const ChatApp();
    } on TimeoutException {
      next = const FirebaseSetupApp(
        title: 'Startup timed out',
        description:
            'The app could not finish initializing. Check your network and '
            'Firebase configuration, then restart the app.',
        message: 'Initialization did not complete within 20 seconds.',
      );
    } on PlatformException catch (error) {
      next = FirebaseSetupApp(message: error.message ?? error.code);
    } catch (error) {
      next = FirebaseSetupApp(
        title: 'App startup failed',
        description: 'The app could not finish initializing.',
        message: error.toString(),
      );
    }

    if (!mounted) return;
    setState(() => _app = next);
  }

  @override
  Widget build(BuildContext context) {
    return _app ?? const _StartupSplash();
  }
}

class _StartupSplash extends StatelessWidget {
  const _StartupSplash();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: Center(
          child: SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryDark),
            ),
          ),
        ),
      ),
    );
  }
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'WhatsApp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      unknownRoute: GetPage(
        name: '/not-found',
        page: () => HomeDashboardView(),
      ),
    );
  }
}

class FirebaseSetupApp extends StatelessWidget {
  const FirebaseSetupApp({
    required this.message,
    this.title = 'Firebase setup required',
    this.description =
        'Add the Firebase configuration for this app, then restart it.',
    super.key,
  });

  final String message;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.cloud_off,
                      size: 56, color: Color(0xFF075E54)),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(description, textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  SelectableText(message, textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
