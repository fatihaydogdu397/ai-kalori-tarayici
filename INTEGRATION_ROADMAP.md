# Eatiq — Integration Roadmap (Backend ↔ Mobile)

> Kaynak: [APP_BLUEPRINT.md § Eksik Entegrasyonlar](APP_BLUEPRINT.md). Bu belge 13 açık task'ı detaylı tanımlar. Her task Jira'ya (EAT projesi, assignee: Kürşat Burak FARIZ, İngilizce) açılacaktır.
>
> **Hedef tarih:** iteratif — quick win'ler bu hafta, büyük epic'ler 2-3 sprint.

---

## Önceliklendirme Matrisi

| Faz | Task | Tip | Sadece | Zorluk | Backend Status |
|-----|------|-----|--------|--------|----------------|
| **P0 — Quick wins (backend hazır, mobil wire)** ||||||
| 1 | #6 Wire timezoneOffsetMinutes param | Task | Mobil | XS | ✅ hazır |
| 2 | #8 Handle WEEKLY_LIMIT_EXCEEDED | Task | Mobil | S | ✅ hazır |
| 3 | #7 Disliked foods chip on Anamnesis | Task | Mobil | S | ✅ hazır |
| 4 | #13 Dietary tags filter in Food Search | Task | Mobil | S | ✅ hazır |
| 5 | #11 Remove social_login_screen duplicate | Task | Mobil | XS | N/A |
| **P1 — Medium (mobile-only + cleanup)** ||||||
| 6 | #9 Wire nutrition.recommendMeal | Task | Mobil | M | ✅ hazır |
| 7 | #12 Resolve legacy SQLite cache | Task | Mobil | M | N/A |
| 8 | #2 Facebook Social Login | Feature | Mobil | M | ✅ hazır |
| 9 | #10 Remove food.generateMealPlan | Task | Backend | XS | cleanup |
| **P2 — Large (backend + mobile)** ||||||
| 10 | #4 Offline Mutation Queue | Feature | Mobil | L | N/A |
| 11 | #5 Apple Health → Backend Sync | Feature | BE+MOB | L | ❌ endpoint yok |
| 12 | #3 Push Notifications (FCM + APNs) | Feature | BE+MOB | XL | ❌ modül yok |
| 13 | #1 AI Dietitian Chat | Feature | BE+MOB | XL | ❌ modül yok (en büyük gap) |

---

## TASK #1 — Implement AI Dietitian Chat (Backend + Mobile Integration)

**Type:** Feature · **Priority:** High · **Size:** XL · **Epic:** AI Dietitian

### Summary (Jira EN)
`Implement AI Dietitian Chat end-to-end: backend module with streaming, chat history persistence, mobile real-time UI`

### Description
Currently `AiDietitianScreen` exists in mobile but `AIService.analyzeFood()` throws `UnimplementedError` and there is no backend endpoint. This is the largest integration gap. Deliver a production chat experience where users ask nutrition questions and receive answers grounded in their profile, recent meals, active diet plan, and blood test markers (if any).

### Backend Changes
- New module `src/dietitian/` with:
  - `DietitianMessage` entity (id, user_id, role enum `user|assistant|system`, content, created_at)
  - `DietitianSession` entity (id, user_id, started_at, last_message_at) — optional for future multi-thread
  - `dietitian.resolver.ts`:
    - Mutation `sendDietitianMessage(content: String!): DietitianMessage` — JWT, `@Throttle(20/min)`
    - Query `dietitianHistory(limit: Int=50, before: String): [DietitianMessage]` — JWT, `@Throttle(60/min)`
    - Mutation `clearDietitianHistory(): Boolean` — JWT, `@Throttle(5/min)`
  - `dietitian.service.ts`:
    - Build prompt with user profile + last 7 days `food_analyses` + active `DietPlan` + latest `BloodTest.markers`
    - Call AI chain (OpenAI → Gemini → Claude) with same fallback pattern as `FoodService`
    - Persist user + assistant messages to `dietitian_messages`
    - Hard limit: last 20 messages in context window
- Add Subscription (later phase): `onDietitianMessage` for streaming (SSE). V1 ships without streaming.
- Migration: `create_dietitian_messages`
- Freemium gate: Non-premium users limited to 10 messages/day (reuse `DailyScanCount` pattern → `DailyDietitianCount`).

