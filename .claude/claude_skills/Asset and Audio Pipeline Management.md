# Asset and Audio Management Guidelines

When adding, modifying, or referencing game assets (images, audio, fonts, animations), follow these strict rules:

## 1. Asset Organization
* **Audio:** Put background music in `assets/audio/bgm/` and sound effects in `assets/audio/sfx/`.
* **Images/Vectors:** Put UI elements in `assets/images/ui/` and gameplay items in `assets/images/gameplay/`.
* **Animations:** Put Rive or Lottie files in `assets/animations/`.

## 2. Pubspec Tracking
* Every time you add a new asset folder or specific asset file, automatically verify and update the `flutter:` -> `assets:` section in `pubspec.yaml`.
* Run `flutter pub get` immediately after modifying `pubspec.yaml`.

## 3. Implementation Rules
* **Precise Naming:** Use clear, snake_case names (e.g., `button_tap.mp3`, `level_complete.png`).
* **Preloading:** Ensure all heavy visual assets and frequently played audio effects are preloaded during the initial game loading screen to prevent gameplay stuttering.
* **Failsafes:** Always wrap asset/audio loading code in try-catch blocks to prevent the game from freezing if an asset is missing.