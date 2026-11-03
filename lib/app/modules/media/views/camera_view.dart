import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../config/app_colors.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _openCamera();
  }

  void _openCamera() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.camera);
    if (file != null) {
      Get.toNamed('/image-preview', arguments: file.path);
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: const Center(
        child: CircularProgressIndicator(color: AppColors.accentGreen),
      ),
    );
  }
}