### Mobile Changes
- Delete [lib/services/ai_service.dart](lib/services/ai_service.dart) stub
- Create [lib/services/api/dietitian_service.dart](lib/services/api/dietitian_service.dart) with:
  - `sendMessage(content)`, `loadHistory()`, `clearHistory()`
- Refactor [lib/screens/ai_dietitian_screen.dart](lib/screens/ai_dietitian_screen.dart):
  - Real message list (ListView.builder, reverse: true)
  - `MessageInput` widget with send button and typing indicator
  - Error states: rate limit, offline, AI failure
  - Empty state: "Start by asking..." with 3 suggested prompts (e.g. "What should I eat for lunch?", "Am I eating enough protein?", "Why am I not losing weight?")
- Add to [lib/services/app_provider.dart](lib/services/app_provider.dart): `dietitianMessages`, `sendDietitianMessage`
- AppLocalizations keys: `dietitian_empty_title`, `dietitian_empty_subtitle`, `dietitian_suggestion_1..3`, `dietitian_error_rate_limit`, `dietitian_daily_limit_reached`

### Acceptance Criteria
- [ ] User can send a message and receive AI response within 10s
- [ ] Message history persists across app restarts
- [ ] Free users blocked after 10 messages/day with paywall prompt
- [ ] Premium users unlimited
- [ ] AI response grounded in user's profile, last 7 days of meals, active diet plan
- [ ] If user has a completed blood test, AI references its markers
- [ ] Error states (rate limit, network, AI failure) handled gracefully
- [ ] All strings localized for 10 supported locales

### Testing Plan
- Backend: unit tests for prompt construction + AI fallback; e2e test for mutation
- Mobile: widget test for chat UI, integration test mocking backend
- Manual: send 15 messages as free user → confirms paywall; premium user → unlimited

### Dependencies
- None (independent feature)

---

## TASK #2 — Add Facebook Social Login to Mobile App

**Type:** Feature · **Priority:** Medium · **Size:** M · **Mobile only**

### Summary (Jira EN)
`Add Facebook Social Login button to mobile AuthScreen (backend already supports facebook provider)`

### Description
Backend's `socialLogin(provider, idToken)` mutation already accepts `facebook` with a working `FacebookStrategy`. Mobile currently only implements Google + Apple via `social_sign_in.dart`. Add Facebook to achieve feature parity.

### Mobile Changes
- Add dependency: `flutter_facebook_auth: ^7.0.0` to [pubspec.yaml](pubspec.yaml)
- iOS: update `ios/Runner/Info.plist` with Facebook App ID, URL schemes, LSApplicationQueriesSchemes (fb, fbapi, fbauth2, fbshareextension)
- Android: update `android/app/src/main/AndroidManifest.xml` with meta-data for Facebook App ID + Client Token, Activity for CustomTabs
- [lib/services/auth/social_sign_in.dart](lib/services/auth/social_sign_in.dart): add `signInWithFacebook()` returning `idToken` (use `accessToken.tokenString` from `FacebookAuth.login()`)
- [lib/screens/auth/auth_screen.dart](lib/screens/auth/auth_screen.dart): add Facebook button below Apple (or above depending on platform conventions), tap handler calls `provider.authSocialLogin('facebook', fbToken)`
- Env vars: `FB_APP_ID`, `FB_CLIENT_TOKEN` in `--dart-define` (NOT `.env` — per CLAUDE.md)
- AppLocalizations key: `auth_continue_with_facebook`

### Acceptance Criteria
- [ ] Facebook button visible in AuthScreen on iOS + Android
- [ ] Tap opens Facebook login (native app if installed, otherwise web)
- [ ] Successful login returns user to HomeScreen
- [ ] Failed login shows same error snackbar pattern as Google/Apple
- [ ] User profile populated from Facebook (name, email, avatar)
- [ ] New users go through onboarding; existing users go straight to home

### Testing Plan
- Manual: test on iOS + Android with both FB app installed and not installed
- Edge: test with user that denies email permission (must fall back gracefully)

### Dependencies
- Facebook Developer account + App ID (Fatih must create)

---

## TASK #3 — Implement Push Notifications End-to-End (FCM + APNs)

**Type:** Feature · **Priority:** High · **Size:** XL · **Epic:** Notifications

### Summary (Jira EN)
`Implement push notifications: backend triggers FCM/APNs delivery for diet plan ready, blood test completed, streak at risk`

