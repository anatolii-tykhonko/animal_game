import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import '../../../services/settings_service.dart';

class VideoRewardOverlay extends StatefulWidget {
  final SettingsService settings;
  final VoidCallback onClose;

  const VideoRewardOverlay({
    super.key,
    required this.settings,
    required this.onClose,
  });

  @override
  State<VideoRewardOverlay> createState() => _VideoRewardOverlayState();
}

class _VideoRewardOverlayState extends State<VideoRewardOverlay> {
  bool _loading = true;
  bool _hasConnection = false;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    final results = await Connectivity().checkConnectivity();
    if (!mounted) return;

    final hasConn = results.any((r) => r != ConnectivityResult.none);
    if (!hasConn) {
      widget.onClose();
      return;
    }
    setState(() {
      _hasConnection = true;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const ColoredBox(
        color: Colors.black87,
        child: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (!_hasConnection) return const SizedBox.shrink();

    final settings = widget.settings;
    final usePlaylist =
        settings.youtubePlaylistId.isNotEmpty ? settings.youtubePlaylistId : null;

    final player = settings.player.buildPlayerWidget(
      videoId: settings.youtubeVideoId,
      playlistId: usePlaylist,
      timeLimitSeconds: settings.videoTimeLimitSeconds,
      onFinished: widget.onClose,
    );

    return Material(
      color: Colors.black,
      child: SafeArea(
        child: Stack(
          children: [
            Center(child: player),
            // Skip button — 80×80, top-right
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: widget.onClose,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.skip_next, color: Colors.white, size: 36),
                      Text(
                        'Skip',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
