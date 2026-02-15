import 'animal.dart';

enum LevelMode {
  picture,
  text,
}

class Level {
  final Animal correctAnimal;
  final List<Animal> options;
  final LevelMode mode;
  final int levelNumber;

  const Level({
    required this.correctAnimal,
    required this.options,
    required this.mode,
    required this.levelNumber,
  });
}
