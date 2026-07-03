import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:animal_game/ui/game/widgets/sound_card.dart';
import 'package:animal_game/services/audio_service.dart';

class MockAudioService extends Mock implements AudioService {}

void main() {
  Widget wrap(Widget child) =>
      MaterialApp(home: Scaffold(body: Center(child: child)));

  group('SoundCard', () {
    late MockAudioService mockAudio;

    setUp(() {
      mockAudio = MockAudioService();
      when(() => mockAudio.stop()).thenAnswer((_) async {});
      when(() => mockAudio.playAudio(any())).thenAnswer((_) async {});
    });

    testWidgets('shows volume_up icon', (tester) async {
      await tester.pumpWidget(wrap(SoundCard(
        audioPath: 'cat.wav',
        tapLabel: 'Tap to hear!',
        audioService: mockAudio,
      )));
      expect(find.byIcon(Icons.volume_up), findsOneWidget);
    });

    testWidgets('shows tapLabel text', (tester) async {
      await tester.pumpWidget(wrap(SoundCard(
        audioPath: 'cat.wav',
        tapLabel: 'Tap to hear!',
        audioService: mockAudio,
      )));
      expect(find.text('Tap to hear!'), findsOneWidget);
    });

    testWidgets('shows Ukrainian tapLabel', (tester) async {
      await tester.pumpWidget(wrap(SoundCard(
        audioPath: 'cat.wav',
        tapLabel: 'Натисни, щоб почути!',
        audioService: mockAudio,
      )));
      expect(find.text('Натисни, щоб почути!'), findsOneWidget);
    });

    testWidgets('shows Image widget when imageAsset is provided', (tester) async {
      await tester.pumpWidget(wrap(SoundCard(
        audioPath: 'cat.wav',
        tapLabel: 'Tap to hear!',
        audioService: mockAudio,
        imageAsset: 'assets/images/cat.png',
      )));
      await tester.pump();
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('does not show Image widget without imageAsset', (tester) async {
      await tester.pumpWidget(wrap(SoundCard(
        audioPath: 'cat.wav',
        tapLabel: 'Tap to hear!',
        audioService: mockAudio,
      )));
      expect(find.byType(Image), findsNothing);
    });

    testWidgets('calls stop then playAudio when tapped', (tester) async {
      await tester.pumpWidget(wrap(SoundCard(
        audioPath: 'cat.wav',
        tapLabel: 'Tap to hear!',
        audioService: mockAudio,
      )));
      await tester.tap(find.byType(GestureDetector));
      await tester.pump(const Duration(milliseconds: 200));

      verify(() => mockAudio.stop()).called(1);
      verify(() => mockAudio.playAudio('cat.wav')).called(1);
    });

    testWidgets('rapid taps do not crash', (tester) async {
      await tester.pumpWidget(wrap(SoundCard(
        audioPath: 'cat.wav',
        tapLabel: 'Tap to hear!',
        audioService: mockAudio,
      )));
      for (int i = 0; i < 5; i++) {
        await tester.tap(find.byType(GestureDetector));
      }
      await tester.pump(const Duration(milliseconds: 600));
      verify(() => mockAudio.stop()).called(greaterThanOrEqualTo(1));
    });
  });
}
