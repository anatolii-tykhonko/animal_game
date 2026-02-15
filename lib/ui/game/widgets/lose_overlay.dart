import 'package:flutter/material.dart';

/// Overlay widget for displaying lose animation
class LoseOverlay extends StatelessWidget {
  const LoseOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/red-no.png',
              width: 150,
              height: 150,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.close,
                  color: Colors.red,
                  size: 150,
                );
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Try Again!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
