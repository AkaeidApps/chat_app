import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import 'custom_avatar.dart';

class StatusRing extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final bool hasUnseenStatus;
  final int statusCount;
  final VoidCallback onTap;

  const StatusRing({
    super.key,
    this.imageUrl,
    required this.name,
    this.hasUnseenStatus = true,
    this.statusCount = 1,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color ringColor = hasUnseenStatus ? AppColors.accentGreen : Colors.grey.shade400;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(2.5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: ringColor, width: 2.5),
            ),
            child: CustomAvatar(
              imageUrl: imageUrl,
              name: name,
              radius: 26,
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 64,
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          )
        ],
      ),
    );
  }
}
