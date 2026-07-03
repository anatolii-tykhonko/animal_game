import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:animal_game/ui/game/widgets/win_overlay.dart';

void main() {
  Widget wrap(Widget child) =>
      MaterialApp(home: Scaffold(body: Stack(children: [child])));

  group('WinOverlay', () {
    testWidgets('shows provided message', (tester) async {
      await tester.pumpWidget(wrap(const WinOverlay(message: 'Correct!')));
      expect(find.text('Correct!'), findsOneWidget);
    });

    testWidgets('shows Ukrainian message', (tester) async {
      await tester.pumpWidget(wrap(const WinOverlay(message: 'Правильно!')));
      expect(find.text('Правильно!'), findsOneWidget);
    });

    testWidgets('renders without crash when image is missing', (tester) async {
      await tester.pumpWidget(wrap(const WinOverlay(message: 'Correct!')));
      await tester.pump();
      expect(find.byType(WinOverlay), findsOneWidget);
    });
  });
}
