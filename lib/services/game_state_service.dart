import 'package:shared_preferences/shared_preferences.dart';

/// Service for saving and loading game state
class GameStateService {
  static const String _keyScore = 'game_score';
  static const String _keyDragonSteps = 'game_dragon_steps';
  static const String _keyLevelNumber = 'game_level_number';

  /// Save game state
  Future<void> saveGameState({
    required int score,
    required int dragonSteps,
    required int levelNumber,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyScore, score);
    await prefs.setInt(_keyDragonSteps, dragonSteps);
    await prefs.setInt(_keyLevelNumber, levelNumber);
  }

  /// Load game state
  Future<GameState?> loadGameState() async {
    final prefs = await SharedPreferences.getInstance();
    
    final score = prefs.getInt(_keyScore);
    final dragonSteps = prefs.getInt(_keyDragonSteps);
    final levelNumber = prefs.getInt(_keyLevelNumber);

    // If no saved state exists, return null
    if (score == null || dragonSteps == null || levelNumber == null) {
      return null;
    }

    return GameState(
      score: score,
      dragonSteps: dragonSteps,
      levelNumber: levelNumber,
    );
  }

  /// Clear saved game state
  Future<void> clearGameState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyScore);
    await prefs.remove(_keyDragonSteps);
    await prefs.remove(_keyLevelNumber);
  }
}

/// Model for game state
class GameState {
  final int score;
  final int dragonSteps;
  final int levelNumber;

  GameState({
    required this.score,
    required this.dragonSteps,
    required this.levelNumber,
  });
}
