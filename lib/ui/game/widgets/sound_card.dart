import 'package:flutter/material.dart';
import '/services/audio_service.dart';

/// Widget for displaying sound icon/button
/// Plays audio from assets/audio/ folder when tapped
/// Stops any currently playing audio and restarts it
class SoundCard extends StatelessWidget {
  /// Audio file path relative to assets/audio/ folder (e.g., "cow.wav", "dog.wav")
  final String audioPath;
  
  /// Optional AudioService instance. If not provided, creates a new one.
  final AudioService? audioService;

  const SoundCard({
    super.key,
    required this.audioPath,
    this.audioService,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final service = audioService ?? AudioService();
        // Stop any currently playing audio
        await service.stop();
        // Small delay to ensure stop completes, then play again
        await Future.delayed(const Duration(milliseconds: 100));
        // Play the audio again
        await service.playAudio(audioPath);
        // Dispose if we created a new service
        if (audioService == null) {
          service.dispose();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.volume_up,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}
