# Daily Quest (Flutter + Firebase MVP)

Starter repository for the **Daily Quest** mobile app (iOS/Android) built with **Flutter (Material 3, Dart 3)**, **Riverpod**, **go_router**, **Firebase Auth/Firestore**, **dio**, and **shared_preferences**. Includes modular feature folders and clean-ish layering (presentation / application / domain / data).

## Folder structure
```
lib/
├── app/                # App root, router
├── core/               # Theme, widgets, shared utilities
├── features/
│   ├── auth/           # Auth flows + user profile persistence
│   ├── onboarding/     # Grade, nickname, avatar selection
│   ├── quest/          # Daily quest flow (home → tasks → completion)
│   ├── leaderboard/    # Top users
│   ├── assistant_chat/ # AI assistant chat with mock + Cloud Function modes
│   ├── profile/        # User profile screen
│   └── settings/       # App settings (AI mode toggle info)
├── firebase_options.dart   # Placeholder firebase config (replace with real values)
assets/seed/               # Local fallback daily quest tasks
firebase/firestore.rules   # Basic Firestore security rules
.env.example               # Env vars for AI endpoint & Firebase keys
analysis_options.yaml      # Lints
pubspec.yaml
```

## Features (MVP)
- **Auth:** email/password login & register, guest (anonymous) sign-in. After first sign-in, onboarding collects grade (5–11), nickname, avatar preset and stores `users/{uid}` with `nickname, grade, avatarId, xp, level, streak, lastCompletedDate, createdAt`.
- **Daily Quest:** loads tasks from Firestore collection `dailyQuests/{YYYY-MM-DD}/tasks`; falls back to bundled `assets/seed/daily_quests.json` if empty. MCQ tasks show progress, explanations placeholder, and completion updates submissions & XP.
- **Leaderboard:** simple top-10 by `xp` with client-side rank estimation.
- **AI Assistant Chat:** chat UI backed by `AiClient` abstraction. Defaults to **mock** responses; can call a Cloud Function endpoint via `AI_FUNCTION_URL`. Includes system safety prompt for kids.
- **Bottom nav:** Home, Leaderboard, Assistant, Profile, Settings.
- **State management:** Riverpod. Routing: go_router. HTTP: dio. Local storage: shared_preferences (included for future state caching).

## Setup
1. Install Flutter (>=3.22) and Dart 3.
2. Copy env template:
   ```bash
   cp .env.example .env
   ```
3. Create a Firebase project and add iOS/Android apps. Generate config values and update `.env` **and** `lib/firebase_options.dart` (placeholders now). You can alternatively pass runtime defines:
   ```bash
   flutter run \
     --dart-define=FIREBASE_API_KEY=... \
     --dart-define=FIREBASE_APP_ID=... \
     --dart-define=FIREBASE_MESSAGING_SENDER_ID=... \
     --dart-define=FIREBASE_PROJECT_ID=... \
     --dart-define=FIREBASE_ANDROID_APP_ID=...
   ```
4. Add Firebase packages:
   ```bash
   flutter pub get
   ```
5. (Optional) Configure a Cloud Function (HTTPS) that accepts `{ messages: [...], prompt: string }` and returns `{ reply: string }` for the AI assistant. Set `AI_FUNCTION_URL` in `.env` and `USE_AI_MOCK=false`. Otherwise, leave mock mode enabled.

### Running the app
```bash
flutter run
```
The app starts at `/auth`, then navigates to onboarding and the bottom-nav shell.

## Seeding daily quests
- Quick option: keep bundled `assets/seed/daily_quests.json` — used automatically when Firestore has no tasks for today.
- Firestore seeding (requires real Firebase config):
  ```bash
  dart run tool/seed_daily_quests.dart \
    --dart-define=FIREBASE_API_KEY=... \
    --dart-define=FIREBASE_APP_ID=... \
    --dart-define=FIREBASE_MESSAGING_SENDER_ID=... \
    --dart-define=FIREBASE_PROJECT_ID=... \
    --dart-define=FIREBASE_ANDROID_APP_ID=...
  ```
  The script writes each task under `dailyQuests/{date}/tasks/{id}`. Example JSON snippet is in `assets/seed/daily_quests.json`:
  ```json
  {
    "date": "2024-09-01",
    "tasks": [
      {
        "id": "math-001",
        "question": "What is 9 x 7?",
        "options": ["54", "56", "63", "72"],
        "correctIndex": 2,
        "explanation": "9 multiplied by 7 equals 63.",
        "points": 15,
        "gradeRange": [5, 11]
      }
    ]
  }
  ```

## Firestore Security Rules
See `firebase/firestore.rules` — allows users to read/write their own profile and submissions, public read-only `dailyQuests`, and blocks other writes.

## AI Safety prompt
The `CloudFunctionAiClient` prepends a system prompt: *“You are Daily Quest tutor for kids. Be kind, safe, avoid 18+ or dangerous instructions. Decline unsafe requests and suggest a safe alternative. Never ask for personal data.”*

## Assumptions
- Firebase options are supplied via `--dart-define` or by editing `lib/firebase_options.dart` with real keys.
- AI backend is an HTTPS endpoint returning `{ reply: string }`; when unavailable, mock mode stays on.
- XP/level logic is client-side and simplified (level = `xp/100 + 1`).
- Leaderboard uses client-side ordering; for production, move to Cloud Functions or Firestore aggregations.

## Next steps (not included)
- Persist streak updates and lastCompletedDate atomically in Firestore.
- Add avatar assets and richer UI polish.
- Add tests and error handling for offline mode.
