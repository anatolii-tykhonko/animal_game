# Feature Review and Pseudocode Workflow

When tasked with implementing a feature, strictly follow this workflow before writing any functional Dart/Flutter code:

## 1. Feature Review
* Analyze the feature requirements or the provided feature `.md` file.
* Identify missing assets (images, audio) and clarify edge cases specific to children's games (e.g., rapid tapping, multi-touch, state loss).
* Confirm alignment with the core `CLAUDE.md` guidelines (large tap targets, high contrast, safe state handling).

## 2. Pseudocode Generation
* Draft the proposed solution using Dart-like pseudocode.
* Outline the Widget tree structure or Flame components hierarchy.
* Define State Management logic (Riverpod/Provider state classes, variables, and methods).
* Detail the UI/UX feedback loop (where sounds and animations trigger).

## 3. Alignment Request
* **STOP** generation after presenting the review and pseudocode.
* Explicitly ask the user for approval: "Does this logic and structure look correct? Please approve or provide feedback before I generate the actual code."

## 4. Revisions
* Incorporate user feedback into the pseudocode.
* Repeat Step 3 until the user explicitly approves the design.
* Proceed to write the final production code only after receiving clear confirmation.