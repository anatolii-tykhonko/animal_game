import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import '../../services/settings_service.dart';

class VideoRewardPage extends StatefulWidget {
  final SettingsService settings;

  const VideoRewardPage({super.key, required this.settings});

  @override
  State<VideoRewardPage> createState() => _VideoRewardPageState();
}

class _VideoRewardPageState extends State<VideoRewardPage> {
  late final WebViewController _webView;
  Timer? _timer;
  int _remaining = 0;
  bool _done = false;

  // Pretend to be Chrome so YouTube doesn't detect WebView and restrict playback
  static const _userAgent =
      'Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 '
      '(KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36';

  @override
  void initState() {
    super.initState();
    _remaining = widget.settings.videoTimeLimitSeconds;

    _webView = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setUserAgent(_userAgent);

    // Android: allow autoplay with sound without requiring a user gesture
    if (defaultTargetPlatform == TargetPlatform.android) {
      (_webView.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    _webView.loadRequest(Uri.parse(_buildWatchUrl()));

    if (widget.settings.videoTimeLimitSeconds > 0) {
      _timer = Timer.periodic(const Duration(seconds: 1), _onTick);
    }
  }

  String _buildWatchUrl() {
    final playlistId = widget.settings.youtubePlaylistId;
    if (playlistId.isNotEmpty) {
      return 'https://m.youtube.com/playlist?list=$playlistId';
    }
    return 'https://m.youtube.com/watch?v=${widget.settings.youtubeVideoId}';
  }

  void _onTick(Timer timer) {
    if (!mounted) {
      timer.cancel();
      return;
    }
    setState(() => _remaining--);
    if (_remaining <= 0) {
      timer.cancel();
      _close();
    }
  }

  void _close() {
    if (_done) return;
    _done = true;
    _timer?.cancel();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(controller: _webView),

            // Skip button — 80×80, top-right
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: _close,
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

            // Countdown — top-left
            if (widget.settings.videoTimeLimitSeconds > 0 && _remaining > 0)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$_remaining s',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
