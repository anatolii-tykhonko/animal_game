import 'dart:math';
import '../models/animal.dart';
import '../models/level.dart';

class LevelService {
  final List<Animal> _availableAnimals = [
    Animal(
      id: 'cow',
      name: 'Cow',
      imageAsset: 'assets/images/cow.png',
      soundAsset: 'audio/cow.wav',
    ),
    Animal(
      id: 'dog',
      name: 'Dog',
      imageAsset: 'assets/images/dog.png',
      soundAsset: 'audio/dog.wav',
    ),
    Animal(
      id: 'horse',
      name: 'Horse',
      imageAsset: 'assets/images/horse.png',
      soundAsset: 'audio/horse.wav',
    ),
    Animal(
      id: 'goat',
      name: 'Goat',
      imageAsset: 'assets/images/goat.png',
      soundAsset: 'audio/goat.wav',
    ),
    Animal(
      id: 'cat',
      name: 'Cat',
      imageAsset: 'assets/images/cat.png',
      soundAsset: 'audio/cat.wav',
    ),
    Animal(
      id: 'lion',
      name: 'Lion',
      imageAsset: 'assets/images/lion.png',
      soundAsset: 'audio/lion.wav',
    )
  ];
  final Random _random = Random();

  // Returns how many answer options to show for a given difficulty.
  // difficulty 1 → 3, difficulty 2 → 4, difficulty 3+ → 6 (all animals)
  int optionCountForDifficulty(int difficulty) {
    if (difficulty <= 1) return 3;
    if (difficulty == 2) return 4;
    return min(6, _availableAnimals.length);
  }

  Level nextLevel(
    int previousLevelNumber,
    LevelMode? preferredMode, {
    int difficulty = 1,
  }) {
    final optionCount = optionCountForDifficulty(difficulty);
    if (_availableAnimals.length < optionCount) {
      throw Exception('Not enough animals available. Need at least $optionCount.');
    }

    final mode = preferredMode ??
        (previousLevelNumber < 5 ? LevelMode.picture : LevelMode.text);

    final correctAnimal = _availableAnimals[_random.nextInt(_availableAnimals.length)];

    final incorrectAnimals = <Animal>[];
    while (incorrectAnimals.length < optionCount - 1) {
      final candidate = _availableAnimals[_random.nextInt(_availableAnimals.length)];
      if (candidate.id != correctAnimal.id && !incorrectAnimals.contains(candidate)) {
        incorrectAnimals.add(candidate);
      }
    }

    final options = [correctAnimal, ...incorrectAnimals]..shuffle(_random);

    return Level(
      correctAnimal: correctAnimal,
      options: options,
      mode: mode,
      levelNumber: previousLevelNumber + 1,
    );
  }

  void addAnimal(Animal animal) {
    _availableAnimals.add(animal);
  }
}
