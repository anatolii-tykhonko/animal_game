# Video Reward Feature

## 1. Overview
* **Feature Name:** Video Reward After Level Completion
* **Objective:** After the player completes a level (dragonSteps >= 10), show a short reward video before the CompletionOverlay. Video source and time limit are configurable in a Settings screen accessible via gear icon on HomeScreen.

## 2. UI/UX & Feedback
* **Visuals:**
  - Full-screen `VideoRewardPage` (separate navigation route, not overlay)
  - Large "Skip" button (80×80) always visible in top-right corner with skip icon + "Skip" label
  - Countdown timer top-left showing remaining seconds (if limit set)
  - Black background while video loads
* **Audio:** Video audio plays via WebView; game audio is stopped before navigation
* **Accessibility & Safety:**
  - Skip button always reachable regardless of video state
  - If no internet → skip VideoRewardPage silently, go directly to CompletionOverlay
  - `_showVideoReward` flag prevents CompletionOverlay from rendering during video navigation
  - `_done` guard in VideoRewardPage prevents double-pop

## 3. Technical Design
* **State Management:**
  - `SettingsService` (ChangeNotifier, SharedPreferences-backed) registered in MultiProvider in `main.dart`
  - Fields: `videoRewardEnabled`, `videoTimeLimitSeconds`, `youtubeVideoId`, `youtubePlaylistId`
  - `GamePage`: `_showVideoReward` bool flag — suppresses CompletionOverlay while on VideoRewardPage
* **Widgets/Classes:**
  - `VideoRewardPage` — full-screen Scaffold with WebView + Skip button + countdown
  - `SettingsPage` — settings screen with enable toggle, time limit dropdown, video/playlist ID fields
  - `VideoRewardPlayer` (abstract interface) — `buildPlayerWidget()` — kept for future alternative implementations
  - `YoutubeVideoRewardPlayer implements VideoRewardPlayer` — legacy IFrame implementation (not used by VideoRewardPage)
* **Player Implementation:**
  - `webview_flutter` + `webview_flutter_android` for direct YouTube page loading
  - Chrome user-agent: `Mozilla/5.0 ... Chrome/120.0.0.0 Mobile Safari/537.36` — prevents YouTube from detecting Android WebView
  - `AndroidWebViewController.setMediaPlaybackRequiresUserGesture(false)` — allows autoplay with sound
  - Loads `https://m.youtube.com/watch?v=VIDEO_ID` or `https://m.youtube.com/playlist?list=PLAYLIST_ID` directly (NOT embed iframe — embed is blocked by most channels)
* **Navigation Flow:**
  ```
  _handleAnswer(correct, dragonSteps=10)
    → 2s delay → check connectivity
    → if online: setState(_showVideoReward=true)
    → Navigator.push(VideoRewardPage) [awaited]
    → on pop: setState(_showVideoReward=false)
    → CompletionOverlay renders
  ```
* **Dependencies:**
  - `webview_flutter: ^4.0.0`
  - `webview_flutter_android: ^3.0.0`
  - `youtube_player_iframe: ^4.0.0` (kept in pubspec, used only by YoutubeVideoRewardPlayer — not active)
  - `connectivity_plus: ^6.0.0`
  - `provider: ^6.1.2` (already present)

## 4. Settings Screen Fields

| Поле | Тип | Дефолт | Опис |
|---|---|---|---|
| Відео нагорода | Switch | `true` | Вмикає/вимикає відео після рівня |
| Тривалість відео | Dropdown (15с / 30с / 60с / ∞) | `30` | Авто-закриття через N секунд |
| YouTube Video ID | TextField | `5Sj3lgwt_3I` | Конкретне відео (якщо плейліст не вказаний) |
| YouTube Playlist ID | TextField | порожньо | Якщо вказаний — відкриває плейліст замість окремого відео |

> Пріоритет: якщо `Playlist ID` заповнений → відкривається плейліст; інакше → `Video ID`.

> Планується: поле буде замінено/доповнено автоматичним вибором відео через Google Sign-In (див. `google_auth_youtube.md`).

## 5. Known Limitations
- YouTube embed iframe заблокований більшістю каналів (помилки 150–154) → використовується повна мобільна сторінка `m.youtube.com`
- WebView не ділиться cookies з YouTube-застосунком → користувач не залогінений, без персоналізації
- Персоналізація та вибір відео з акаунту дитини — реалізується в `google_auth_youtube.md`

## 6. Implementation Steps
1. [x] Add dependencies to pubspec.yaml
2. [x] Create `lib/services/video_reward_player.dart` (abstract interface)
3. [x] Create `lib/services/youtube_video_reward_player.dart` (IFrame implementation — legacy)
4. [x] Create `lib/services/settings_service.dart` (ChangeNotifier + SharedPreferences)
5. [x] Register `SettingsService` in `main.dart` MultiProvider
6. [x] Create `lib/ui/game/video_reward_page.dart` (WebView-based player screen)
7. [x] Create `lib/ui/settings/settings_page.dart`
8. [x] Update `home_page.dart` — gear icon → SettingsPage
9. [x] Update `game_page.dart` — navigate to VideoRewardPage on level completion

## 7. Acceptance Criteria
* [x] Gear icon on HomeScreen navigates to SettingsPage
* [x] SettingsPage: enable/disable toggle, time limit dropdown, Video ID field, Playlist ID field
* [x] After level completion (dragonSteps >= 10), VideoRewardPage opens before CompletionOverlay
* [x] Skip button (80×80) always closes video and returns to CompletionOverlay
* [x] Time limit auto-closes video after N seconds (countdown visible top-left)
* [x] No internet → video skipped silently, CompletionOverlay shows normally
* [ ] Personalized video from child's YouTube account (planned — see `google_auth_youtube.md`)
