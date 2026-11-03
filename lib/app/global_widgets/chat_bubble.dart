import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../config/app_colors.dart';
import '../data/models/message_model.dart';

class ChatBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMe;
  final Function(MessageModel)? onLongPress;
  final Function(String emoji)? onReactionSelect;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.onLongPress,
    this.onReactionSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final timeStr = DateFormat('h:mm a').format(message.timestamp);

    Color bg = isMe
        ? (isDark ? AppColors.outgoingBubbleDark : AppColors.outgoingBubbleLight)
        : (isDark ? AppColors.incomingBubbleDark : AppColors.incomingBubbleLight);

    Color textColor = isDark ? Colors.white : AppColors.textPrimaryLight;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () {
          if (onLongPress != null) onLongPress!(message);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft: Radius.circular(isMe ? 12 : 2),
              bottomRight: Radius.circular(isMe ? 2 : 12),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 2,
                offset: const Offset(0, 1),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Reply Preview
              if (message.replyToText != null && message.replyToText!.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(6),
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(6),
                    border: const Border(
                      left: BorderSide(color: AppColors.primaryDark, width: 3),
                    ),
                  ),
                  child: Text(
                    message.replyToText!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: textColor.withValues(alpha: 0.8),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),

              // Media Content
              if (message.type == 'image' && message.mediaUrl != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: message.mediaUrl!,
                      placeholder: (context, url) => Container(
                        height: 180,
                        color: Colors.black12,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 50),
                    ),
                  ),
                ),

              if (message.type == 'document')
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.insert_drive_file, color: AppColors.primaryDark, size: 30),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.fileName ?? 'Document',
                            style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (message.fileSize != null)
                            Text(
                              message.fileSize!,
                              style: TextStyle(fontSize: 11, color: textColor.withValues(alpha: 0.6)),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

              if (message.type == 'audio')
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.primaryDark,
                      child: Icon(Icons.play_arrow, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.primaryDark.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      message.audioDuration ?? '0:15',
                      style: TextStyle(fontSize: 11, color: textColor.withValues(alpha: 0.7)),
                    ),
                  ],
                ),

              // Message Text
              if (message.text.isNotEmpty)
                Text(
                  message.isDeleted ? 'This message was deleted' : message.text,
                  style: TextStyle(
                    fontSize: 15,
                    color: message.isDeleted ? Colors.grey : textColor,
                    fontStyle: message.isDeleted ? FontStyle.italic : FontStyle.normal,
                  ),
                ),

              const SizedBox(height: 4),

              // Timestamp & Status Ticks
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Spacer(),
                  if (message.isEdited)
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Text(
                        'Edited',
                        style: TextStyle(fontSize: 10, color: textColor.withValues(alpha: 0.6)),
                      ),
                    ),
                  Text(
                    timeStr,
                    style: TextStyle(
                      fontSize: 11,
                      color: textColor.withValues(alpha: 0.6),
                    ),
                  ),
                  if (isMe) ...[
                    const SizedBox(width: 4),
                    _buildTick(message.status),
                  ]
                ],
              ),

              // Reactions Display
              if (message.reactions != null && message.reactions!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Wrap(
                    spacing: 4,
                    children: message.reactions!.values.map((emoji) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(emoji, style: const TextStyle(fontSize: 12)),
                      );
                    }).toList(),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTick(MessageStatus status) {
    if (status == MessageStatus.read) {
      return const Icon(Icons.done_all, size: 16, color: AppColors.tickBlue);
    } else if (status == MessageStatus.delivered) {
      return const Icon(Icons.done_all, size: 16, color: AppColors.tickGrey);
    } else {
      return const Icon(Icons.done, size: 16, color: AppColors.tickGrey);
    }
  }
}
