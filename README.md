# Recall – Karteikarten mit SM-2 Algorithmus

**Version 1.0.0** · `com.mualimx.recall_app` · Open Source (Apache 2.0)

Recall ist ein moderner Karteikarten-Lernbegleiter für Android, iOS und Web.
„Anki für normale Menschen" – mit dem bewährten SM-2 Spaced-Repetition-Algorithmus
und einer Oberfläche, die sich 2026 anfühlt.

## ✨ Features

- **SM-2 Algorithmus** – derselbe Algorithmus wie Anki, wissenschaftlich validiert
- **4 Demo-Decks** inklusive (Englisch, Programmierung, Geschichte, Naturwissenschaft)
- **Eigene Decks** mit Icon- und Farb-Auswahl erstellen
- **Card-Flip-Animation** mit Tipp-zum-Aufdecken
- **4-Button-Bewertung** (Again / Hard / Good / Easy) mit Intervall-Vorschau
- **Streak-Tracking** – motivierend, ohne Schuld-Druck
- **Statistiken** – tägliche Reviews, Genauigkeit, gelernte Karten
- **Tagesziel-Slider** – flexibel anpassbar
- **Dunkelmodus** – schont die Augen
- **DE / EN** – komplett lokalisiert
- **100% lokal** – keine Cloud, keine Tracker, keine Accounts
- **Open Source** (Apache 2.0) – Vertrauen durch Transparenz
- **Faire Preise** – einmaliger Kauf, keine Abo-Falle

## 🛡️ Datenschutz (Zero-Data)

| | |
|---|---|
| Internet-Zugriff | ❌ Nicht erforderlich |
| Cloud-Sync | ❌ Keine |
| Account-System | ❌ Keines |
| Analytics | ❌ Keine |
| Werbung | ❌ Keine |
| Drittanbieter-SDKs | ❌ Keine |
| Crash-Reports | ❌ Keine |
| Speicher-Zugriff | ❌ Nicht erforderlich |
| Berechtigungen | ❌ Keine |

**Alle Daten bleiben auf deinem Gerät.** Deinstallation = Daten weg.

## 🏗️ Architektur

- **Flutter** (Android, iOS, Web)
- **Provider** (State Management)
- **GoRouter** (Navigation)
- **Google Fonts** (Inter)
- **In-Memory State** (Demo-Modus; Hive/SQLite-Persistenz in v2.0)

### Verzeichnisstruktur

```
lib/
├── main.dart
├── theme/app_theme.dart
├── models/         (FlashCard, Deck, StudySession, UserStats)
├── data/demo_data.dart
├── services/sm2_algorithm.dart
├── providers/deck_provider.dart
├── router/app_router.dart
└── screens/        (9 Screens)
    ├── onboarding_screen.dart
    ├── home_screen.dart
    ├── deck_detail_screen.dart
    ├── study_screen.dart
    ├── add_card_screen.dart
    ├── add_deck_screen.dart
    ├── stats_screen.dart
    ├── settings_screen.dart
    └── about_screen.dart
```

## 🚀 Entwicklung

```bash
cd app/recall_app
flutter pub get
flutter run                       # Connected Device
flutter build web --release       # Web-Build
flutter build apk --release       # Android APK
```

## 📦 Live testen

- **Web:** http://127.0.0.1:8093/

## 🎯 Roadmap

### v1.0.0 (jetzt)
- SM-2 Algorithmus, Demo-Decks, lokale Speicherung
- 9 Screens, Onboarding, Stats, Settings, About
- Web, Android, iOS

### v1.1.0 (Q3 2026)
- Hive-Persistenz (Daten überleben App-Restart)
- CSV-Import / -Export
- Markdown in Karten (Code-Blöcke, Formeln)

### v2.0.0 (Q4 2026)
- Optionale Cloud-Sync (Ende-zu-Ende-verschlüsselt)
- Kollaborative Decks (Lehrer erstellen, Schüler nutzen)
- FSRS-Algorithmus (Anki-Nachfolger, noch genauer)
- LaTeX-Formeln
- Bilder in Karten
- Audio-Aufnahme

## 📄 Lizenz

Apache License 2.0 – siehe [LICENSE](LICENSE).

## ✉️ Kontakt

- E-Mail: apps@mualimx.com
- Web: mualimx.com
