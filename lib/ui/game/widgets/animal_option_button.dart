import 'package:flutter/material.dart';
import '../../../models/animal.dart';
import '../../../l10n/app_strings.dart';

class AnimalOptionButton extends StatelessWidget {
  final Animal animal;
  final bool isPictureMode;
  final AppLanguage language;
  final VoidCallback? onTap;

  const AnimalOptionButton({
    super.key,
    required this.animal,
    required this.isPictureMode,
    required this.language,
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
                return const Icon(Icons.image, size: 50);
              },
            )
          : Text(
              AppStrings.of(language, animal.id),
              style: const TextStyle(fontSize: 24),
            ),
    );
  }
}
