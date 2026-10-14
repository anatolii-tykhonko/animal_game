# Game State Persistence Guidelines

To ensure children do not lose their game progress (unlocked levels, achievements, custom settings) when the app closes, implement persistence using these guidelines:

## 1. Local Storage Strategy
* Use a lightweight local database/key-value store (e.g., `shared_preferences` or `hive`).
* Keep the data structure simple (e.g., JSON maps tracking `unlocked_levels`, `current_score`, `audio_muted`).

## 2. Execution Flow
* **Save Conditions:** Automatically trigger a save state immediately upon:
  * Level completion.
  * Adjusting parental control/audio settings.
  * Exiting a mini-game.
* **Load Conditions:** Load the persisted state during the app initialization/splash screen phase. Fall back to safe default values if no saved state exists.

## 3. Safety & Robustness
* **Atomic Writes:** Ensure saving operations do not block the main UI thread (use asynchronous `async/await`).
* **Data Corruption Failsafe:** If the saved file is corrupted or fails to parse, catch the exception, log it safely, and reset to a clean default state rather than crashing the game.