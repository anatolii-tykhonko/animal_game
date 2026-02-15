import 'package:flutter/material.dart';
import '../../models/level.dart';
import '../../services/level_service.dart';
import '../../services/audio_service.dart';
import '../../services/game_state_service.dart';
import 'widgets/sound_card.dart';
import 'widgets/animal_option_button.dart';
import 'widgets/win_overlay.dart';
import 'widgets/lose_overlay.dart';
import 'widgets/dragon_progress.dart';
import 'widgets/completion_overlay.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final LevelService _levelService = LevelService();
  final AudioService _audioService = AudioService();
  final GameStateService _gameStateService = GameStateService();
  Level? _currentLevel;
  int _score = 0;
  int _dragonSteps = 0; // 0 to 10 steps
  bool _isAnswered = false;
  bool? _showWinOverlay;
  bool? _showLoseOverlay;
  bool _isLoadingState = true;
  bool _isGameCompleted = false; // True when dragon reaches 10/10

  @override
  void initState() {
    super.initState();
    _loadGameState();
  }

  /// Load saved game state
  Future<void> _loadGameState() async {
    final savedState = await _gameStateService.loadGameState();
    
      if (savedState != null && mounted) {
      setState(() {
        _score = savedState.score;
        _dragonSteps = savedState.dragonSteps;
        _isGameCompleted = savedState.dragonSteps >= 10;
        _isLoadingState = false;
      });
      // If game is completed, don't load new level
      if (!_isGameCompleted) {
        // Load level based on saved level number
        _loadNewLevel(savedState.levelNumber);
      }
    } else {
      setState(() {
        _isLoadingState = false;
      });
      _loadNewLevel();
    }
  }

  /// Save game state
  Future<void> _saveGameState() async {
    await _gameStateService.saveGameState(
      score: _score,
      dragonSteps: _dragonSteps,
      levelNumber: _currentLevel?.levelNumber ?? 0,
    );
  }

  void _loadNewLevel([int? startLevelNumber]) {
    setState(() {
      _currentLevel = _levelService.nextLevel(
        startLevelNumber ?? _currentLevel?.levelNumber ?? 0,
        null,
      );
      _isAnswered = false;
      _showWinOverlay = false;
      _showLoseOverlay = false;
    });
    // Auto-play the sound when level loads
    _playSound();
    // Save state after loading new level
    _saveGameState();
  }

  void _playSound() {
    if (_currentLevel != null) {
      final soundFile = _currentLevel!.correctAnimal.soundAsset
          .replaceFirst('audio/', '');
      _audioService.playAudio(soundFile);
    }
  }

  void _handleAnswer(bool isCorrect) {
    if (_isAnswered || _isGameCompleted) return;

    // Stop audio when user makes a choice
    _audioService.stop();

    setState(() {
      _isAnswered = true;
      if (isCorrect) {
        _score++;
        // Dragon moves forward (max 10 steps)
        if (_dragonSteps < 10) {
          _dragonSteps++;
        }
        _showWinOverlay = true;
        _showLoseOverlay = false;
        
        // Check if game is completed (reached 10/10)
        if (_dragonSteps >= 10) {
          _isGameCompleted = true;
        }
      } else {
        // Dragon steps back (min 0 steps)
        if (_dragonSteps > 0) {
          _dragonSteps--;
        }
        _showWinOverlay = false;
        _showLoseOverlay = true;
      }
    });

    // Save state after answer
    _saveGameState();

    // If game is completed, don't load next level
    if (_isGameCompleted) {
      // Show completion overlay after win overlay
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _showWinOverlay = false;
          });
        }
      });
    } else {
      // Show feedback overlay for 2 seconds, then load next level
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _showWinOverlay = false;
            _showLoseOverlay = false;
          });
          _loadNewLevel();
        }
      });
    }
  }

  /// Restart the game (reset to beginning)
  void _restartGame() async {
    // Clear saved game state
    await _gameStateService.clearGameState();
    
    setState(() {
      _score = 0;
      _dragonSteps = 0;
      _isGameCompleted = false;
      _isAnswered = false;
      _showWinOverlay = false;
      _showLoseOverlay = false;
    });
    
    // Start new game
    _loadNewLevel();
  }

  @override
  void dispose() {
    // Save state before closing
    _saveGameState();
    _audioService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingState || _currentLevel == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final correctAnimal = _currentLevel!.correctAnimal;
    final soundFile = correctAnimal.soundAsset.replaceFirst('audio/', '');

    return Scaffold(
      body: Stack(
        children: [
          // Main game content
          Column(
            children: [
              // Top section - dragon progress
              DragonProgress(dragonSteps: _dragonSteps),
              // Middle section - sound icon only
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.blue.shade50,
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: _isGameCompleted
                        ? IgnorePointer(
                            child: Opacity(
                              opacity: 0.5,
                              child: SoundCard(
                                audioPath: soundFile,
                                audioService: _audioService,
                              ),
                            ),
                          )
                        : SoundCard(
                            audioPath: soundFile,
                            audioService: _audioService,
                          ),
                  ),
                ),
              ),
              // Bottom section - options
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.green.shade50,
                  padding: const EdgeInsets.all(20),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _currentLevel!.options.length,
                    itemBuilder: (context, index) {
                      final animal = _currentLevel!.options[index];
                      final isCorrect = animal.id == correctAnimal.id;
                      return AnimalOptionButton(
                        animal: animal,
                        isPictureMode: true,
                        onTap: _isGameCompleted ? null : () => _handleAnswer(isCorrect),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          // Close button in bottom-right corner (hidden when game is completed)
          if (!_isGameCompleted)
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: () async {
                  // Save state before closing
                  await _saveGameState();
                  if (mounted) {
                    Navigator.pop(context);
                  }
                },
                backgroundColor: Colors.red,
                child: const Icon(Icons.close),
              ),
            ),
          // Win overlay
          if (_showWinOverlay == true && !_isGameCompleted)
            const WinOverlay(),
          // Lose overlay
          if (_showLoseOverlay == true)
            const LoseOverlay(),
          // Completion overlay (when game is finished)
          if (_isGameCompleted)
            CompletionOverlay(
              onRestart: _restartGame,
              onClose: () async {
                await _saveGameState();
                if (mounted) {
                  Navigator.pop(context);
                }
              },
            ),
        ],
      ),
    );
  }
}
