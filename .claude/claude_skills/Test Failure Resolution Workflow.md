# Test Failure Resolution Workflow

When a test fails during the execution of `flutter test`, do not blindly guess the fix. Strictly follow this analytical workflow to resolve the issue:

## 1. Root Cause Analysis
* **Read the Stack Trace:** Identify the exact line where the failure occurred. 
* **Determine the Source:** Conclude whether the failure is due to:
  * **Faulty Game Logic:** The actual Dart code has a bug or unhandled state.
  * **Faulty Test Setup:** The test is poorly written (e.g., missing mock, wrong `pump` duration, missing `MaterialApp` ancestor).
  * **Environment/Asset Issue:** Missing images, uninitialized plugins (like audio), or incorrect path references.

## 2. Common Flutter/Children's Game Pitfalls to Check
* **Infinite Animations:** If `tester.pumpAndSettle()` times out, check if a continuous animation (like Flame game loop, Rive, or Lottie) is running. Use `tester.pump(Duration(...))` instead.
* **Widget Not Found:** Verify if the widget requires scrolling to be visible or if the 64x64 tap target is actually rendered on screen.
* **Unmocked Plugins:** Ensure `audioplayers` or platform channels are properly mocked; tests will crash if they try to access native device audio.

## 3. The Resolution Loop
1. **Explain the Issue:** Briefly output the identified root cause. (e.g., *"The test failed because the `SuccessSound` method attempted to call the native audio player without a mock."*)
2. **Propose the Fix:** State what file will be modified and how.
3. **Implement & Re-run:** Apply the code changes and immediately run `flutter test` again.

## 4. Anti-Loop Failsafe (CRITICAL)
* If the same test fails **3 times in a row** despite your attempted fixes, **STOP immediately**.
* Do not attempt a 4th fix. 
* Present a summary of what you tried, show the persistent error, and explicitly ask the user for manual guidance or permission to skip/refactor.