### Description
Currently only local reminders via `flutter_local_notifications`. No server-triggered push. Needed for: diet plan generation completion, blood test analysis completion, streak-at-risk alerts (end of day if no scan), weekly progress summaries.

### Backend Changes
- New module `src/notifications/`:
  - `DeviceToken` entity (id, user_id, platform enum `ios|android`, token, app_version, created_at, last_seen_at; UNIQUE(user_id, token))
  - `NotificationLog` entity (id, user_id, type, payload, sent_at, delivered, error_code)
  - `notifications.resolver.ts`:
    - Mutation `registerDeviceToken(platform, token, appVersion)` — JWT, upsert
    - Mutation `unregisterDeviceToken(token)` — JWT
    - Query `notificationPreferences()` — read from `user_settings`
  - `notifications.service.ts`:
    - Adapter pattern: `FCMAdapter`, `APNsAdapter`
    - `sendNotification(userId, type, payload)` — dispatches to all device tokens
    - Retry with exponential backoff on transient failures
    - Auto-purge tokens after 3 consecutive INVALID_TOKEN errors
- Event bus hooks:
  - `DietPlanService.generateDietPlan` → emit `DIET_PLAN_READY`
  - `BloodTestAnalysisService` completion → emit `BLOOD_TEST_READY`
  - Daily cron (via `@Cron` decorator): 20:00 user local time → emit `STREAK_AT_RISK` if no scan today
- Env: `FCM_SERVICE_ACCOUNT_JSON`, `APNS_KEY_ID`, `APNS_TEAM_ID`, `APNS_BUNDLE_ID`, `APNS_P8_KEY`
- Migration: `create_device_tokens`, `create_notification_logs`

### Mobile Changes
- Dependencies: `firebase_core: ^3.6.0`, `firebase_messaging: ^15.1.0`
- iOS: APNs entitlement, background modes (remote-notification), request permission on first launch after onboarding
- Android: POST_NOTIFICATIONS permission (Android 13+)
- [lib/services/notification_service.dart](lib/services/notification_service.dart) extend:
  - `initPushNotifications()`: request permission, get FCM token, call `registerDeviceToken` mutation
  - Token refresh listener: re-register on token change
  - Foreground handler: show in-app banner (not system notification)
  - Background/terminated handler: navigate to relevant screen on tap (deep link)
- Deep link routes:
  - `DIET_PLAN_READY` → `/program` → WeeklyDietPlanScreen
  - `BLOOD_TEST_READY` → `/blood-tests/:id` → BloodTestDetailScreen (new) or list
  - `STREAK_AT_RISK` → `/home` focused on camera FAB

### Acceptance Criteria
- [ ] Device token registered within 5s of first app launch post-onboarding
- [ ] Token refresh on app version update
- [ ] Push arrives on real iOS device within 10s of backend emit
- [ ] Push arrives on real Android device within 10s
- [ ] Tap on notification opens correct screen (deep link)
- [ ] Foreground state shows in-app banner, background state shows system notification
- [ ] User can disable push in Settings (calls `unregisterDeviceToken`)
- [ ] Failed sends retry 3x with exponential backoff, then purge token

