# Mobile Storage Matrix

**EAT-124 2e** — Audit of every local-storage write in `mobile/lib/`.
Last reviewed: 2026-04-24.

## Methodology

- `grep -rnE "prefs\.(get|set)" lib/` + `grep -r "secure_storage"` across `lib/`.
- Every key classified by worst-case tamper / exfiltration impact.
- "Sensitive" = attacker gains real privilege or user privacy is breached.

## SharedPreferences (plaintext XML on Android, plist on iOS)

| Key | Type | Purpose | Sensitivity | Tamper impact | Storage now | Required storage |
|-----|------|---------|-------------|----------------|-------------|-------------------|
| `isDark` | bool | UI theme | None | None — cosmetic | SharedPrefs | **OK** |
| `locale` | String | UI language | None | None — cosmetic | SharedPrefs | **OK** |
| `unitSystem` | String (`metric`\|`imperial`) | UI unit preference | None | None — cosmetic | SharedPrefs | **OK** |
| `calorieGoal` | double | User daily calorie target | Low | Cosmetic (BE still enforces real limits via `remainingScans`) | SharedPrefs | **OK** (UI cache of BE profile) |
| `waterGoal` | double | User daily water target | Low | Cosmetic | SharedPrefs | **OK** (UI cache of BE profile) |
| `streak` | int | Consecutive-day scan streak (gamification badge) | Low | User can fake streak for vanity; no paid feature unlocks from streak | SharedPrefs | **OK — document that BE is the intended long-term owner** (see Follow-ups) |
| `streakLastDate` | String (`YYYY-MM-DD`) | Streak bookkeeping | Low | Same as above | SharedPrefs | **OK** (same caveat) |
| `onboardingDone` | bool | Has user finished onboarding | Medium | Resetting forces re-onboarding; does NOT bypass terms/privacy (those are on backend) | SharedPrefs | **OK** |
| `notifEnabled` | bool | Master reminders toggle | None | User preference only | SharedPrefs | **OK** |
| `notifBreakfastEnabled` / `notifLunchEnabled` / `notifDinnerEnabled` / `notifSummaryEnabled` | bool | Per-meal reminder toggle | None | User preference only | SharedPrefs | **OK** |
| `notifBreakfastHour` / `notifBreakfastMin` / `notifLunchHour` / `notifLunchMin` / `notifDinnerHour` / `notifDinnerMin` | int | Reminder times | None | User preference only | SharedPrefs | **OK** |
| `health_enabled` | bool | HealthKit integration toggle | None | User preference only | SharedPrefs | **OK** |

No SharedPreferences key stores authentication, payment, PII beyond what the user has already told the app about themselves, or server-authoritative state that needs to be trusted.

## flutter_secure_storage (Keychain on iOS, encrypted SharedPrefs on Android)

| Key | Purpose | Storage | Notes |
|-----|---------|---------|-------|
| `eatiq_access_token` | JWT access token (~15 min TTL) | Secure | Correct |
| `eatiq_refresh_token` | JWT refresh token (~30 day TTL) | Secure | Correct |

Auth tokens are already in `flutter_secure_storage` — good.

## Server-authoritative state (NEVER cached locally beyond the current frame)

These are fetched on every screen that needs them; the client never persists them to disk:

- `isPremium` — resolved from `me { isPremium }` on app bootstrap and after every purchase flow. `remainingScans()` also hits the backend on every call (EAT-123).
- `remainingScans` — always a backend call; no local counter.
- `weight`, `height`, `age`, diet profile — lives in BE `users` row; mobile pulls via `me` and never writes back to disk.

## Findings

No sensitive value leaks via SharedPreferences today. The original audit flagged two concerns which have been reviewed:

1. **`streak` spoofing** — User can patch the prefs file to fake a high streak. Consequence: cosmetic badge only (no premium, no scan quota, no paywall bypass). Flagged as **acceptable** for now; full fix is a backend-side streak column and a `streak` field on `User` — tracked as a separate follow-up, not part of EAT-124.
2. **`onboardingDone` flag** — Ticket asked whether this gates privacy / terms acceptance. **It does not**: legal acceptance is tracked server-side (future work); `onboardingDone` is only a client-side "skip the first-run flow" marker. Resetting it forces onboarding but does not skip any legal gate.

## Follow-ups (out of scope for EAT-124, tracked elsewhere)

- **BE streak ownership** — Move `streak` + `streakLastDate` to the `users` table; mobile reads via `me { streak }`. Needed only if product treats streak as a real engagement metric.
- **Legal acceptance tracking** — Store ToS / privacy acceptance timestamps on the server and gate backend mutations on them. Independent of storage.

## Verification (run after any new SharedPrefs key is added)

```bash
# 1. Re-run this grep; add every new key to the table above.
grep -rnE "prefs\.(get|set|remove|contains)" lib/ | grep -v '//'

# 2. On a connected Android device with the app open:
adb shell run-as com.fatihaydogdu.eatiq cat /data/data/com.fatihaydogdu.eatiq/shared_prefs/*.xml
# → must not contain tokens, passwords, PII beyond what the user self-reported.
```
