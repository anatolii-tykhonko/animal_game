import 'package:flutter/material.dart';

/// Widget showing dragon progress animation (0-10 steps)
class DragonProgress extends StatelessWidget {
  final int dragonSteps; // 0 to 10

  const DragonProgress({
    super.key,
    required this.dragonSteps,
  });

  @override
  Widget build(BuildContext context) {
    // Clamp dragon steps between 0 and 10
    final steps = dragonSteps.clamp(0, 10);
    final progress = steps / 10.0; // 0.0 to 1.0

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      color: Colors.white,
      child: Column(
        children: [
          // Progress bar with dragon
          LayoutBuilder(
            builder: (context, constraints) {
              final trackWidth = constraints.maxWidth;
              final dragonSize = 30.0;
              final dragonPosition = (trackWidth - dragonSize) * progress;

              return Stack(
                children: [
                  // Background track
                  Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey[400]!),
                    ),
                  ),
                  // Progress fill
                  FractionallySizedBox(
                    widthFactor: progress,
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.green[400],
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  // Dragon icon (moves along the track with animation)
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    left: dragonPosition,
                    top: 0,
                    child: Container(
                      width: dragonSize,
                      height: dragonSize,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.orange[800]!, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.5),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.pets,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  // Finish line flag at the end
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: dragonSize,
                      height: dragonSize,
                      decoration: BoxDecoration(
                        color: Colors.red[600],
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: const Icon(
                        Icons.flag,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 8),
          // Steps counter
          Text(
            'Steps: $steps/10',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
