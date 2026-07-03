import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:animal_game/ui/game/widgets/completion_overlay.dart';

void main() {
  Widget wrap(Widget child) =>
      MaterialApp(home: Scaffold(body: Stack(children: [child])));

  CompletionOverlay makeOverlay({
    VoidCallback? onRestart,
    VoidCallback? onClose,
    String title = 'Congratulations!',
    String subtitle = 'You reached the finish!',
    String playAgainLabel = 'Play Again',
    String closeLabel = 'Close',
  }) =>
      CompletionOverlay(
        onRestart: onRestart ?? () {},
        onClose: onClose ?? () {},
        title: title,
        subtitle: subtitle,
        playAgainLabel: playAgainLabel,
        closeLabel: closeLabel,
      );

  group('CompletionOverlay', () {
    testWidgets('shows title text', (tester) async {
      await tester.pumpWidget(wrap(makeOverlay()));
      expect(find.text('Congratulations!'), findsOneWidget);
    });

    testWidgets('shows subtitle text', (tester) async {
      await tester.pumpWidget(wrap(makeOverlay()));
      expect(find.text('You reached the finish!'), findsOneWidget);
    });

    testWidgets('shows Ukrainian texts', (tester) async {
      await tester.pumpWidget(wrap(makeOverlay(
        title: 'Вітаємо!',
        subtitle: 'Ти досяг фінішу!',
        playAgainLabel: 'Грати знову',
        closeLabel: 'Закрити',
      )));
      expect(find.text('Вітаємо!'), findsOneWidget);
      expect(find.text('Ти досяг фінішу!'), findsOneWidget);
    });

    testWidgets('Play Again button calls onRestart', (tester) async {
      bool restarted = false;
      await tester.pumpWidget(wrap(makeOverlay(onRestart: () => restarted = true)));
      await tester.tap(find.text('Play Again'));
      expect(restarted, isTrue);
    });

    testWidgets('Close button calls onClose', (tester) async {
      bool closed = false;
      await tester.pumpWidget(wrap(makeOverlay(onClose: () => closed = true)));
      await tester.tap(find.text('Close'));
      expect(closed, isTrue);
    });

    testWidgets('shows custom button labels', (tester) async {
      await tester.pumpWidget(wrap(makeOverlay(
        playAgainLabel: 'Грати знову',
        closeLabel: 'Закрити',
      )));
      expect(find.text('Грати знову'), findsOneWidget);
      expect(find.text('Закрити'), findsOneWidget);
    });
  });
}
