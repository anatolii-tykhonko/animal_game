import 'package:shared_preferences/shared_preferences.dart';
import '../models/level.dart';

class GameStateService {
  static String _keyScore(LevelMode mode) => 'game_score_${mode.name}';
  static String _keySteps(LevelMode mode) => 'game_steps_${mode.name}';
  static String _keyLevel(LevelMode mode) => 'game_level_${mode.name}';
  static String _keyDifficulty(LevelMode mode) => 'game_difficulty_${mode.name}';

  Future<void> saveGameState(
    LevelMode mode, {
    required int score,
    required int dragonSteps,
    required int levelNumber,
    required int difficultyLevel,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyScore(mode), score);
    await prefs.setInt(_keySteps(mode), dragonSteps);
    await prefs.setInt(_keyLevel(mode), levelNumber);
    await prefs.setInt(_keyDifficulty(mode), difficultyLevel);
  }

  Future<GameState?> loadGameState(LevelMode mode) async {
    final prefs = await SharedPreferences.getInstance();

    final score = prefs.getInt(_keyScore(mode));
    final dragonSteps = prefs.getInt(_keySteps(mode));
    final levelNumber = prefs.getInt(_keyLevel(mode));

    if (score == null || dragonSteps == null || levelNumber == null) {
      return null;
    }

    return GameState(
      score: score,
      dragonSteps: dragonSteps,
      levelNumber: levelNumber,
      difficultyLevel: prefs.getInt(_keyDifficulty(mode)) ?? 1,
    );
  }

  Future<void> clearGameState(LevelMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyScore(mode));
    await prefs.remove(_keySteps(mode));
    await prefs.remove(_keyLevel(mode));
    await prefs.remove(_keyDifficulty(mode));
  }
}

class GameState {
  final int score;
  final int dragonSteps;
  final int levelNumber;
  final int difficultyLevel;

  GameState({
    required this.score,
    required this.dragonSteps,
    required this.levelNumber,
    required this.difficultyLevel,
  });
}
