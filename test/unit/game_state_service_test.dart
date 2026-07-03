import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animal_game/models/level.dart';
import 'package:animal_game/services/game_state_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GameStateService', () {
    late GameStateService service;

    setUp(() {
      service = GameStateService();
      SharedPreferences.setMockInitialValues({});
    });

    test('loadGameState returns null when no state saved', () async {
      final state = await service.loadGameState(LevelMode.picture);
      expect(state, isNull);
    });

    test('save then load round-trips all fields correctly', () async {
      await service.saveGameState(
        LevelMode.picture,
        score: 5,
        dragonSteps: 3,
        levelNumber: 7,
        difficultyLevel: 2,
      );
      final state = await service.loadGameState(LevelMode.picture);

      expect(state, isNotNull);
      expect(state!.score, 5);
      expect(state.dragonSteps, 3);
      expect(state.levelNumber, 7);
      expect(state.difficultyLevel, 2);
    });

    test('clearGameState makes loadGameState return null', () async {
      await service.saveGameState(
        LevelMode.picture,
        score: 5,
        dragonSteps: 3,
        levelNumber: 7,
        difficultyLevel: 1,
      );
      await service.clearGameState(LevelMode.picture);

      final state = await service.loadGameState(LevelMode.picture);
      expect(state, isNull);
    });

    test('saves and loads zero values without treating them as missing', () async {
      await service.saveGameState(
        LevelMode.text,
        score: 0,
        dragonSteps: 0,
        levelNumber: 0,
        difficultyLevel: 1,
      );
      final state = await service.loadGameState(LevelMode.text);

      expect(state, isNotNull);
      expect(state!.score, 0);
      expect(state.dragonSteps, 0);
      expect(state.levelNumber, 0);
      expect(state.difficultyLevel, 1);
    });

    test('overwriting state replaces all fields', () async {
      await service.saveGameState(
        LevelMode.typing,
        score: 1,
        dragonSteps: 1,
        levelNumber: 1,
        difficultyLevel: 1,
      );
      await service.saveGameState(
        LevelMode.typing,
        score: 9,
        dragonSteps: 8,
        levelNumber: 12,
        difficultyLevel: 3,
      );
      final state = await service.loadGameState(LevelMode.typing);

      expect(state!.score, 9);
      expect(state.dragonSteps, 8);
      expect(state.levelNumber, 12);
      expect(state.difficultyLevel, 3);
    });

    test('difficultyLevel defaults to 1 when key missing from saved data', () async {
      // Simulate old save without difficulty key
      SharedPreferences.setMockInitialValues({
        'game_score_picture': 3,
        'game_steps_picture': 2,
        'game_level_picture': 4,
      });
      final state = await service.loadGameState(LevelMode.picture);
      expect(state, isNotNull);
      expect(state!.difficultyLevel, 1);
    });

    test('picture and text mode progress are independent', () async {
      await service.saveGameState(
        LevelMode.picture,
        score: 3,
        dragonSteps: 4,
        levelNumber: 5,
        difficultyLevel: 2,
      );
      await service.saveGameState(
        LevelMode.text,
        score: 7,
        dragonSteps: 2,
        levelNumber: 9,
        difficultyLevel: 1,
      );

      final picState = await service.loadGameState(LevelMode.picture);
      final txtState = await service.loadGameState(LevelMode.text);

      expect(picState!.score, 3);
      expect(picState.difficultyLevel, 2);
      expect(txtState!.score, 7);
      expect(txtState.difficultyLevel, 1);
    });

    test('clearGameState for one mode does not affect another', () async {
      await service.saveGameState(
        LevelMode.picture,
        score: 5,
        dragonSteps: 5,
        levelNumber: 5,
        difficultyLevel: 2,
      );
      await service.saveGameState(
        LevelMode.text,
        score: 6,
        dragonSteps: 6,
        levelNumber: 6,
        difficultyLevel: 1,
      );

      await service.clearGameState(LevelMode.picture);

      expect(await service.loadGameState(LevelMode.picture), isNull);
      final txtState = await service.loadGameState(LevelMode.text);
      expect(txtState, isNotNull);
      expect(txtState!.score, 6);
    });

    test('all three modes store independent data', () async {
      await service.saveGameState(
        LevelMode.picture,
        score: 1,
        dragonSteps: 1,
        levelNumber: 1,
        difficultyLevel: 1,
      );
      await service.saveGameState(
        LevelMode.text,
        score: 2,
        dragonSteps: 2,
        levelNumber: 2,
        difficultyLevel: 2,
      );
      await service.saveGameState(
        LevelMode.typing,
        score: 3,
        dragonSteps: 3,
        levelNumber: 3,
        difficultyLevel: 1,
      );

      final pic = await service.loadGameState(LevelMode.picture);
      final txt = await service.loadGameState(LevelMode.text);
      final typ = await service.loadGameState(LevelMode.typing);

      expect(pic!.score, 1);
      expect(txt!.score, 2);
      expect(txt.difficultyLevel, 2);
      expect(typ!.score, 3);
    });
  });
}
