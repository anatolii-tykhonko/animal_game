# Project Initialization & Requirements Gathering

When starting a new project or a major module, do not generate code or final architectures immediately. Follow this procedure to create the Technical Requirements and Design Document (TRDD):

## 1. Initial Assessment
* Analyze the initial game concept or feature request.
* Identify missing information regarding core gameplay, target age group, visual style, audio needs, and technical constraints.

## 2. Mandatory Clarification Phase
* Before drafting the TRDD, you MUST ask the user targeted clarifying questions to fill in the gaps. 
* Focus questions on:
  * Specific age range (e.g., 2-4 vs 5-8) to determine UI scale, complexity, and safety measures.
  * Expected platforms (iOS, Android, Tablet/Phone) and screen orientation.
  * Core game mechanics, feedback loops, and win/loss conditions.
  * Monetization/Analytics constraints (e.g., strict no-tracking policies for kids).

## 3. Draft the Document
Once the user provides the answers, generate a `requirements.md` file containing:
* **Core Vision & Requirements:** Main gameplay loop, objectives, and target audience guidelines.
* **UI/UX & Audio Design:** Visual style, color palette, required animations, and sound design.
* **Technical Architecture:** State management approach, data persistence strategy, and Flame/Flutter widget hierarchy.

## 4. Final Approval
* Present the drafted `requirements.md`.
* **STOP.** Wait for the user's explicit approval or requested edits before proceeding to the Pseudocode or Implementation phases.