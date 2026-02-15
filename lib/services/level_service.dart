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

  Level nextLevel(int previousLevelNumber, LevelMode? preferredMode) {
    if (_availableAnimals.length < 3) {
      throw Exception('Not enough animals available. Need at least 3.');
    }

    // Determine mode based on level number or preference
    final mode = preferredMode ?? 
        (previousLevelNumber < 5 ? LevelMode.picture : LevelMode.text);

    // Select correct animal
    final correctAnimal = _availableAnimals[_random.nextInt(_availableAnimals.length)];

    // Select two incorrect animals
    final incorrectAnimals = <Animal>[];
    while (incorrectAnimals.length < 2) {
      final candidate = _availableAnimals[_random.nextInt(_availableAnimals.length)];
      if (candidate.id != correctAnimal.id && !incorrectAnimals.contains(candidate)) {
        incorrectAnimals.add(candidate);
      }
    }

    // Combine and shuffle options
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
