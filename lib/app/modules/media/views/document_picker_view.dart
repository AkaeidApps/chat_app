import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../../../config/app_colors.dart';

class DocumentPickerView extends StatelessWidget {
  const DocumentPickerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pick Document')),
      body: Center(
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryDark),
          icon: const Icon(Icons.folder_open, color: Colors.white),
          label: const Text('Choose Document', style: TextStyle(color: Colors.white)),
          onPressed: () async {
            final pickedFile = await FilePicker.pickFile();
            if (pickedFile != null) {
              Get.back(result: pickedFile);
            }
          },
        ),
      ),
    );
  }
}
