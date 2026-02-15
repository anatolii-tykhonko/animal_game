import 'package:flutter/material.dart';

/// Overlay widget for displaying win animation
class WinOverlay extends StatelessWidget {
  const WinOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/green-ok.png',
              width: 150,
              height: 150,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 150,
                );
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Correct!',
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
