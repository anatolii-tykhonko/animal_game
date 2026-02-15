import 'package:flutter/material.dart';
import '../../../models/animal.dart';

/// Widget for displaying animal option buttons (picture or text)
class AnimalOptionButton extends StatelessWidget {
  final Animal animal;
  final bool isPictureMode;
  final VoidCallback? onTap;

  const AnimalOptionButton({
    super.key,
    required this.animal,
    required this.isPictureMode,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16),
      ),
      child: isPictureMode
          ? Image.asset(
              animal.imageAsset,
              width: 50,
              height: 50,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                debugPrint('Error loading image: ${animal.imageAsset}');
                debugPrint('Error: $error');
                return const Icon(Icons.image, size: 50);
              },
            )
          : Text(
              animal.name,
              style: const TextStyle(fontSize: 24),
            ),
    );
  }
}
