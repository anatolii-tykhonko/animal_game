# Feature Generation Instruction

When requested to design or implement a new feature, create a new Markdown file (e.g., `docs/features/feature_name.md`) strictly following this structure:

## 1. Overview
* **Feature Name:** 
* **Objective:** Short description of what the feature does and its value for the children's game.

## 2. UI/UX & Feedback
* **Visuals:** Required animations, colors, and layout (ensure tap targets are >= 64x64).
* **Audio:** Specific sound effects needed for interactions (tap, success, error).
* **Accessibility & Safety:** Edge cases for kids (e.g., multi-touch prevention, no dead ends).

## 3. Technical Design
* **State Management:** Providers/State variables to create or modify.
* **Widgets/Flame Components:** New classes to implement.
* **Dependencies:** Any specific packages or assets required.

## 4. Implementation Steps
1. [ ] Step 1
2. [ ] Step 2

## 5. Acceptance Criteria
* [ ] Criteria 1 (e.g., "Button plays sound X on tap").
* [ ] Criteria 2