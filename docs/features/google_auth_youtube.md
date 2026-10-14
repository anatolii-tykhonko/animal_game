# Google Auth + YouTube Personalized Video Reward

## 1. Overview
* **Feature Name:** Google Sign-In + YouTube Personalized Video Reward
* **Objective:** Allow a parent to sign in with the child's Google account inside the app. After sign-in, the video reward picks a random video from the child's YouTube playlist via YouTube Data API v3, so the child sees content from their own curated playlist rather than a hardcoded video ID.

## 2. UI/UX & Feedback
* **Visuals (Settings Screen additions):**
  - "Connect Google Account" button (large, ≥64 height) when not signed in
  - Shows signed-in account email + avatar when connected
  - "Sign Out" button when connected
  - "Select Playlist" dropdown populated from child's YouTube playlists after sign-in
  - Existing Video ID / Playlist ID manual fields hidden when Google account connected (API takes priority)
* **Visuals (VideoRewardPage):**
  - No change — still loads `m.youtube.com/watch?v=ID` with Skip button and countdown
* **Audio:** No change
* **Accessibility & Safety:**
  - If API call fails or quota exceeded → fall back to manual `youtubeVideoId` from SettingsService
  - If no videos in playlist → fall back to manual Video ID
  - Playlist video list cached locally (SharedPreferences) for 24 hours to minimise API calls

## 3. Technical Design

### 3.1 New Service: `YoutubeAuthService`
```
YoutubeAuthService (ChangeNotifier)
  fields:
    GoogleSignInAccount? currentAccount
    List<YouTubePlaylist> playlists          // fetched after sign-in
    String? selectedPlaylistId              // saved to SharedPreferences
    List<String> cachedVideoIds             // saved to SharedPreferences, TTL 24h
    DateTime? cacheTimestamp
  methods:
    Future<void> signIn()
    Future<void> signOut()
    Future<void> fetchPlaylists()           // GET /youtube/v3/playlists
    Future<void> fetchPlaylistVideos(String playlistId)  // GET /youtube/v3/playlistItems
    String? pickRandomVideoId()
    Future<void> load()                     // restore from SharedPreferences on startup
```

### 3.2 Updated `SettingsService`
- Add `String? googleSelectedPlaylistId` field
- `videoSourceMode` enum: `manual` | `googlePlaylist`
- Priority in `VideoRewardPage`: if `YoutubeAuthService.currentAccount != null` && `cachedVideoIds.isNotEmpty` → use `pickRandomVideoId()`; else → fall back to manual `youtubeVideoId`

### 3.3 Updated `VideoRewardPage`
```
initState:
  final authService = context.read<YoutubeAuthService>()
  final videoId = authService.pickRandomVideoId() ?? settings.youtubeVideoId
  loadRequest(m.youtube.com/watch?v=videoId)
```

### 3.4 Google Cloud Console Setup (developer, one-time)
| Platform | Що потрібно |
|---|---|
| Android | OAuth 2.0 Client ID → Application type: Android → Package name + SHA-1 fingerprint |
| iOS | OAuth 2.0 Client ID → Application type: iOS → Bundle ID |
| Both | Enable "YouTube Data API v3" in the project |

Config files:
- Android: `google-services.json` → `android/app/`
- iOS: `GoogleService-Info.plist` → `ios/Runner/` + reversed client ID as URL scheme in `Info.plist`

### 3.5 API Calls

**Fetch user playlists:**
```
GET https://www.googleapis.com/youtube/v3/playlists
  ?part=snippet&mine=true&maxResults=50
  Authorization: Bearer {access_token}
```

**Fetch videos from playlist:**
```
GET https://www.googleapis.com/youtube/v3/playlistItems
  ?part=snippet&playlistId={id}&maxResults=50
  Authorization: Bearer {access_token}
```
Cost: 1 unit per request. Free quota: 10,000 units/day → supports ~10,000 users/day with 24h caching.

### 3.6 Caching Strategy
- After fetching playlist videos → save `List<String> videoIds` + `DateTime timestamp` to SharedPreferences
- On next app launch: if cache age < 24h → use cached list, skip API call
- If API fails → use cached list regardless of age
- If cache empty + API fails → fall back to manual `youtubeVideoId`

## 4. Dependencies
```yaml
google_sign_in: ^6.2.0
http: ^1.2.0         # already may be present; for YouTube API calls
```

## 5. Implementation Steps
1. [ ] Google Cloud Console: create project, enable YouTube Data API v3, create Android + iOS OAuth Client IDs
2. [ ] Add `google-services.json` to `android/app/`
3. [ ] Add `GoogleService-Info.plist` to `ios/Runner/` + URL scheme to `Info.plist`
4. [ ] Add `google_sign_in` and `http` to `pubspec.yaml`
5. [ ] Create `lib/services/youtube_auth_service.dart` (ChangeNotifier)
6. [ ] Register `YoutubeAuthService` in `main.dart` MultiProvider
7. [ ] Update `lib/ui/settings/settings_page.dart` — add Sign In button, playlist selector
8. [ ] Update `lib/ui/game/video_reward_page.dart` — pick video from `YoutubeAuthService` first
9. [ ] Update `lib/services/settings_service.dart` — add `videoSourceMode` field
10. [ ] Add localization strings for auth UI (EN + UA)

## 6. Acceptance Criteria
* [ ] Settings screen shows "Connect Google Account" button when not signed in
* [ ] After sign-in, user email shown and playlists listed in dropdown
* [ ] Parent can select a playlist; selection persisted across app restarts
* [ ] Video reward plays a random video from selected playlist
* [ ] Playlist video list cached 24h; no API call on every game session
* [ ] If API fails or quota exceeded → falls back to manual Video ID silently
* [ ] Sign Out clears cached video list and returns to manual mode
* [ ] Works on both Android and iOS with platform-specific OAuth Client IDs
