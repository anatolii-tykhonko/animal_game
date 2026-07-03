import 'dart:async';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'video_reward_player.dart';

class YoutubeVideoRewardPlayer implements VideoRewardPlayer {
  @override
  Widget buildPlayerWidget({
    required String videoId,
    String? playlistId,
    required int timeLimitSeconds,
    required VoidCallback onFinished,
  }) {
    return _YoutubeRewardWidget(
      videoId: videoId,
      playlistId: playlistId,
      timeLimitSeconds: timeLimitSeconds,
      onFinished: onFinished,
    );
  }
}

class _YoutubeRewardWidget extends StatefulWidget {
  final String videoId;
  final String? playlistId;
  final int timeLimitSeconds;
  final VoidCallback onFinished;

  const _YoutubeRewardWidget({
    required this.videoId,
    this.playlistId,
    required this.timeLimitSeconds,
    required this.onFinished,
  });

  @override
  State<_YoutubeRewardWidget> createState() => _YoutubeRewardWidgetState();
}

class _YoutubeRewardWidgetState extends State<_YoutubeRewardWidget> {
  late final YoutubePlayerController _controller;
  StreamSubscription<YoutubePlayerValue>? _stateSub;
  Timer? _timer;
  int _remaining = 0;
  bool _finished = false;
  bool _playlistLoaded = false;

  static const _params = YoutubePlayerParams(
    showControls: false,
    showFullscreenButton: false,
    playsInline: true,
    mute: false,
    strictRelatedVideos: true,
  );

  @override
  void initState() {
    super.initState();
    _remaining = widget.timeLimitSeconds;

    final usePlaylist =
        widget.playlistId != null && widget.playlistId!.isNotEmpty;

    if (usePlaylist) {
      _controller = YoutubePlayerController(params: _params);
      // Load playlist once player reports unStarted (WebView ready)
      _stateSub = _controller.stream.listen(_onPlayerState);
    } else {
      _controller = YoutubePlayerController.fromVideoId(
        videoId: widget.videoId,
        autoPlay: true,
        params: _params,
      );
      _stateSub = _controller.stream.listen(_onPlayerState);
    }

    if (widget.timeLimitSeconds > 0) {
      _timer = Timer.periodic(const Duration(seconds: 1), _onTick);
    }
  }

  void _onPlayerState(YoutubePlayerValue value) {
    // Load playlist on first unStarted event (player WebView is ready)
    if (!_playlistLoaded &&
        value.playerState == PlayerState.unStarted &&
        widget.playlistId != null &&
        widget.playlistId!.isNotEmpty) {
      _playlistLoaded = true;
      _controller.setShuffle(shufflePlaylists: true).then((_) {
        _controller.loadPlaylist(
          list: [widget.playlistId!],
          listType: ListType.playlist,
        );
      });
    }

    if (value.playerState == PlayerState.ended && !_finished) {
      _finish();
    }
  }

  void _onTick(Timer timer) {
    if (!mounted) {
      timer.cancel();
      return;
    }
    setState(() => _remaining--);
    if (_remaining <= 0) {
      timer.cancel();
      _finish();
    }
  }

  void _finish() {
    if (_finished) return;
    _finished = true;
    widget.onFinished();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stateSub?.cancel();
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerScaffold(
      controller: _controller,
      builder: (context, player) => player,
    );
  }
}
