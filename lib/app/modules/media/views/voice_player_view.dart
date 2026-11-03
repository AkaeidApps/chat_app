import 'package:flutter/material.dart';
import '../../../config/app_colors.dart';

class VoicePlayerView extends StatelessWidget {
  final String audioUrl;
  final String duration;

  const VoicePlayerView({
    super.key,
    required this.audioUrl,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryDark.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: AppColors.primaryDark,
            child: Icon(Icons.play_arrow, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: LinearProgressIndicator(
              value: 0.3,
              backgroundColor: Colors.grey.shade300,
              color: AppColors.accentGreen,
            ),
          ),
          const SizedBox(width: 12),
          Text(duration, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
