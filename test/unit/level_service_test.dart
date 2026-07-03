import 'package:flutter_test/flutter_test.dart';
import 'package:animal_game/models/level.dart';
import 'package:animal_game/services/level_service.dart';

void main() {
  group('LevelService', () {
    late LevelService service;

    setUp(() {
      service = LevelService();
    });

    test('returns exactly 3 options at difficulty 1 (default)', () {
      final level = service.nextLevel(0, null);
      expect(level.options.length, 3);
    });

    test('returns 4 options at difficulty 2', () {
      for (int i = 0; i < 10; i++) {
        final level = service.nextLevel(i, null, difficulty: 2);
        expect(level.options.length, 4);
      }
    });

    test('returns 6 options at difficulty 3', () {
      for (int i = 0; i < 10; i++) {
        final level = service.nextLevel(i, null, difficulty: 3);
        expect(level.options.length, 6);
      }
    });

    test('returns 6 options at difficulty 4 (capped at 6)', () {
      final level = service.nextLevel(0, null, difficulty: 4);
      expect(level.options.length, 6);
    });

    test('correct animal is always in options at any difficulty', () {
      for (int d = 1; d <= 3; d++) {
        for (int i = 0; i < 10; i++) {
          final level = service.nextLevel(i, null, difficulty: d);
          expect(level.options.any((a) => a.id == level.correctAnimal.id), isTrue);
        }
      }
    });

    test('all options are distinct at any difficulty', () {
      for (int d = 1; d <= 3; d++) {
        for (int i = 0; i < 10; i++) {
          final level = service.nextLevel(i, null, difficulty: d);
          final ids = level.options.map((a) => a.id).toSet();
          expect(ids.length, level.options.length);
        }
      }
    });

    test('optionCountForDifficulty returns correct counts', () {
      expect(service.optionCountForDifficulty(1), 3);
      expect(service.optionCountForDifficulty(2), 4);
      expect(service.optionCountForDifficulty(3), 6);
      expect(service.optionCountForDifficulty(10), 6);
    });

    test('uses picture mode when previousLevelNumber < 5', () {
      expect(service.nextLevel(0, null).mode, LevelMode.picture);
      expect(service.nextLevel(4, null).mode, LevelMode.picture);
    });

    test('uses text mode when previousLevelNumber >= 5', () {
      expect(service.nextLevel(5, null).mode, LevelMode.text);
      expect(service.nextLevel(10, null).mode, LevelMode.text);
    });

    test('levelNumber is previousLevelNumber + 1', () {
      expect(service.nextLevel(0, null).levelNumber, 1);
      expect(service.nextLevel(7, null).levelNumber, 8);
    });

    test('preferredMode overrides default mode selection', () {
      expect(service.nextLevel(0, LevelMode.text).mode, LevelMode.text);
      expect(service.nextLevel(10, LevelMode.picture).mode, LevelMode.picture);
    });

    test('generates 20 consecutive levels without crash', () {
      for (int i = 0; i < 20; i++) {
        final level = service.nextLevel(i, null);
        expect(level.options.length, 3);
        expect(level.options.any((a) => a.id == level.correctAnimal.id), isTrue);
      }
    });
  });
}