### Testing Plan
- Backend: unit tests for each adapter, integration test with staging FCM + APNs sandbox
- Mobile: test on real iOS + Android devices (simulators/emulators don't reliably receive push)
- E2E: trigger `generateDietPlan` → verify FCM delivery

### Dependencies
- Firebase project created by Fatih
- APNs p8 key from Apple Developer Portal

---

## TASK #4 — Add Offline Mutation Queue for Write Operations

**Type:** Feature · **Priority:** Medium · **Size:** L · **Mobile only**

### Summary (Jira EN)
`Implement offline queue for mobile write operations to prevent data loss during network outages`

### Description
Currently `analyzeFood`, `logWater`, `logWeight`, `saveFoodAnalysis`, `toggleFavoriteMeal`, `logout` fail silently on network loss. Users lose meals, water entries, weight logs. Add persistent queue that replays on reconnection.

### Mobile Changes
- Add `drift: ^2.20.0` or `isar: ^3.1.0` dependency
- New file [lib/services/offline/mutation_queue.dart](lib/services/offline/mutation_queue.dart):
  - Model: `QueuedMutation { id, operationName, variables(json), created_at, retry_count, last_error }`
  - Methods: `enqueue`, `dequeue`, `replay`, `purgeOlderThan`
- Integration with [lib/services/api/api_client.dart](lib/services/api/api_client.dart):
  - On `NETWORK_ERROR`, if operation is in whitelist (writes only), enqueue instead of throwing
  - `connectivity_plus` listener triggers replay on connection restored
  - FIFO with exponential backoff on retry failure (max 5 retries)
- Idempotency:
  - `logWater`, `logWeight` already idempotent (date-based upsert)
  - For `analyzeFood`: generate client UUID, backend uses `ON CONFLICT DO NOTHING` keyed on UUID → **requires minor backend change** (add `client_request_id` nullable column, idempotency middleware) — track as sub-ticket
  - `saveFoodAnalysis`, `toggleFavoriteMeal`: same UUID pattern
- UI: small offline indicator in HomeScreen app bar when queue > 0
- Conflict resolution: last-write-wins (user's intent); show toast on replay failure

### Acceptance Criteria
- [ ] Airplane mode + `logWater(500)` → success UI feedback, data visible on next `waterLogs` fetch after reconnect
- [ ] Airplane mode + `analyzeFood` → enqueued with pending state, auto-retries on reconnect
- [ ] Queue survives app kill/restart
- [ ] Max 100 queued mutations; oldest dropped
- [ ] Mutations older than 7 days auto-purged
- [ ] UI indicator shows count of pending mutations

### Testing Plan
- Manual: toggle airplane mode mid-mutation, observe queue + replay
- Integration test with mock connectivity stream
- Stress: queue 50 mutations offline, then connect

### Dependencies
- Minor backend: add `client_request_id` columns + idempotency (could be own sub-ticket)

---

## TASK #5 — Sync Apple Health Data (Steps + Active Calories) to Backend

**Type:** Feature · **Priority:** Medium · **Size:** L · **BE + Mobile**

### Summary (Jira EN)
`Sync Apple HealthKit steps and active calories to backend for unified progress stats`

### Description
`HealthService` reads HealthKit on iOS but data stays on device. Backend's `todayStats` only counts food/water/scanCount. To show "calories burned" and "steps goal" in Progress screen, sync HealthKit data daily.

### Backend Changes
- New endpoints in `progress.resolver.ts` or new `health` module:
  - Mutation `syncHealthData(input: SyncHealthDataInput)` — JWT, `@Throttle(60/min)`
    - Input: `[{ date, steps, activeCalories, source }]` (bulk upsert)
    - UNIQUE(user_id, date, source)
  - Query `healthLogs(days: Int=7)` — JWT
- New table `health_logs` (user_id, date, steps, active_calories, source enum `apple_health|google_fit|manual`)
- Extend `todayStats`/`weeklyStats` response: `caloriesBurned`, `stepCount`, `stepGoal` (user profile)
- Add to `UpdateProfileInput`: `dailyStepGoal: Int`
- Migration: `create_health_logs`, `add_daily_step_goal_to_users`

### Mobile Changes
- Android: add `health_connect` support (package `health: ^12.2.0` already supports it)
- [lib/services/health_service.dart](lib/services/health_service.dart):
  - Background observer (iOS: `HKObserverQuery`, Android: `HealthConnect` sync)
  - Batch sync every app foreground OR on `lifecycle onResume`
  - Debounce: max 1 sync per 30min per data type
- New service: `HealthSyncService` wrapper calling `syncHealthData`
- [lib/screens/progress_screen.dart](lib/screens/progress_screen.dart): add "Steps" and "Calories burned" cards in Today tab
- [lib/screens/settings_screen.dart](lib/screens/settings_screen.dart): daily step goal field (default 10000)

### Acceptance Criteria
- [ ] After granting HealthKit permission, steps + active calories sync to backend within 30s
- [ ] Progress screen Today tab shows steps (XXX / goal) + calories burned
- [ ] Daily step goal editable in Settings
- [ ] Works on iOS (HealthKit) and Android (Health Connect)
- [ ] Sync is idempotent (repeated calls don't double-count)

### Testing Plan
- iOS: simulate health data in Health app, observe sync
- Android: Health Connect app must be installed for testing
- Backend: bulk insert 30 days of data, query weekly stats

### Dependencies
- Android Health Connect app (user-installed)

---

## TASK #6 — Wire timezoneOffsetMinutes Parameter in Mobile Stats Queries

**Type:** Task · **Priority:** High · **Size:** XS · **Mobile only · Quick win**

### Summary (Jira EN)
`Pass device timezone offset to todayStats/weeklyStats/monthlyStats/remainingScans so user sees correct local day`

### Description
Backend commit `e6ce8c0` (EAT-131) added optional `timezoneOffsetMinutes` param to all progress queries. Mobile is not passing it yet, causing TR users (UTC+3) to see wrong day around midnight (00:00-03:00 shows yesterday's data).

### Mobile Changes
- [lib/services/api/progress_service.dart](lib/services/api/progress_service.dart): add `timezoneOffsetMinutes` to all 4 queries (todayStats, weeklyStats, monthlyStats, remainingScans)
- Compute: `DateTime.now().timeZoneOffset.inMinutes`
- Call site updates in [lib/services/app_provider.dart](lib/services/app_provider.dart)

### Acceptance Criteria
- [ ] All 4 progress queries pass `timezoneOffsetMinutes`
- [ ] At 00:30 local time, Progress screen shows "today" data (starting at 00:00 local), not UTC today
- [ ] DST transition handled correctly (user in Europe test)

### Testing Plan
- Manual: set device time to 00:30 TR time, log a meal, verify it appears in Today tab
- Unit test: mock DateTime.now() at various offsets

### Dependencies
- None

---

## TASK #7 — Add Disliked Foods Multi-Select Chip to Anamnesis Form

**Type:** Task · **Priority:** Medium · **Size:** S · **Mobile only**

### Summary (Jira EN)
`Add "foods I dislike" multi-select chip step to dietary anamnesis and pass dislikedFoodIds to generateDietPlan`

### Description
Backend commit `8736bfe` (EAT-132) added `dislikedFoodIds: [ID]` optional input to `generateDietPlan`. Anamnesis form doesn't expose this yet — users can't tell the planner what to avoid. Enrich the form with food picker.

### Mobile Changes
- [lib/screens/dietary_anamnesis_screen.dart](lib/screens/dietary_anamnesis_screen.dart): add step 6 (after budget) "Sevmediğin yiyecekler" with searchable multi-select
- Use `foods` query from `nutrition` module (search + filter)
- Selected ids stored in local state, passed to `generateDietPlan(input: {dislikedFoodIds})`
- [lib/services/api/diet_plan_service.dart](lib/services/api/diet_plan_service.dart): update `generateDietPlan` signature
- [lib/screens/diet_profile_edit_screen.dart](lib/screens/diet_profile_edit_screen.dart): same chip visible here for edit
- AppLocalizations: `anamnesis_step_disliked_foods_title/subtitle/search_placeholder`

### Acceptance Criteria
- [ ] Step added between "budget" and "summary"
- [ ] Search input filters `foods` by name
- [ ] Selected foods persist across regenerations (stored in user profile `disliked_food_ids`)
- [ ] Generated diet plan never includes a disliked food
- [ ] Empty state: user can skip (nothing required)

### Testing Plan
- Manual: select 3 foods, generate plan, verify none appear
- Edge: search with Turkish characters (ı, ö, ş)

### Dependencies
- None

---

## TASK #8 — Handle WEEKLY_LIMIT_EXCEEDED Error in Diet Plan Loading Screen

**Type:** Task · **Priority:** High · **Size:** S · **Mobile only**

### Summary (Jira EN)
`Show proper UI when generateDietPlan returns WEEKLY_LIMIT_EXCEEDED (backend EAT-128)`

### Description
Backend commit `5ea0013` (EAT-128) introduced 3 plans per rolling 7 days limit. When exceeded, backend throws `WEEKLY_LIMIT_EXCEEDED` with `resetAt` timestamp. Mobile currently shows generic error — should inform user about limit and reset time.

### Mobile Changes
- [lib/screens/diet_plan_loading_screen.dart](lib/screens/diet_plan_loading_screen.dart): catch `ApiException.code == 'WEEKLY_LIMIT_EXCEEDED'`
- Show new screen/dialog with:
  - Title: "Weekly plan limit reached"
  - Message: "You can generate up to 3 plans per 7 days. Your next available slot opens on [resetAt formatted]."
  - Primary button: "Back to Program"
  - Secondary button: "See current plan" (if one exists)
- [lib/screens/program_screen.dart](lib/screens/program_screen.dart): show remaining count badge via `dietPlanWeeklyLimit` query
- AppLocalizations: `diet_plan_limit_reached_title/body`, `diet_plan_remaining_plural/single`

### Acceptance Criteria
- [ ] Attempting 4th generation in 7 days shows new dialog (not generic error)
- [ ] resetAt formatted in user's locale (short date)
- [ ] Program screen shows "2/3 plans remaining this week"
- [ ] Back button returns to Program screen without error state stuck

### Testing Plan
- Manual: generate 3 plans back-to-back, attempt 4th
- Unit test: parse various `resetAt` formats

### Dependencies
- None

---

## TASK #9 — Wire nutrition.recommendMeal in Weekly Diet Plan Screen

**Type:** Task · **Priority:** Low · **Size:** M · **Mobile only**

### Summary (Jira EN)
`Add "swap meal" action in Weekly Diet Plan that calls nutrition.recommendMeal to suggest an alternative`

### Description
Backend's `recommendMeal(mealCategory)` is fully implemented but never called from mobile. Use case: user doesn't like a suggested breakfast → tap "swap" → get alternative hitting similar macros.

### Mobile Changes
- [lib/screens/weekly_diet_plan_screen.dart](lib/screens/weekly_diet_plan_screen.dart): add "🔄 Swap" button per meal card
- Tap opens bottom sheet showing 3 alternatives (call `recommendMeal` 3 times or backend update to return 3)
- User selects one → updates local plan state (does NOT persist — this is just for the session unless we later add `replaceMeal` mutation)
- Alternative: call `regenerateDay` which already exists, but that regenerates entire day. Swap single meal is NEW capability.
- [lib/services/api/nutrition_service.dart](lib/services/api/nutrition_service.dart): add `recommendMeal(mealCategory)` method
- AppLocalizations: `diet_plan_swap_meal`, `diet_plan_swap_pick_alternative`

### Acceptance Criteria
- [ ] Swap icon on each meal card
- [ ] Tap shows 3 alternatives with calories + macros
- [ ] Selecting updates UI (even if not persisted)
- [ ] If backend's recommendMeal returns stale/repeat, mobile shows "No alternatives available"

### Testing Plan
- Manual: swap breakfast 5 times, verify variety

### Dependencies
- (Optional) Backend enhancement: `replaceMeal` mutation for persistence → separate ticket

---

## TASK #10 — Remove Unused food.generateMealPlan Endpoint

**Type:** Task · **Priority:** Low · **Size:** XS · **Backend only · Cleanup**

### Summary (Jira EN)
`Remove dead code: food.generateMealPlan mutation (superseded by diet-plan.generateDietPlan)`

### Description
`src/food/food.resolver.ts:114` still exposes `generateMealPlan(planType)` returning a JSON string. Mobile never calls it — `diet-plan.generateDietPlan` is used instead. Dead API surface.

### Backend Changes
- Remove `generateMealPlan` mutation from `food.resolver.ts`
- Remove `generateMealPlan()` method from `food.service.ts`
- Verify no internal callers
- If any existing client (analytics, admin) uses it, update it first

### Acceptance Criteria
- [ ] Mutation removed from GraphQL schema
- [ ] `npm run build` + `npm test` pass
- [ ] Schema diff reviewed (no breaking changes for mobile)

### Testing Plan
- Backend: run test suite
- Grep codebase for any remaining references

### Dependencies
- None

---

## TASK #11 — Remove Duplicate social_login_screen.dart

**Type:** Task · **Priority:** Low · **Size:** XS · **Mobile only · Cleanup**

### Summary (Jira EN)
`Remove obsolete social_login_screen.dart duplicate (functionality moved to AuthScreen)`

### Description
[lib/screens/social_login_screen.dart](lib/screens/social_login_screen.dart) is a legacy duplicate of [lib/screens/auth/auth_screen.dart](lib/screens/auth/auth_screen.dart). No active references.

### Mobile Changes
- Grep for any remaining import of `social_login_screen.dart` in lib/ and delete if none
- Delete file
- Remove from `APP_FLOW_ANALYSIS.md` references

### Acceptance Criteria
- [ ] File deleted
- [ ] `flutter analyze` passes with no warnings
- [ ] App still compiles and auth flow works end-to-end

### Testing Plan
- Manual: cold start app → AuthScreen still works
- Run `flutter analyze`

### Dependencies
- None

---

## TASK #12 — Decide Fate of Legacy SQLite Cache

**Type:** Task · **Priority:** Low · **Size:** M · **Mobile only**

### Summary (Jira EN)
`Decide: remove legacy SQLite cache (database_service.dart) or repurpose for offline queue backing store`

### Description
[lib/services/database_service.dart](lib/services/database_service.dart) maintains `analyses`, `water_log`, `weight_log` SQLite tables. Backend is now source of truth; these tables are cache-only but have no active sync. Options:

**Option A: Remove** — delete database_service.dart, migrate away from sqflite. Pro: cleanup; Con: no offline read capability.

**Option B: Repurpose** — use same schema as offline backing store for Task #4 (Offline Queue) local cache. Pro: reuse; Con: ties queue to sqflite vs. Drift/Isar.

**Option C: Keep as read cache** — populate on fetch, read when offline, never write-back. Pro: offline UX; Con: complexity.

### Recommendation
Go with **Option A** unless Task #4 (Offline Queue) backing store decision prefers sqflite. Simplest path.

### Mobile Changes (Option A)
- Remove [lib/services/database_service.dart](lib/services/database_service.dart)
- Remove `sqflite` and `path` from `pubspec.yaml` if no other usage
- Remove all `DatabaseService.` references from `app_provider.dart`

### Acceptance Criteria
- [ ] App compiles without sqflite
- [ ] `flutter analyze` clean
- [ ] No missing data in History, Progress, Weight screens (all read from backend)

### Testing Plan
- Manual: fresh install → onboard → verify all data flows work

### Dependencies
- Should come AFTER Task #4 if Option B selected

---

## TASK #13 — Wire Dietary Tags Filter Chips in Food Search Screen

**Type:** Task · **Priority:** Low · **Size:** S · **Mobile only**

### Summary (Jira EN)
`Surface foods.tags (vegan, gluten_free, etc.) as filter chips in Food Search`

### Description
Backend commits `ccd4a8f` / `9bce0ec` introduced dietary tagging on `foods` table (`tags: String[]`). Mobile Food Search only filters by category. Expose tags as additional filter chips.

### Mobile Changes
- [lib/screens/food_search_screen.dart](lib/screens/food_search_screen.dart):
  - Fetch distinct tags (client-side dedupe from first 100 results, or add new BE query `foodTags`)
  - Render as horizontal chip row under category
  - Multi-select AND filter (all selected tags must match)
- [lib/services/api/nutrition_service.dart](lib/services/api/nutrition_service.dart): extend `foods` query with `tags: [String]` in filter input (backend supports this — verify with `FoodsFilterInput`)
- AppLocalizations: tag display names (vegan, vegetarian, gluten_free, dairy_free, nut_free, pescatarian, halal, kosher, low_carb, keto...)

### Acceptance Criteria
- [ ] Tag chips render when results have tags
- [ ] Selecting "vegan" filters to vegan foods only
- [ ] Multi-select: "vegan" + "gluten_free" intersects
- [ ] Localized chip labels for 10 locales

### Testing Plan
- Manual: search "cheese" → no vegan results; select "vegan" and search "milk" → plant-based options

### Dependencies
- Verify `FoodsFilterInput.tags` in backend schema (grep)

---

## Execution Plan

### This Sprint (quick wins — mobile only)
1. Task #6 (timezone) — 30 min
2. Task #8 (weekly limit) — 1-2 h
3. Task #7 (disliked foods) — 3-4 h
4. Task #11 (duplicate cleanup) — 15 min
5. Task #13 (dietary tags) — 2-3 h

### Next Sprint
- Task #2 (Facebook) — 1 day
- Task #9 (recommendMeal) — 0.5 day
- Task #12 (SQLite decision) — 0.5 day
- Task #10 (backend cleanup — Kürşat)

### Following Sprints
- Task #4 (offline queue) — 3-5 days
- Task #5 (Apple Health sync) — 3 days
- Task #3 (Push notifications) — 5-7 days
- Task #1 (AI Dietitian — biggest epic) — 7-10 days

### Task Open Order
All 13 tasks open in one batch in EAT (Jira), assigned to Kürşat Burak. Labels: `roadmap-2026-q2`, `integration`, `mobile` or `backend` or `both`. Priority set per matrix above.

### After Tasks Opened
- Fatih + Kürşat review ticket order
- Claude (me) starts Task #6, #8, #11 immediately (I can do mobile changes)
- Kürşat handles Task #10 backend cleanup + Task #1/#3/#5 backend portions
- Both coordinate on backend-dependent mobile work (Tasks #1, #3, #5 mobile parts)
