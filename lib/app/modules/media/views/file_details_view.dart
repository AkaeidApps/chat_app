import 'package:flutter/material.dart';
import '../../../config/app_colors.dart';

class FileDetailsView extends StatelessWidget {
  const FileDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('File Details')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: const [
            Icon(Icons.insert_drive_file, size: 80, color: AppColors.primaryDark),
            SizedBox(height: 16),
            Text('Project_Document.pdf', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Size: 2.4 MB · Format: PDF', style: TextStyle(color: AppColors.textSecondaryLight)),
          ],
        ),
      ),
    );
  }
}
