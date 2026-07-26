# Play Console Step-by-Step: Recall v1.0.0 einreichen

> Anleitung: Du folgst diesen Schritten in der Google Play Console.
> Geschätzter Aufwand: 30-45 Minuten für die Ersteinreichung.
> Datum: 2026-07-23

---

## Voraussetzungen

- [x] Google Play Developer Account (25 € einmalig, bereits vorhanden)
- [x] Developer-Profil vollständig (Mualimx Apps)
- [x] Identitätsverifikation abgeschlossen
- [ ] AAB-File (App-Bundle) — **baust du später auf x86_64-Server**
- [x] Store-Listing-Texte (DE+EN+AR in `listing_v1.0.md`)
- [ ] App-Icon 512x512 — **noch erstellen**
- [ ] Feature Graphic 1024x500 — **noch erstellen**
- [ ] 8 Phone-Screenshots 1080x1920 — **noch erstellen**
- [x] Data Safety Form (in `data_safety_v1.0.md`)
- [ ] Privacy Policy — **noch erstellen**
- [x] Metadata (`metadata_v1.0.json`)

---

## Schritt 1: App erstellen

1. Öffne https://play.google.com/console
2. Klicke **"App erstellen"** (oder "Create app")
3. App-Name: `Recall`
4. Standardsprache: `Deutsch (Deutschland)`
5. App oder Spiel: **App**
6. Kostenlos oder kostenpflichtig: **Kostenlos**
7. Klicke **"App erstellen"**

## Schritt 2: Dashboard-Aufgaben

Play Console zeigt dir eine Checkliste. Gehe sie der Reihe nach durch:

### ✅ App-Details (Store-Eintrag)

1. **"Hauptseite des Store-Eintrags"** (oder "Main store listing")
2. **App-Name (DE):** `Recall: Karteikarten & Lernen` — **29 Zeichen** ✅
3. **Kurzbeschreibung (DE):** `SM-2 Karteikarten. Klug lernen, 100% offline. Kein Anki-Konto nötig.` — **70 Zeichen** ✅
4. **Vollständige Beschreibung (DE):** Komplett aus `listing_v1.0.md` kopieren
5. **App-Icon:** Hochladen (sobald erstellt)
6. **Feature Graphic:** Hochladen (sobald erstellt)
7. **Screenshots:** 8 Phone-Screenshots (1080x1920) hochladen (sobald erstellt)
8. Wiederhole für **EN** und **AR** (über "Übersetzungen verwalten"):
   - EN Titel: `Recall: Flashcards & Study` (26 Zeichen ✅)
   - EN Kurzbeschreibung: `SM-2 flashcards. Study smart, 100% offline. No Anki account needed.` (71 Zeichen ✅)
   - AR Titel: `Recall: بطاقات الذاكرة والدراسة` (28 Zeichen ✅)
   - AR Kurzbeschreibung: `بطاقات تعلم SM-2. دراسة ذكية، 100٪ غير متصل. لا حساب مطلوب.` (59 Zeichen ✅)
9. Klicke **"Speichern"**

### ✅ App-Inhalt

1. **"Datenschutz"** → URL: `https://mualimx.com/privacy/recall.html`
2. **"Datensicherheit"** → **Keine Daten gesammelt** — alle 14 Kategorien auf "No"
3. **"Anzeigen"** → **Nein**
4. **"Inhaltsklassifizierung"** (IARC) → Alle 5 Fragen **Nein** → PEGI 3
5. **"Zielgruppe"** → **Alle Altersgruppen**

### ✅ In-App-Käufe (Premium Lifetime)

1. **"Monetarisierung"** → **"Produkte"** → **"In-App-Produkt erstellen"**
2. Produkt-ID: `premium_lifetime`
3. Name (DE): `Recall Premium`
4. Beschreibung (DE): `Einmaliger Kauf. Lebenslange Updates. Alle Premium-Features freischalten.`
5. Preis: **4,99 EUR**
6. Typ: **Non-consumable** (nicht konsumierbar) — kein Abo!
7. Status: **Aktiv**
8. Speichern

### ✅ Berechtigungen

- Recall benötigt **KEINE** Berechtigungen
- Kein INTERNET, kein STORAGE, keine Kamera, keine Kontakte
- Beim Play Console Releasemanagement bestätigen: "0 permissions"

## Schritt 3: App-Version hochladen

1. **"Release"** → **"Produktion"** oder **"Interner Test"**
2. **"Neue Version erstellen"**
3. `.aab` File hochladen
4. **Versionsname:** `1.0.0`
5. **Versionscode:** `1`
6. **Versionshinweise (DE):** "Erster Release von Recall: SM-2 Algorithmus, 4 Demo-Decks, eigene Decks, Statistiken"
7. **"Überprüfen"** → **"Rollout starten"**

## Schritt 4: Warten & Nachbereitung

- Google Review: **3-7 Tage**
- Reviews beantworten
- Statistiken überwachen
- Marketing-Posts

---

## ⚠️ Häufige Probleme & Lösungen

| Problem | Lösung |
|---|---|
| "Keine Screenshots" | Mindestens 2 hochladen, besser 8 |
| "Privacy Policy fehlt" | Aus `privacy_policy.html` erstellen und hosten |
| "IAP falsch eingestellt" | Non-consumable prüfen, nicht Subscription |

## 📋 Charakter-Limits (Quick Reference)

| Feld | Limit | Unser Wert | Status |
|---|---|---|---|
| Titel DE | 30 | 29 | ✅ |
| Titel EN | 30 | 26 | ✅ |
| Titel AR | 30 | 28 | ✅ |
| Kurzbeschreibung DE | 80 | 70 | ✅ |
| Kurzbeschreibung EN | 80 | 71 | ✅ |
| Kurzbeschreibung AR | 80 | 59 | ✅ |
| Vollständige Beschreibung | 4000 | ~1700 chars | ✅ |

## 📞 Support

Falls du nicht weiterkommst: schreib mir, ich helfe sofort.

---

**Geschätzter Aufwand:** 30-45 Minuten
