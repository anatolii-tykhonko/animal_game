import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:animal_game/services/language_service.dart';
import 'package:animal_game/ui/home/home_page.dart';

Widget wrapWithProvider(Widget child) => ChangeNotifierProvider(
      create: (_) => LanguageService(),
      child: MaterialApp(home: child),
    );

void main() {
  group('HomePage', () {
    testWidgets('shows Animal Sounds Game title in English', (tester) async {
      await tester.pumpWidget(wrapWithProvider(const HomePage()));
      expect(find.text('Animal Sounds Game'), findsOneWidget);
    });

    testWidgets('shows Start button in English', (tester) async {
      await tester.pumpWidget(wrapWithProvider(const HomePage()));
      expect(find.text('Start'), findsOneWidget);
    });

    testWidgets('shows EN and UA language buttons', (tester) async {
      await tester.pumpWidget(wrapWithProvider(const HomePage()));
      expect(find.text('EN'), findsOneWidget);
      expect(find.text('UA'), findsOneWidget);
    });

    testWidgets('tapping UA switches title to Ukrainian', (tester) async {
      await tester.pumpWidget(wrapWithProvider(const HomePage()));
      await tester.tap(find.text('UA'));
      await tester.pump();
      expect(find.text('Гра Звуки Тварин'), findsOneWidget);
      expect(find.text('Почати'), findsOneWidget);
    });

    testWidgets('tapping EN after UA switches back to English', (tester) async {
      await tester.pumpWidget(wrapWithProvider(const HomePage()));
      await tester.tap(find.text('UA'));
      await tester.pump();
      await tester.tap(find.text('EN'));
      await tester.pump();
      expect(find.text('Animal Sounds Game'), findsOneWidget);
    });

    testWidgets('Start button tap target is at least 64x64', (tester) async {
      await tester.pumpWidget(wrapWithProvider(const HomePage()));
      final buttons = find.byType(ElevatedButton);
      // Find the Start button (the widest one)
      final startButton = tester.widgetList<ElevatedButton>(buttons).reduce(
        (a, b) => tester.getSize(find.byWidget(a)).width >
                tester.getSize(find.byWidget(b)).width
            ? a
            : b,
      );
      final size = tester.getSize(find.byWidget(startButton));
      expect(size.width, greaterThanOrEqualTo(64));
      expect(size.height, greaterThanOrEqualTo(64));
    });
  });
}
