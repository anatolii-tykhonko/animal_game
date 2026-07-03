import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:animal_game/l10n/app_strings.dart';
import 'package:animal_game/services/language_service.dart';
import 'package:animal_game/ui/select/game_select_page.dart';
import 'package:animal_game/models/level.dart';

Widget wrapWithProvider(Widget child, {Map<String, Widget Function(BuildContext)>? routes}) =>
    ChangeNotifierProvider(
      create: (_) => LanguageService(),
      child: MaterialApp(
        home: child,
        routes: routes ?? {'/game': (_) => const Scaffold(body: Text('game'))},
      ),
    );

void main() {
  group('GameSelectPage', () {
    testWidgets('shows all three mode cards in English', (tester) async {
      await tester.pumpWidget(wrapWithProvider(const GameSelectPage()));
      expect(find.text('Picture Mode'), findsOneWidget);
      expect(find.text('Text Mode'), findsOneWidget);
      expect(find.text('Type Mode'), findsOneWidget);
    });

    testWidgets('shows Ukrainian mode names when language is Ukrainian', (tester) async {
      final service = LanguageService();
      await tester.pumpWidget(ChangeNotifierProvider.value(
        value: service,
        child: const MaterialApp(home: GameSelectPage()),
      ));
      service.setLanguage(AppLanguage.ukrainian);
      await tester.pump();

      expect(find.text('Режим картинок'), findsOneWidget);
      expect(find.text('Текстовий режим'), findsOneWidget);
      expect(find.text('Режим введення'), findsOneWidget);
    });

    testWidgets('each mode card is at least 64px tall', (tester) async {
      await tester.pumpWidget(wrapWithProvider(const GameSelectPage()));
      for (final button in tester.widgetList<ElevatedButton>(find.byType(ElevatedButton))) {
        final size = tester.getSize(find.byWidget(button));
        expect(size.height, greaterThanOrEqualTo(64));
      }
    });

    testWidgets('tapping Picture Mode passes LevelMode.picture to /game', (tester) async {
      LevelMode? capturedMode;
      await tester.pumpWidget(ChangeNotifierProvider(
        create: (_) => LanguageService(),
        child: MaterialApp(
          home: const GameSelectPage(),
          routes: {
            '/game': (context) {
              capturedMode = ModalRoute.of(context)!.settings.arguments as LevelMode?;
              return const Scaffold(body: Text('game'));
            },
          },
        ),
      ));

      await tester.tap(find.text('Picture Mode'));
      await tester.pumpAndSettle();
      expect(capturedMode, LevelMode.picture);
    });

    testWidgets('tapping Text Mode passes LevelMode.text to /game', (tester) async {
      LevelMode? capturedMode;
      await tester.pumpWidget(ChangeNotifierProvider(
        create: (_) => LanguageService(),
        child: MaterialApp(
          home: const GameSelectPage(),
          routes: {
            '/game': (context) {
              capturedMode = ModalRoute.of(context)!.settings.arguments as LevelMode?;
              return const Scaffold(body: Text('game'));
            },
          },
        ),
      ));

      await tester.tap(find.text('Text Mode'));
      await tester.pumpAndSettle();
      expect(capturedMode, LevelMode.text);
    });

    testWidgets('tapping Type Mode passes LevelMode.typing to /game', (tester) async {
      LevelMode? capturedMode;
      await tester.pumpWidget(ChangeNotifierProvider(
        create: (_) => LanguageService(),
        child: MaterialApp(
          home: const GameSelectPage(),
          routes: {
            '/game': (context) {
              capturedMode = ModalRoute.of(context)!.settings.arguments as LevelMode?;
              return const Scaffold(body: Text('game'));
            },
          },
        ),
      ));

      await tester.tap(find.text('Type Mode'));
      await tester.pumpAndSettle();
      expect(capturedMode, LevelMode.typing);
    });
  });
}
