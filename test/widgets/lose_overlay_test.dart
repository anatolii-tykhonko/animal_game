import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:animal_game/ui/game/widgets/lose_overlay.dart';

void main() {
  Widget wrap(Widget child) =>
      MaterialApp(home: Scaffold(body: Stack(children: [child])));

  group('LoseOverlay', () {
    testWidgets('shows provided message', (tester) async {
      await tester.pumpWidget(wrap(const LoseOverlay(message: 'Try Again!')));
      expect(find.text('Try Again!'), findsOneWidget);
    });

    testWidgets('shows Ukrainian message', (tester) async {
      await tester.pumpWidget(wrap(const LoseOverlay(message: 'Спробуй ще!')));
      expect(find.text('Спробуй ще!'), findsOneWidget);
    });

    testWidgets('renders without crash when image is missing', (tester) async {
      await tester.pumpWidget(wrap(const LoseOverlay(message: 'Try Again!')));
      await tester.pump();
      expect(find.byType(LoseOverlay), findsOneWidget);
    });
  });
}
