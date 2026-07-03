import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:animal_game/ui/game/widgets/animal_option_button.dart';
import 'package:animal_game/models/animal.dart';
import 'package:animal_game/l10n/app_strings.dart';

void main() {
  const testAnimal = Animal(
    id: 'cat',
    name: 'Cat',
    imageAsset: 'assets/images/cat.png',
    soundAsset: 'audio/cat.wav',
  );

  Widget wrap(Widget child) =>
      MaterialApp(home: Scaffold(body: Center(child: child)));

  group('AnimalOptionButton', () {
    testWidgets('shows English animal name in text mode', (tester) async {
      await tester.pumpWidget(wrap(AnimalOptionButton(
        animal: testAnimal,
        isPictureMode: false,
        language: AppLanguage.english,
        onTap: () {},
      )));
      expect(find.text('Cat'), findsOneWidget);
    });

    testWidgets('shows Ukrainian animal name in text mode', (tester) async {
      await tester.pumpWidget(wrap(AnimalOptionButton(
        animal: testAnimal,
        isPictureMode: false,
        language: AppLanguage.ukrainian,
        onTap: () {},
      )));
      expect(find.text('Кіт'), findsOneWidget);
    });

    testWidgets('does not show animal name in picture mode', (tester) async {
      await tester.pumpWidget(wrap(AnimalOptionButton(
        animal: testAnimal,
        isPictureMode: true,
        language: AppLanguage.english,
        onTap: () {},
      )));
      await tester.pump();
      expect(find.text('Cat'), findsNothing);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(wrap(AnimalOptionButton(
        animal: testAnimal,
        isPictureMode: false,
        language: AppLanguage.english,
        onTap: () => tapped = true,
      )));
      await tester.tap(find.byType(ElevatedButton));
      expect(tapped, isTrue);
    });

    testWidgets('button is disabled when onTap is null', (tester) async {
      await tester.pumpWidget(wrap(AnimalOptionButton(
        animal: testAnimal,
        isPictureMode: false,
        language: AppLanguage.english,
        onTap: null,
      )));
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('rapid tapping does not crash', (tester) async {
      int tapCount = 0;
      await tester.pumpWidget(wrap(AnimalOptionButton(
        animal: testAnimal,
        isPictureMode: false,
        language: AppLanguage.english,
        onTap: () => tapCount++,
      )));
      for (int i = 0; i < 10; i++) {
        await tester.tap(find.byType(ElevatedButton));
      }
      await tester.pump();
      expect(tapCount, 10);
    });

    testWidgets('button tap target is at least 64x64', (tester) async {
      await tester.pumpWidget(wrap(AnimalOptionButton(
        animal: testAnimal,
        isPictureMode: false,
        language: AppLanguage.english,
        onTap: () {},
      )));
      final size = tester.getSize(find.byType(ElevatedButton));
      expect(size.width, greaterThanOrEqualTo(64));
      expect(size.height, greaterThanOrEqualTo(64));
    });
  });
}
