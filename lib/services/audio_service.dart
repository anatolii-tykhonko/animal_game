import 'package:audioplayers/audioplayers.dart';
import '../models/animal.dart';

class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playAnimalSound(Animal animal) async {
    await _audioPlayer.play(AssetSource(animal.soundAsset));
  }

  /// Play audio file from assets/audio/ folder
  /// [audioPath] should be relative to assets/audio/ (e.g., "cow.wav" or "dog.wav")
  Future<void> playAudio(String audioPath) async {
    await _audioPlayer.play(AssetSource('audio/$audioPath'));
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
