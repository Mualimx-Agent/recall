# Data Safety Form – Recall v1.0.0

> Antworten für Google Play Console Data Safety Questionnaire.
> Datum: 2026-07-23

## Section 1: Data collection and security

**Q: Does your app collect or share any of the required user data types?**
A: **No**

**Q: Is all of the user data collected by your app encrypted in transit?**
A: N/A — no data collected

**Q: Do you provide a way for users to request that their data is deleted?**
A: N/A — no data collected

## Section 2: Specific data types (all 14 categories)

Recall does **NOT** collect, store, or share any of the following data types:

1. ❌ **Location** (approximate or precise)
2. ❌ **Personal info** (name, email, phone, address)
3. ❌ **Financial info** (payment, credit card, bank account)
4. ❌ **Health and fitness**
5. ❌ **Messages** (SMS, MMS, email, other)
6. ❌ **Photos and videos**
7. ❌ **Audio files**
8. ❌ **Files and docs**
9. ❌ **Calendar**
10. ❌ **Contacts**
11. ❌ **App activity** (no analytics, no interaction logs)
12. ❌ **Web browsing**
13. ❌ **App info and performance** (no crash logs, no diagnostics)
14. ❌ **Device or other IDs** (no device identifier, no advertising ID)

## What Recall DOES store (locally only)

| Data | Where | Why |
|---|---|---|
| Flashcards and decks | User's device (in-memory/Hive in v2.0) | Core feature: study |
| Study session statistics | User's device (in-memory/Hive in v2.0) | Core feature: stats |
| User settings (theme, language, daily goal) | User's device (SharedPreferences) | App customization |
| Streak data | User's device (SharedPreferences) | Core feature: motivation |

**All of this stays on the user's device. None of it is transmitted to any server.**

## Verification

- ✅ No backend server
- ✅ No third-party SDKs (Firebase, Google Analytics, Crashlytics, etc.)
- ✅ No internet permission required
- ✅ No permissions required at all
- ✅ Open source code (Apache 2.0)
- ✅ Privacy policy states this explicitly

## Privacy policy URL

To be hosted at: `https://mualimx.com/privacy/recall.html`

## Notes for Google reviewer

If asked: "Recall is a fully offline flashcard study app. The data that is stored on the
device is the user's own flashcards, decks, study statistics, and personal settings.
We do not collect, transmit, or share any user data. The app does not require any internet
connection, location, contacts, or other sensitive permissions. The app requires zero
permissions. The app's code is open source (Apache 2.0) and can be verified."

## Offline app stance (summary)

Recall is built on a strict offline-first principle:
- **No** data is collected from the user's device.
- **No** data leaves the user's device.
- **No** data is shared with third parties.
- **No** tracking, analytics, or advertising.
- **No** permissions required.
- All app functionality works without internet connection.
