import 'package:flutter/material.dart';
import '/services/audio_service.dart';

class SoundCard extends StatelessWidget {
  /// Audio file path relative to assets/audio/ folder (e.g., "cow.wav")
  final String audioPath;
  final AudioService? audioService;
  final String? imageAsset;
  final String tapLabel;

  const SoundCard({
    super.key,
    required this.audioPath,
    required this.tapLabel,
    this.audioService,
    this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final service = audioService ?? AudioService();
        await service.stop();
        await Future.delayed(const Duration(milliseconds: 100));
        await service.playAudio(audioPath);
        if (audioService == null) {
          service.dispose();
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (imageAsset != null)
            Image.asset(
              imageAsset!,
              width: 120,
              height: 120,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.pets, size: 120, color: Colors.grey),
            ),
          if (imageAsset != null) const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.volume_up,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            tapLabel,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
