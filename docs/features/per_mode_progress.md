# Feature: Per-Mode Progress Bar

## 1. Overview
* **Feature Name:** Per-Mode Progress Bar
* **Objective:** Each game mode (Picture / Text / Type) has its own independent progress (0–10 steps) and score. Completing one mode does not affect another.

## 2. UI/UX & Feedback
* **Visuals:** The DragonProgress bar shown during a game session reflects only the current mode's saved progress. No other changes to layout.
* **Audio / Accessibility:** No changes.

## 3. Technical Design
* **State Management:** `GameStateService` stores steps, score, and levelNumber per mode using mode-namespaced keys (e.g., `game_steps_picture`, `game_steps_text`, `game_steps_typing`). `GamePage` reads/writes using `_selectedMode` as the key.
* **Ordering fix:** `_loadGameState()` is moved from `initState` to `didChangeDependencies` (behind a `_stateLoaded` flag) so that `_selectedMode` is guaranteed to be set from route args before the load happens.
* **Completion:** Each mode has its own completion state — completing Picture Mode does not trigger completion in Text Mode.
* **Widgets:** `DragonProgress` is unchanged (stateless). `GameSelectPage` mode cards can optionally show a small progress badge (loaded from saved state).

## 4. Implementation Steps
1. [ ] Update `GameStateService` — namespaced keys per mode, `saveGameState(mode, ...)` / `loadGameState(mode)` / `clearGameState(mode)`
2. [ ] Fix `GamePage` — move load call from `initState` to `didChangeDependencies` (first-call flag), pass `_selectedMode` to all state ops
3. [ ] Update tests

## 5. Acceptance Criteria
* [ ] Playing Picture Mode advances only its bar; Text and Type bars are unchanged.
* [ ] Each mode's progress persists across app restarts independently.
* [ ] Completing one mode (10/10) does not complete the others.
* [ ] Clearing / restarting in one mode resets only that mode's data.
