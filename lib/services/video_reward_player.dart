import 'package:flutter/widgets.dart';

abstract class VideoRewardPlayer {
  Widget buildPlayerWidget({
    required String videoId,
    String? playlistId,
    required int timeLimitSeconds,
    required VoidCallback onFinished,
  });
}
