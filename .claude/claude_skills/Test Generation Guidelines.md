# Test Generation Guidelines

When tasked with writing tests or following a Test-Driven Development (TDD) approach, strictly adhere to the following structure and rules:

## 1. Testing Stack & Scope
* **Unit Tests (`test/`):** Game logic, state management (Riverpod/Provider state transitions), utility functions.
* **Widget Tests (`test/`):** UI components, ensuring minimum tap targets (>= 64x64), rendering of visual feedback, and "parental gate" interactions.
* **Mocking:** Use `mockito` or `mocktail` for audio players, external services, or complex Flame engine components.

## 2. Test Structure
For every new feature, create a corresponding test file (e.g., `feature_name_test.dart`) using the Arrange-Act-Assert pattern:
* **Arrange:** Set up the required state, mock audio/Flame dependencies.
* **Act:** Simulate user interaction (e.g., tapping a large button, triggering a win condition).
* **Assert:** Verify the state changed correctly and no crashes occurred.

## 3. Children's Game Specific Checks
* **Rapid Input:** Write tests that simulate rapid, repeated tapping to ensure the game state does not break or crash.
* **Asset Loading:** Mock asset loading to prevent tests from failing due to missing images/audio files.
* **Failsafe Navigation:** Verify that back-button presses or accidental swipes do not exit the game abruptly.

## 4. Workflow
1. Analyze the feature code or approved pseudocode.
2. Draft the test cases covering standard flows and edge cases (rapid taps, missing state).
3. Output the test code and wait for the results of `flutter test`.
4. Fix any failing tests before considering the feature complete.