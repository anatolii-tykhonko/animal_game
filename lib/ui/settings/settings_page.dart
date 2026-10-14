import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_strings.dart';
import '../../services/language_service.dart';
import '../../services/settings_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final TextEditingController _videoIdController;
  late final TextEditingController _playlistIdController;

  // 0 = unlimited
  static const List<int> _timeLimitOptions = [15, 30, 60, 0];

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsService>();
    _videoIdController = TextEditingController(text: settings.youtubeVideoId);
    _playlistIdController =
        TextEditingController(text: settings.youtubePlaylistId);
  }

  @override
  void dispose() {
    _videoIdController.dispose();
    _playlistIdController.dispose();
    super.dispose();
  }

  String _timeLimitLabel(int seconds, String Function(String) s) {
    if (seconds == 0) return s('timeLimitUnlimited');
    return '$seconds ${_isCyrillic(s('save')) ? 'сек' : 'sec'}';
  }

  bool _isCyrillic(String text) =>
      text.codeUnits.any((c) => c >= 0x0400 && c <= 0x04FF);

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsService>();
    final lang = context.watch<LanguageService>().language;
    String s(String key) => AppStrings.of(lang, key);
    final enabled = settings.videoRewardEnabled;

    return Scaffold(
      appBar: AppBar(
        title: Text(s('settings')),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Video reward section ──────────────────────────────────
          _SectionHeader(s('videoRewardSection')),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: Text(s('videoEnabled')),
                  value: enabled,
                  onChanged: (v) => settings.setVideoEnabled(v),
                  activeColor: Colors.deepPurple,
                ),
                const Divider(height: 1),
                ListTile(
                  title: Text(s('videoTimeLimit')),
                  trailing: DropdownButton<int>(
                    value: settings.videoTimeLimitSeconds,
                    underline: const SizedBox.shrink(),
                    items: _timeLimitOptions
                        .map((sec) => DropdownMenuItem(
                              value: sec,
                              child: Text(_timeLimitLabel(sec, s)),
                            ))
                        .toList(),
                    onChanged: enabled
                        ? (v) => settings.setTimeLimit(v ?? 30)
                        : null,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── YouTube source section ────────────────────────────────
          _SectionHeader(s('youtubeSection')),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Video ID
                  _FieldLabel(s('youtubeVideoId')),
                  const SizedBox(height: 4),
                  _FieldHint(s('youtubeVideoIdHint')),
                  const SizedBox(height: 8),
                  _SaveRow(
                    controller: _videoIdController,
                    enabled: enabled,
                    saveLabel: s('save'),
                    onSave: () =>
                        settings.setVideoId(_videoIdController.text.trim()),
                  ),
                  const SizedBox(height: 20),

                  // Playlist ID
                  _FieldLabel(s('youtubePlaylistId')),
                  const SizedBox(height: 4),
                  _FieldHint(s('youtubePlaylistIdHint')),
                  const SizedBox(height: 8),
                  _SaveRow(
                    controller: _playlistIdController,
                    enabled: enabled,
                    saveLabel: s('save'),
                    onSave: () => settings
                        .setPlaylistId(_playlistIdController.text.trim()),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    s('playlistPriority'),
                    style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600),
      );
}

class _FieldHint extends StatelessWidget {
  final String text;
  const _FieldHint(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      );
}

class _SaveRow extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final String saveLabel;
  final VoidCallback onSave;

  const _SaveRow({
    required this.controller,
    required this.enabled,
    required this.saveLabel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            enabled: enabled,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: enabled ? onSave : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
          child: Text(saveLabel),
        ),
      ],
    );
  }
}
