import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:animal_game/ui/game/widgets/dragon_progress.dart';

void main() {
  Widget wrap(Widget child) =>
      MaterialApp(home: Scaffold(body: child));

  group('DragonProgress', () {
    testWidgets('shows correct steps text in English', (tester) async {
      await tester.pumpWidget(wrap(
        const DragonProgress(dragonSteps: 5, stepsLabel: 'Steps'),
      ));
      expect(find.text('Steps: 5/10'), findsOneWidget);
    });

    testWidgets('shows correct steps text in Ukrainian', (tester) async {
      await tester.pumpWidget(wrap(
        const DragonProgress(dragonSteps: 3, stepsLabel: 'Кроки'),
      ));
      expect(find.text('Кроки: 3/10'), findsOneWidget);
    });

    testWidgets('shows 0/10 at the start', (tester) async {
      await tester.pumpWidget(wrap(
        const DragonProgress(dragonSteps: 0, stepsLabel: 'Steps'),
      ));
      expect(find.text('Steps: 0/10'), findsOneWidget);
    });

    testWidgets('shows 10/10 when completed', (tester) async {
      await tester.pumpWidget(wrap(
        const DragonProgress(dragonSteps: 10, stepsLabel: 'Steps'),
      ));
      expect(find.text('Steps: 10/10'), findsOneWidget);
    });

    testWidgets('clamps values above 10 to 10', (tester) async {
      await tester.pumpWidget(wrap(
        const DragonProgress(dragonSteps: 15, stepsLabel: 'Steps'),
      ));
      expect(find.text('Steps: 10/10'), findsOneWidget);
    });

    testWidgets('clamps negative values to 0', (tester) async {
      await tester.pumpWidget(wrap(
        const DragonProgress(dragonSteps: -3, stepsLabel: 'Steps'),
      ));
      expect(find.text('Steps: 0/10'), findsOneWidget);
    });
  });
}
