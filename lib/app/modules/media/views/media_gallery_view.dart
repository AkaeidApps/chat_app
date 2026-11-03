import 'package:flutter/material.dart';

class MediaGalleryView extends StatelessWidget {
  const MediaGalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Media Gallery')),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: 15,
        itemBuilder: (context, index) {
          return Container(
            color: Colors.grey.shade300,
            child: const Icon(Icons.image, color: Colors.grey),
          );
        },
      ),
    );
  }
}
