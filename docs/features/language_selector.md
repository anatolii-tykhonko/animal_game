# Feature: Language Selector (English / Ukrainian)

## 1. Overview
* **Feature Name:** Language Selector
* **Objective:** Let the user switch between English and Ukrainian. All UI text and animal names update instantly. A single dictionary file is the source of truth for all strings.

## 2. UI/UX & Feedback
* **Visuals:** Two toggle buttons on the Home page (`EN` / `UA`) that highlight the active language. No separate settings screen needed.
* **Audio:** Animal sound files stay the same (sounds are universal). Typing-mode answer comparison uses the translated animal name.
* **Accessibility & Safety:** Language choice is held in a `ChangeNotifier` at the top of the widget tree; all screens react without navigation.

## 3. Technical Design
* **State Management:** `LanguageService extends ChangeNotifier` holds `AppLanguage language`. Wrapped in `ChangeNotifierProvider` above `MaterialApp` so all widgets can access it.
* **Dictionary:** `lib/l10n/app_strings.dart` — a single Dart file with a `Map<AppLanguage, Map<String, String>>`. Widgets call `AppStrings.of(language, key)`.
* **Widgets that need translation:** `HomePage`, `GameSelectPage`, `GamePage` (score row), `SoundCard`, `AnimalOptionButton`, `TypeAnswerField`, `WinOverlay`, `LoseOverlay`, `DragonProgress`, `CompletionOverlay`.
* **Typing-mode answer:** `_handleTypedAnswer` compares the typed text against the translated animal name for the current language.
* **Dependencies:** `provider` (already in pubspec.yaml).

## 4. Implementation Steps
1. [ ] Create `lib/l10n/app_strings.dart` — `AppLanguage` enum + `AppStrings` class with all keys
2. [ ] Create `lib/services/language_service.dart` — `ChangeNotifier`
3. [ ] Update `lib/main.dart` — wrap with `ChangeNotifierProvider<LanguageService>`
4. [ ] Update `lib/ui/home/home_page.dart` — language toggle + translated title/button
5. [ ] Update `lib/ui/select/game_select_page.dart` — translated mode names/descriptions
6. [ ] Update `lib/ui/game/game_page.dart` — translated score row, pass language to typing answer check
7. [ ] Update `lib/ui/game/widgets/animal_option_button.dart` — show translated animal name
8. [ ] Update `lib/ui/game/widgets/type_answer_field.dart` — accept translated label/hint
9. [ ] Update `lib/ui/game/widgets/sound_card.dart` — translated "Tap to hear!" label
10. [ ] Update `lib/ui/game/widgets/win_overlay.dart` — translated "Correct!"
11. [ ] Update `lib/ui/game/widgets/lose_overlay.dart` — translated "Try Again!"
12. [ ] Update `lib/ui/game/widgets/dragon_progress.dart` — translated "Steps:"
13. [ ] Update `lib/ui/game/widgets/completion_overlay.dart` — translated texts and buttons
14. [ ] Update tests

## 5. Acceptance Criteria
* [ ] Tapping `EN`/`UA` on the home screen switches all text instantly (no restart).
* [ ] Animal names in text mode and typing mode appear in the selected language.
* [ ] Typing-mode answer is accepted in the currently selected language.
* [ ] All overlays and progress widgets show text in the selected language.
