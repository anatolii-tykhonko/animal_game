import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'video_reward_player.dart';
import 'youtube_video_reward_player.dart';

class SettingsService extends ChangeNotifier {
  static const _keyEnabled = 'settings_video_enabled';
  static const _keyTimeLimit = 'settings_video_time_limit';
  static const _keyVideoId = 'settings_video_id';
  static const _keyPlaylistId = 'settings_playlist_id';

  static const String defaultVideoId = '5Sj3lgwt_3I';
  static const String defaultPlaylistId = 'PLdUropL5xSMjNyLvskAFn4AzT9WaxVRCf';

  bool videoRewardEnabled = true;
  int videoTimeLimitSeconds = 30;
  String youtubeVideoId = defaultVideoId;
  String youtubePlaylistId = defaultPlaylistId;

  VideoRewardPlayer get player => YoutubeVideoRewardPlayer();

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    videoRewardEnabled = prefs.getBool(_keyEnabled) ?? true;
    videoTimeLimitSeconds = prefs.getInt(_keyTimeLimit) ?? 30;
    youtubeVideoId = prefs.getString(_keyVideoId) ?? defaultVideoId;
    youtubePlaylistId = prefs.getString(_keyPlaylistId) ?? defaultPlaylistId;
    notifyListeners();
  }

  Future<void> setVideoEnabled(bool value) async {
    videoRewardEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyEnabled, value);
  }

  Future<void> setTimeLimit(int seconds) async {
    videoTimeLimitSeconds = seconds;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyTimeLimit, seconds);
  }

  Future<void> setVideoId(String id) async {
    youtubeVideoId = id;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyVideoId, id);
  }

  Future<void> setPlaylistId(String id) async {
    youtubePlaylistId = id;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPlaylistId, id);
  }
}
