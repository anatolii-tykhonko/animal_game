import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_strings.dart';
import '../../models/level.dart';
import '../../services/language_service.dart';
import '../../services/level_service.dart';
import '../../services/audio_service.dart';
import '../../services/game_state_service.dart';
import '../../services/settings_service.dart';
import 'widgets/sound_card.dart';
import 'widgets/animal_option_button.dart';
import 'widgets/type_answer_field.dart';
import 'widgets/win_overlay.dart';
import 'widgets/lose_overlay.dart';
import 'widgets/dragon_progress.dart';
import 'widgets/completion_overlay.dart';
import 'widgets/video_reward_overlay.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final LevelService _levelService = LevelService();
  final AudioService _audioService = AudioService();
  final GameStateService _gameStateService = GameStateService();
  final TextEditingController _typingController = TextEditingController();

  LevelMode _selectedMode = LevelMode.picture;
  Level? _currentLevel;
  int _score = 0;
  int _dragonSteps = 0;
  int _difficultyLevel = 1;
  bool _isAnswered = false;
  bool? _showWinOverlay;
  bool? _showLoseOverlay;
  bool _isLoadingState = true;
  bool _isGameCompleted = false;
  bool _stateLoaded = false;
  bool _showHint = false;
  bool _showVideoReward = false;

  // Difficulty levels only apply to picture and text modes.
  bool get _hasDifficulty =>
      _selectedMode == LevelMode.picture || _selectedMode == LevelMode.text;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is LevelMode) {
      _selectedMode = args;
    }
    if (!_stateLoaded) {
      _stateLoaded = true;
      _loadGameState();
    }
  }

  Future<void> _loadGameState() async {
    final savedState = await _gameStateService.loadGameState(_selectedMode);

    if (savedState != null && mounted) {
      bool shouldContinue = true;
      if (_hasDifficulty) {
        final lang = context.read<LanguageService>().language;
        shouldContinue = await _showContinueDialog(lang);
      }

      if (!mounted) return;

      if (shouldContinue) {
        setState(() {
          _score = savedState.score;
          _dragonSteps = savedState.dragonSteps;
          _difficultyLevel = savedState.difficultyLevel;
          _isGameCompleted = savedState.dragonSteps >= 10;
          _isLoadingState = false;
        });
        if (!_isGameCompleted) {
          _loadNewLevel(savedState.levelNumber);
        } else {
          setState(() {
            _currentLevel = _levelService.nextLevel(
              savedState.levelNumber,
              _selectedMode,
              difficulty: _difficultyLevel,
            );
          });
        }
      } else {
        await _gameStateService.clearGameState(_selectedMode);
        if (mounted) {
          setState(() {
            _difficultyLevel = 1;
            _isLoadingState = false;
          });
          _loadNewLevel();
        }
      }
    } else {
      if (mounted) {
        setState(() => _isLoadingState = false);
        _loadNewLevel();
      }
    }
  }

  Future<bool> _showContinueDialog(AppLanguage lang) async {
    String s(String key) => AppStrings.of(lang, key);
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(s('savedGame')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(s('newGame')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(s('continueGame')),
          ),
        ],
      ),
    );
    return result ?? true;
  }

  Future<void> _saveGameState() async {
    await _gameStateService.saveGameState(
      _selectedMode,
      score: _score,
      dragonSteps: _dragonSteps,
      levelNumber: _currentLevel?.levelNumber ?? 0,
      difficultyLevel: _difficultyLevel,
    );
  }

  void _loadNewLevel([int? startLevelNumber]) {
    setState(() {
      _currentLevel = _levelService.nextLevel(
        startLevelNumber ?? _currentLevel?.levelNumber ?? 0,
        _selectedMode,
        difficulty: _difficultyLevel,
      );
      _isAnswered = false;
      _showWinOverlay = false;
      _showLoseOverlay = false;
      _showHint = false;
    });
    _playSound();
    _saveGameState();
  }

  void _playSound() {
    if (_currentLevel != null) {
      final soundFile = _currentLevel!.correctAnimal.soundAsset.replaceFirst('audio/', '');
      _audioService.playAudio(soundFile);
    }
  }

  void _handleAnswer(bool isCorrect) {
    if (_isAnswered || _isGameCompleted) return;

    _audioService.stop();

    setState(() {
      _isAnswered = true;
      if (isCorrect) {
        _score++;
        if (_dragonSteps < 10) _dragonSteps++;
        _showWinOverlay = true;
        _showLoseOverlay = false;
        if (_dragonSteps >= 10) _isGameCompleted = true;
      } else {
        if (_dragonSteps > 0) _dragonSteps--;
        _showWinOverlay = false;
        _showLoseOverlay = true;
      }
    });

    _saveGameState();

    if (_isGameCompleted) {
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() => _showWinOverlay = false);
        final settings = context.read<SettingsService>();
        if (settings.videoRewardEnabled) {
          setState(() => _showVideoReward = true);
        }
      });
    } else {
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

  void _handleTypedAnswer(String text) {
    final lang = context.read<LanguageService>().language;
    final translatedName = AppStrings.of(lang, _currentLevel!.correctAnimal.id);
    _handleAnswer(text.trim().toLowerCase() == translatedName.toLowerCase());
  }

  void _onVideoFinished() {
    setState(() => _showVideoReward = false);
    // _isGameCompleted is still true → CompletionOverlay becomes visible
  }

  // Advances to the next difficulty level (picture / text modes only).
  Future<void> _advanceDifficulty() async {
    setState(() {
      _difficultyLevel++;
      _score = 0;
      _dragonSteps = 0;
      _isGameCompleted = false;
      _isAnswered = false;
      _showWinOverlay = false;
      _showLoseOverlay = false;
      _showHint = false;
      _showVideoReward = false;
    });
    _loadNewLevel();
  }

  Future<void> _restartGame() async {
    await _gameStateService.clearGameState(_selectedMode);
    setState(() {
      _difficultyLevel = 1;
      _score = 0;
      _dragonSteps = 0;
      _isGameCompleted = false;
      _isAnswered = false;
      _showWinOverlay = false;
      _showLoseOverlay = false;
      _showHint = false;
      _showVideoReward = false;
    });
    _loadNewLevel();
  }

  @override
  void dispose() {
    _saveGameState();
    _audioService.dispose();
    _typingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingState || _currentLevel == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final lang = context.watch<LanguageService>().language;
    String s(String key) => AppStrings.of(lang, key);

    final correctAnimal = _currentLevel!.correctAnimal;
    final soundFile = correctAnimal.soundAsset.replaceFirst('audio/', '');
    final isPictureMode = _selectedMode == LevelMode.picture;
    final isTypingMode = _selectedMode == LevelMode.typing;

    final optionCount = _currentLevel!.options.length;
    // 4 options → 2 cols but wider cells (ratio 1.5) so row height matches 3-col layout
    final gridCrossAxisCount = optionCount == 4 ? 2 : 3;
    final gridChildAspectRatio = optionCount == 4 ? 1.5 : 1.0;

    return Scaffold(
      floatingActionButton: isTypingMode && !_isAnswered && !_isGameCompleted
          ? FloatingActionButton(
              onPressed: () => _handleTypedAnswer(_typingController.text),
              backgroundColor: Colors.green,
              child: const Icon(Icons.check, color: Colors.white, size: 32),
            )
          : null,
      body: Stack(
        children: [
          Column(
            children: [
              SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      child: Row(
                        children: [
                          // Left: difficulty level indicator
                          Expanded(
                            child: _hasDifficulty
                                ? Row(children: [
                                    const Icon(Icons.bar_chart, color: Colors.purple, size: 20),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${s('level')}: $_difficultyLevel',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ])
                                : const SizedBox.shrink(),
                          ),
                          // Center: score
                          Row(children: [
                            const Icon(Icons.star, color: Colors.amber, size: 20),
                            const SizedBox(width: 4),
                            Text(
                              '${s('score')}: $_score',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ]),
                          // Right: close/pause button
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: !_isGameCompleted
                                  ? IconButton(
                                      icon: const Icon(Icons.close, color: Colors.red, size: 28),
                                      onPressed: () async {
                                        await _saveGameState();
                                        if (context.mounted) Navigator.pop(context);
                                      },
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    DragonProgress(
                      dragonSteps: _dragonSteps,
                      stepsLabel: s('steps'),
                    ),
                  ],
                ),
              ),
              // Sound card — smaller flex in typing mode to give more room to input
              Expanded(
                flex: isTypingMode ? 1 : 2,
                child: Container(
                  color: Colors.blue.shade50,
                  padding: EdgeInsets.all(isTypingMode ? 8 : 20),
                  child: Center(
                    child: _isGameCompleted
                        ? IgnorePointer(
                            child: Opacity(
                              opacity: 0.5,
                              child: SoundCard(
                                audioPath: soundFile,
                                audioService: _audioService,
                                imageAsset: null,
                                tapLabel: s('tapToHear'),
                              ),
                            ),
                          )
                        : SoundCard(
                            audioPath: soundFile,
                            audioService: _audioService,
                            imageAsset: null,
                            tapLabel: s('tapToHear'),
                          ),
                  ),
                ),
              ),
              // Bottom: typing field or option buttons
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.green.shade50,
                  child: isTypingMode
                      ? SingleChildScrollView(
                          child: TypeAnswerField(
                            controller: _typingController,
                            onSubmit: _handleTypedAnswer,
                            isEnabled: !_isAnswered && !_isGameCompleted,
                            label: s('typeLabel'),
                            hint: s('typeHint'),
                            checkLabel: s('check'),
                            onHint: !_isAnswered && !_isGameCompleted
                                ? () => setState(() => _showHint = true)
                                : null,
                            hintAnimalName: _showHint
                                ? AppStrings.of(lang, _currentLevel!.correctAnimal.id)
                                : null,
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(20),
                          child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: gridCrossAxisCount,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: gridChildAspectRatio,
                            ),
                            itemCount: optionCount,
                            itemBuilder: (context, index) {
                              final animal = _currentLevel!.options[index];
                              final isCorrect = animal.id == correctAnimal.id;
                              return AnimalOptionButton(
                                animal: animal,
                                isPictureMode: isPictureMode,
                                language: lang,
                                onTap: _isGameCompleted
                                    ? null
                                    : () => _handleAnswer(isCorrect),
                              );
                            },
                          ),
                        ),
                ),
              ),
            ],
          ),
          if (_showWinOverlay == true && !_isGameCompleted)
            WinOverlay(message: s('correct')),
          if (_showLoseOverlay == true)
            LoseOverlay(message: s('tryAgain')),
          if (_showVideoReward)
            Positioned.fill(
              child: VideoRewardOverlay(
                settings: context.read<SettingsService>(),
                onClose: _onVideoFinished,
              ),
            ),
          if (_isGameCompleted && !_showVideoReward)
            CompletionOverlay(
              onRestart: _hasDifficulty ? _advanceDifficulty : _restartGame,
              onClose: () async {
                await _saveGameState();
                if (context.mounted) Navigator.pop(context);
              },
              title: s('congrats'),
              subtitle: s('reachedEnd'),
              playAgainLabel: _hasDifficulty ? s('nextLevel') : s('playAgain'),
              closeLabel: s('close'),
            ),
        ],
      ),
    );
  }
}
