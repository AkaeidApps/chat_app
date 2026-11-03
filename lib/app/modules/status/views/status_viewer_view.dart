import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../../data/models/status_model.dart';
import '../status_controller.dart';

class StatusViewerView extends StatefulWidget {
  const StatusViewerView({super.key});

  @override
  State<StatusViewerView> createState() => _StatusViewerViewState();
}

class _StatusViewerViewState extends State<StatusViewerView> {
  late final StatusController controller = Get.find<StatusController>();
  late final UserStatusModel status = Get.arguments as UserStatusModel;

  @override
  void initState() {
    super.initState();
    if (status.items.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.markViewed(status.userId, status.items.first.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(status.userName),
      ),
      body: status.items.isEmpty
          ? const Center(
              child: Text('This status has expired.',
                  style: TextStyle(color: Colors.white70)),
            )
          : PageView.builder(
              itemCount: status.items.length,
              onPageChanged: (index) =>
                  controller.markViewed(status.userId, status.items[index].id),
              itemBuilder: (context, index) {
                final item = status.items[index];
                if (item.type == 'text') {
                  return ColoredBox(
                    color: Color(
                        int.tryParse(item.backgroundColorHex) ?? 0xFF075E54),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(28),
                        child: Text(
                          item.content,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  );
                }
                if (item.type == 'video') {
                  return _StatusVideo(url: item.content);
                }
                return Center(
                  child: CachedNetworkImage(
                    imageUrl: item.content,
                    fit: BoxFit.contain,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(
                        Icons.broken_image,
                        color: Colors.white,
                        size: 48),
                  ),
                );
              },
            ),
    );
  }
}

class _StatusVideo extends StatefulWidget {
  const _StatusVideo({required this.url});

  final String url;

  @override
  State<_StatusVideo> createState() => _StatusVideoState();
}

class _StatusVideoState extends State<_StatusVideo> {
  late final VideoPlayerController _player =
      VideoPlayerController.networkUrl(Uri.parse(widget.url));

  @override
  void initState() {
    super.initState();
    _player.initialize().then((_) {
      if (mounted) setState(() {});
      _player.play();
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_player.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return Center(
      child: AspectRatio(
        aspectRatio: _player.value.aspectRatio,
        child: VideoPlayer(_player),
      ),
    );
  }
}
