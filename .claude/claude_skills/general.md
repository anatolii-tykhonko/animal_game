## Project Commands
* Install dependencies: `flutter pub get`
* Run game: `flutter run`
* Linter: `flutter analyze`
* Code generation (if using build_runner): `flutter pub run build_runner build --delete-conflicting-outputs`

## Architecture & Stack
* **Framework:** Flutter (Dart).
* **Game Engine/UI:** Flame (for 2D) or basic Flutter animations (CustomPaint, Rive, Lottie).
* **State Management:** Riverpod or Provider.
* **Audio:** audioplayers (for background music and effects).

## Code Guidelines
* Follow Dart standards (Effective Dart).
* Maximize use of `const` constructors for UI optimization.
* Separate game logic from UI components.
* Handle errors without crashing (game should continue running or softly restart the level).

## Children's Game Specifics (UI/UX)
* **Controls:** Large buttons (at least 64x64 logical pixels), obvious tap zones.
* **Visuals:** Bright colors, high contrast, minimal text (focus on icons and voiceovers).
* **Safety:** Prevent accidental game exits, no external links without a parental gate.
* **Feedback:** Immediate visual and audio response to any player action.