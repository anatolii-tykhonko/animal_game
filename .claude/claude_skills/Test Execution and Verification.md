# Test Execution and Verification

When instructed to run tests or verify code changes, follow this execution loop:

## 1. Execution
* Run the command: `flutter test` (or `flutter test path/to/file_test.dart` for specific tests).
* Analyze the terminal output.

## 2. Verification
* **If all tests pass:** Confirm success and wait for the next task.
* **If any test fails:** 
  * Extract the error message and stack trace.
  * Identify whether the failure is in the implementation code or the test setup itself.

## 3. Resolution Loop
* Automatically propose and apply a fix to the code or test based on the error logs.
* Re-run the tests.
* Repeat this loop. If tests fail consecutively 3 times for the same reason, **STOP** and ask the user for guidance.