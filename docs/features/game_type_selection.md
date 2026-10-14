# Feature: Game Type Selection + Typing Level

## 1. Overview
* **Feature Name:** Game Type Selection
* **Objective:** Let the player choose a game mode before starting, and add a new "Typing" mode where the child types the animal name instead of tapping a picture or text button.

## 2. UI/UX & Feedback
* **Visuals:** New `GameSelectPage` with 3 large cards (>= 64x64 tap targets), one per mode. Each card has a big icon, a title, and a short description.
* **Audio:** No audio on the selection screen. Existing win/lose/completion sounds carry into game.
* **Accessibility & Safety:**
  * Typing mode hides the animal image in the SoundCard (would give away the answer).
  * Text field auto-focuses so the child can type immediately.
  * Comparison is case-insensitive and trims whitespace.
  * Multi-touch prevention: `TypeAnswerField` ignores submit while answer is already locked in (`_isAnswered == true`).

## 3. Technical Design
* **State Management:** `GamePage` receives `LevelMode selectedMode` via Navigator arguments. It passes `selectedMode` as `preferredMode` to `LevelService.nextLevel()`, locking the mode for the whole session.
* **Widgets/Flame Components:**
  * `GameSelectPage` — new screen with 3 mode cards.
  * `TypeAnswerField` — `StatefulWidget` with a `TextField` + Submit button; calls `onSubmit(String)`.
* **Dependencies:** None new.

## 4. Implementation Steps
1. [ ] Add `LevelMode.typing` to `lib/models/level.dart`
2. [ ] Create `lib/ui/select/game_select_page.dart`
3. [ ] Create `lib/ui/game/widgets/type_answer_field.dart`
4. [ ] Update `lib/main.dart` — add `/select` route
5. [ ] Update `lib/ui/home/home_page.dart` — Start navigates to `/select`
6. [ ] Update `lib/ui/game/game_page.dart`:
   - Accept `LevelMode` from Navigator args
   - Pass `selectedMode` to `LevelService.nextLevel()`
   - Conditionally show `imageAsset` in `SoundCard` (picture mode only)
   - Swap `GridView` for `TypeAnswerField` when mode is `typing`
7. [ ] Add tests for new widgets and mode routing

## 5. Acceptance Criteria
* [ ] Home → Select screen shows 3 mode cards.
* [ ] Tapping a card starts the game in that mode and keeps it for all levels.
* [ ] Picture mode: top shows animal image + sound; bottom shows 3 picture buttons.
* [ ] Text mode: top shows sound only; bottom shows 3 text-name buttons.
* [ ] Typing mode: top shows sound only; bottom shows a text field + Submit button.
* [ ] Correct typed answer (case-insensitive, trimmed) triggers win overlay.
* [ ] Wrong typed answer triggers lose overlay and resets the field.
* [ ] Submit is ignored if answer already locked in (`_isAnswered`).
