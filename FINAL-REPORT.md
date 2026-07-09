# Recall v1.0.0 – FINAL REPORT

**Status:** ✅ Komplett fertig · **Datum:** 2026-07-09

## Übersicht

Recall ist ein moderner Karteikarten-Lernbegleiter. SM-2 Algorithmus
(wie Anki), aber mit einer 2026er Oberfläche. Komplett offline,
100% lokal, Open Source.

## Was gebaut wurde

| Komponente | Details |
|---|---|
| Flutter App | 99 Files in Git, 9 Screens, 4 Models, 1 Service, 1 Provider |
| Web-Build | 41 MB, läuft auf http://127.0.0.1:8093/ |
| App-Icon | 5 Densities (48-192 px) + 512x512 Master |
| Feature Graphic | 1024x500 (Indigo/Purple Gradient) |
| Android Manifest | Halal-konform: allowBackup=false, keine Berechtigungen |
| Privacy Policy | DSGVO-HTML, "Zero-Data"-Prinzip |
| Compliance Sign-off | Interne Halal-Prüfung bestanden |
| Doku | README, CHANGELOG, LICENSE |
| Git | 99 Files, 1 Commit, Branch main |
| Backup | `~/recall-v1.0.0-FINAL.tar.gz` (32 MB) |

## Live testen

**Web:** http://127.0.0.1:8093/
- 4 Demo-Decks sofort spielbar
- "Study"-Flow mit Card-Flip + 4-Button-Bewertung
- "Add Deck" + "Add Card" Forms funktionieren
- Stats + Streak-Tracking

## Features (live)

**Kern:**
- SM-2 Algorithmus mit Ease-Factor + Repetitions + Intervall-Berechnung
- 4-Button-Bewertung: Again/Hard/Good/Easy mit Live-Intervall-Vorschau
- Card-Flip mit Hint-Anzeige

**Decks:**
- 4 vorinstallierte Decks (Englisch, Programmierung, Geschichte, Naturwissenschaft)
- 30 Karten sofort lernbar
- Eigene Decks mit Emoji + Farbe erstellen
- Eigene Karten mit Front/Back/Hint

**UX:**
- 3-Seiten-Onboarding
- Streak-Tracking
- Statistiken mit Wochen-Balken + Session-History
- Settings (Dark Mode, Tagesziel 5-100, DE/EN, Haptik)
- About mit Privacy-Info

## Architektur

```
lib/
├── main.dart                 (Provider + Theme)
├── theme/app_theme.dart      (Indigo Material 3)
├── models/
│   ├── flash_card.dart       (SM-2 State)
│   ├── deck.dart             (Aggregated Stats)
│   └── study_session.dart    (Session + UserStats)
├── data/demo_data.dart       (4 Decks, 30 Karten)
├── services/
│   └── sm2_algorithm.dart    (Pure SM-2)
├── providers/
│   └── deck_provider.dart    (In-Memory State)
├── router/app_router.dart    (9 Routes)
└── screens/                  (9 Screens)
```

## Halal-Compliance (intern)

- ✅ Zero-Data (kein Account, keine Cloud, keine Tracker)
- ✅ Keine Musik, keine haram-Inhalte
- ✅ Faire Preise (Einmalkauf, keine Abo-Falle)
- ✅ Keine Drittanbieter-SDKs
- ✅ Keine Berechtigungen
- ✅ Open Source (prüfbar)

Siehe `docs/COMPLIANCE-SIGNOFF.md` für volles Audit.

## Roadmap

### v1.1.0 (Q3 2026)
- Hive-Persistenz (Daten überleben App-Restart)
- CSV-Import/Export
- Markdown in Karten

### v2.0.0 (Q4 2026)
- Optionale E2E-verschlüsselte Cloud-Sync
- Kollaborative Decks (Lehrer → Schüler)
- FSRS-Algorithmus (Anki-Nachfolger)
- Bilder, Audio, LaTeX

## Bekannte Limitierungen

- **In-Memory State:** Daten gehen beim App-Restart verloren (geplant v1.1.0)
- **Kein AAB-Build:** ARM-Linux-Limit (Workaround: Web-Build, x86_64-Server für AAB)
- **Demo-Daten statisch:** Nicht editierbar in v1.0.0

## Cross-Promo

Recall kann in StillMind/FocusFlow/Tidy beworben werden:
„Probiere Recall für effizienteres Lernen!"
und umgekehrt: „Mache eine Lern-Session in Recall, dann meditiere 3 Min in StillMind".

## Multi-App-Strategie-Update

| App | Domain | Status |
|---|---|---|
| FocusFlow | Produktivität | ✅ v1.0.0 |
| StillMind | Wellness | ✅ v1.0.0 |
| Tidy | Utilities | ✅ v1.0.0 |
| Recall | Bildung | ✅ **v1.0.0 (jetzt fertig)** |

**Dach-Marke:** Mualimx Apps
**Sub-Brands:** FocusFlow, StillMind, Tidy, Recall

## Nächste Schritte

1. Hive-Persistenz (v1.1.0) — ca. 2-3 Wochen
2. Play-Store-Listing vorbereiten (analog FocusFlow)
3. CSV-Import für Decks
4. Marketing-Website für Recall (analog focusflow-mualimx.com)
