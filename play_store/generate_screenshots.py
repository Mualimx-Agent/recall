#!/usr/bin/env python3
"""
Generiert 8 Play-Store-Screenshots (1080x1920 PNG) für Recall.
Indigo/Purple Farb-Schema, SM-2 Algorithmus, 4 Demo-Decks.

Farben:
  Primary:    #4F46E5 (Indigo)
  Purple:     #7C3AED
  Emerald:    #059669
  Surface:    #F5F3FF (sehr helles Indigo)
  Background: #FFFFFF
  Text:       #1E1B4B (dunkel-indigo)
"""

import os, sys, math
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont, ImageFilter

OUT_DIR = Path("/home/ubuntu/apps/recall/play_store/screenshots")
OUT_DIR.mkdir(parents=True, exist_ok=True)

# ── Farbpalette ──────────────────────────────────────────────────
INDIGO = "#4F46E5"
INDIGO_DARK = "#3730A3"
INDIGO_LIGHT = "#A5B4FC"
PURPLE = "#7C3AED"
PURPLE_LIGHT = "#C4B5FD"
EMERALD = "#059669"
EMERALD_LIGHT = "#6EE7B7"
SURFACE = "#F5F3FF"
WHITE = "#FFFFFF"
TEXT = "#1E1B4B"
TEXT_SUB = "#6B7280"
RED = "#DC2626"
RED_LIGHT = "#FCA5A5"
GOLD = "#F59E0B"
GOLD_LIGHT = "#FDE68A"
ORANGE = "#EA580C"
PINK = "#DB2777"
CYAN = "#0891B2"
LIME = "#65A30D"

W, H = 1080, 1920

# ── Fonts ────────────────────────────────────────────────────────
def find_font(size, bold=False):
    candidates = [
        "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf" if bold else "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
        "/usr/share/fonts/truetype/liberation/LiberationSans-Bold.ttf" if bold else "/usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf",
        "/usr/share/fonts/TTF/DejaVuSans-Bold.ttf" if bold else "/usr/share/fonts/TTF/DejaVuSans.ttf",
    ]
    for p in candidates:
        if os.path.exists(p):
            return ImageFont.truetype(p, size)
    return ImageFont.load_default()

# ── Helper ───────────────────────────────────────────────────────
def hex_to_rgba(h, a=255):
    h = h.lstrip("#")
    return tuple(int(h[i:i+2], 16) for i in (0, 2, 4)) + (a,)

def rounded_rect(draw, xy, r, fill, outline=None, width=1):
    x1, y1, x2, y2 = xy
    draw.rounded_rectangle(xy, radius=r, fill=fill, outline=outline, width=width)

def draw_card(draw, x, y, w, h, title, subtitle, color, accent=True):
    """Draw a card-like rectangle."""
    rounded_rect(draw, (x, y, x+w, y+h), 16, hex_to_rgba(WHITE))
    # color accent bar on top
    rounded_rect(draw, (x, y, x+w, y+6), 3, hex_to_rgba(color))
    f_title = find_font(30, bold=True)
    f_sub = find_font(24, bold=False)
    draw.text((x+20, y+22), title, font=f_title, fill=hex_to_rgba(TEXT))
    draw.text((x+20, y+62), subtitle, font=f_sub, fill=hex_to_rgba(TEXT_SUB))

def draw_status_bar(draw, title="Recall"):
    """Mock status bar + app bar."""
    # Status bar
    draw.rectangle([0, 0, W, 60], fill=hex_to_rgba(INDIGO))
    f_small = find_font(22, bold=False)
    draw.text((40, 18), "9:41", font=find_font(20, bold=True), fill=hex_to_rgba(WHITE))
    draw.text((W-120, 18), "📶 🔋 94%", font=f_small, fill=hex_to_rgba(WHITE))
    # App bar
    draw.rectangle([0, 60, W, 140], fill=hex_to_rgba(INDIGO))
    f_title = find_font(36, bold=True)
    draw.text((40, 82), title, font=f_title, fill=hex_to_rgba(WHITE))
    # Search icon
    draw.text((W-100, 82), "🔍", font=find_font(36, bold=False), fill=hex_to_rgba(WHITE))

def draw_bottom_nav(draw, active_idx=0, labels=["Home", "Study", "Stats", "Settings"]):
    y = H - 100
    draw.rectangle([0, y, W, H], fill=hex_to_rgba(WHITE))
    draw.line([(0, y), (W, y)], fill=hex_to_rgba("#E5E7EB"), width=2)
    icons = ["🏠", "📖", "📊", "⚙️"]
    f = find_font(22, bold=False)
    f_active = find_font(22, bold=True)
    spacing = W // 4
    for i in range(4):
        cx = spacing * i + spacing // 2
        color = INDIGO if i == active_idx else TEXT_SUB
        draw.text((cx-14, y+12), icons[i], font=find_font(28, bold=False), fill=hex_to_rgba(color))
        draw.text((cx-40, y+48), labels[i], font=f_active if i == active_idx else f, fill=hex_to_rgba(color))

# ═══════════════════════════════════════════════════════════════════
#  SCREENSHOT 1: Home / Deck-Liste
# ═══════════════════════════════════════════════════════════════════
def make_01_home():
    img = Image.new("RGB", (W, H), hex_to_rgba(SURFACE)[:3])
    draw = ImageDraw.Draw(img)
    draw_status_bar(draw, "Recall")
    draw_bottom_nav(draw, 0)

    # Greeting
    f_greet = find_font(30, bold=False)
    draw.text((40, 170), "👋 Hallo, Lernender!", font=f_greet, fill=hex_to_rgba(TEXT_SUB))
    f_big = find_font(44, bold=True)
    draw.text((40, 215), "Deine Decks", font=f_big, fill=hex_to_rgba(TEXT))

    # Streak badge
    rounded_rect(draw, (W-220, 170, W-40, 220), 20, hex_to_rgba(GOLD_LIGHT))
    draw.text((W-200, 178), "🔥 7-Tage Streak", font=find_font(22, bold=True), fill=hex_to_rgba("#92400E"))

    # Progress summary
    rounded_rect(draw, (40, 270, W-40, 340), 16, hex_to_rgba(INDIGO))
    draw.text((70, 285), "📊 Fällig heute: 12 Karten", font=find_font(28, bold=True), fill=hex_to_rgba(WHITE))
    draw.text((70, 318), "Neu: 8 | Wiederholung: 4 | Gelernt: 156", font=find_font(22, bold=False), fill=hex_to_rgba("#C7D2FE"))

    # Decks
    decks = [
        ("🇬🇧 Englisch Grundlagen", "8 Karten fällig", INDIGO),
        ("💻 Programmierung Basics", "3 Karten fällig", EMERALD),
        ("🏛️ Geschichte", "1 Karte fällig", PURPLE),
        ("🔬 Wissenschaft", "0 Karten fällig", CYAN),
    ]
    y0 = 380
    for i, (name, desc, color) in enumerate(decks):
        yy = y0 + i * 130
        draw_card(draw, 40, yy, W-80, 115, name, desc, color)

    # FAB
    draw.ellipse([W-120, H-200, W-40, H-120], fill=hex_to_rgba(INDIGO))
    draw.text((W-92, H-172), "+", font=find_font(52, bold=True), fill=hex_to_rgba(WHITE))

    out = OUT_DIR / "01_home.png"
    img.save(out, "PNG", optimize=True)
    size = os.path.getsize(out)
    print(f"✅ {out.name}  ({size/1024:.0f} KB)")

# ═══════════════════════════════════════════════════════════════════
#  SCREENSHOT 2: Card-Flip
# ═══════════════════════════════════════════════════════════════════
def make_02_card_flip():
    img = Image.new("RGB", (W, H), hex_to_rgba("#EEF2FF")[:3])
    draw = ImageDraw.Draw(img)
    draw_status_bar(draw, "Englisch Grundlagen")
    draw_bottom_nav(draw, 1)

    # Deck info
    f_info = find_font(24, bold=False)
    draw.text((40, 170), "🇬🇧 Englisch Grundlagen · Karte 3/8", font=f_info, fill=hex_to_rgba(TEXT_SUB))

    # Card front (large, centered)
    cx, cy = W//2, 560
    card_w, card_h = 860, 520
    rounded_rect(draw, (cx-card_w//2, cy-card_h//2, cx+card_w//2, cy+card_h//2), 24, hex_to_rgba(WHITE))
    # Shadow effect
    rounded_rect(draw, (cx-card_w//2+4, cy-card_h//2+4, cx+card_w//2+4, cy+card_h//2+4), 24, hex_to_rgba("#000000", 20))
    # Re-draw card on top
    rounded_rect(draw, (cx-card_w//2, cy-card_h//2, cx+card_w//2, cy+card_h//2), 24, hex_to_rgba(WHITE))

    # Purple accent bar
    rounded_rect(draw, (cx-card_w//2, cy-card_h//2, cx+card_w//2, cy-card_h//2+8), 4, hex_to_rgba(PURPLE))

    # Front text
    draw.text((cx-200, cy-100), "Front", font=find_font(28, bold=False), fill=hex_to_rgba(TEXT_SUB))
    f_card = find_font(64, bold=True)
    draw.text((cx-200, cy-40), "Thank you", font=f_card, fill=hex_to_rgba(TEXT))

    # Hint
    rounded_rect(draw, (cx-200, cy+80, cx+200, cy+130), 12, hex_to_rgba("#EDE9FE"))
    draw.text((cx-180, cy+92), "💡 Tipp: Höflichkeitsform", font=find_font(24, bold=False), fill=hex_to_rgba(PURPLE))

    # Flip button (tap indicator)
    rounded_rect(draw, (cx-120, cy+170, cx+120, cy+225), 28, hex_to_rgba(INDIGO))
    draw.text((cx-80, cy+182), "👆 Tippen zum Umdrehen", font=find_font(24, bold=True), fill=hex_to_rgba(WHITE))

    # Progress dots
    for i in range(8):
        dx = cx - 140 + i * 40
        color = INDIGO if i < 3 else TEXT_SUB
        draw.ellipse([dx, cy+280, dx+24, cy+304], fill=hex_to_rgba(color))

    # Difficulty buttons (hidden until flip)
    f_label = find_font(26, bold=False)
    draw.text((cx-200, 1320), "Nach dem Umdrehen:", font=f_label, fill=hex_to_rgba(TEXT_SUB))
    buttons = [
        ("😵 Wieder", 0, RED),
        ("🤔 Schwer", 2, ORANGE),
        ("👍 Gut", 4, EMERALD),
        ("😎 Leicht", 6, INDIGO),
    ]
    for label, idx, color in buttons:
        bx = cx - 320 + idx * 160
        rounded_rect(draw, (bx, 1370, bx+140, 1430), 20, hex_to_rgba(color))
        draw.text((bx+10, 1385), label, font=find_font(24, bold=True), fill=hex_to_rgba(WHITE))

    out = OUT_DIR / "02_card_flip.png"
    img.save(out, "PNG", optimize=True)
    size = os.path.getsize(out)
    print(f"✅ {out.name}  ({size/1024:.0f} KB)")

# ═══════════════════════════════════════════════════════════════════
#  SCREENSHOT 3: Study-Session
# ═══════════════════════════════════════════════════════════════════
def make_03_study_session():
    img = Image.new("RGB", (W, H), hex_to_rgba("#F5F3FF")[:3])
    draw = ImageDraw.Draw(img)
    draw_status_bar(draw, "Lernsitzung")
    draw_bottom_nav(draw, 1)

    # Timer
    rounded_rect(draw, (40, 170, W-40, 260), 20, hex_to_rgba(INDIGO))
    f_timer = find_font(56, bold=True)
    draw.text((W//2-100, 185), "⏱️ 04:32", font=f_timer, fill=hex_to_rgba(WHITE))
    draw.text((W//2-120, 235), "Karte 5 von 12 · Session #3", font=find_font(24, bold=False), fill=hex_to_rgba("#C7D2FE"))

    # Progress bar
    bar_x, bar_y, bar_w, bar_h = 40, 290, W-80, 12
    rounded_rect(draw, (bar_x, bar_y, bar_x+bar_w, bar_y+bar_h), 6, hex_to_rgba("#E0E7FF"))
    pct = 5/12
    rounded_rect(draw, (bar_x, bar_y, int(bar_x+bar_w*pct), bar_y+bar_h), 6, hex_to_rgba(PURPLE))

    # SM-2 stats
    f_stats = find_font(24, bold=False)
    draw.text((40, 330), "SM-2 Algorithmus · Stabilität: 21d · Schwierigkeit: 2.4", font=f_stats, fill=hex_to_rgba(TEXT_SUB))

    # Current card
    cx, cy = W//2, 680
    card_w, card_h = 860, 500
    rounded_rect(draw, (cx-card_w//2, cy-card_h//2, cx+card_w//2, cy+card_h//2), 24, hex_to_rgba(WHITE))
    rounded_rect(draw, (cx-card_w//2, cy-card_h//2, cx+card_w//2, cy-card_h//2+8), 4, hex_to_rgba(PURPLE))

    draw.text((cx-200, cy-100), "Vorderseite", font=find_font(28, bold=False), fill=hex_to_rgba(TEXT_SUB))
    f_card = find_font(56, bold=True)
    draw.text((cx-200, cy-40), "What is a variable?", font=f_card, fill=hex_to_rgba(TEXT))
    draw.text((cx-200, cy+40), "A named storage location\nfor a value that can change.", font=find_font(32, bold=False), fill=hex_to_rgba(TEXT))

    # Rating buttons
    draw.text((cx-200, 1020), "⏳ Fällig: 3 Karten", font=find_font(28, bold=False), fill=hex_to_rgba(TEXT_SUB))
    buttons = [("1", RED), ("2", ORANGE), ("3", EMERALD), ("4", INDIGO), ("5", PURPLE)]
    labels = ["Wieder", "Schwer", "Gut", "Leicht", "Perfekt"]
    for i, (num, color) in enumerate(buttons):
        bx = 80 + i * 200
        draw.ellipse([bx, 1070, bx+80, 1150], fill=hex_to_rgba(color))
        draw.text((bx+28, 1095), num, font=find_font(32, bold=True), fill=hex_to_rgba(WHITE))
        draw.text((bx+10, 1160), labels[i], font=find_font(22, bold=False), fill=hex_to_rgba(TEXT))

    # Session summary
    rounded_rect(draw, (40, 1240, W-40, 1480), 20, hex_to_rgba(WHITE, 230))
    stats = [
        ("✅ Gelernt", "8", EMERALD),
        ("🔄 Wiederh.", "4", INDIGO),
        ("📈 Stabilität", "+12d", PURPLE),
        ("🎯 Genauigkeit", "75%", GOLD),
    ]
    for i, (label, val, color) in enumerate(stats):
        sx = 60 + i * 250
        draw.text((sx, 1260), label, font=find_font(26, bold=False), fill=hex_to_rgba(TEXT_SUB))
        draw.text((sx, 1300), val, font=find_font(52, bold=True), fill=hex_to_rgba(color))

    out = OUT_DIR / "03_study_session.png"
    img.save(out, "PNG", optimize=True)
    size = os.path.getsize(out)
    print(f"✅ {out.name}  ({size/1024:.0f} KB)")

# ═══════════════════════════════════════════════════════════════════
#  SCREENSHOT 4: Stats
# ═══════════════════════════════════════════════════════════════════
def make_04_stats():
    img = Image.new("RGB", (W, H), hex_to_rgba("#F5F3FF")[:3])
    draw = ImageDraw.Draw(img)
    draw_status_bar(draw, "Statistiken")
    draw_bottom_nav(draw, 2)

    # Time range selector
    rounded_rect(draw, (40, 170, W-40, 230), 16, hex_to_rgba(WHITE))
    periods = ["7 Tage", "30 Tage", "Alle"]
    for i, p in enumerate(periods):
        bx = 60 + i * 200
        color = INDIGO if i == 0 else TEXT_SUB
        f_sel = find_font(26, bold=True) if i == 0 else find_font(26, bold=False)
        draw.text((bx+40, 188), p, font=f_sel, fill=hex_to_rgba(color))

    # Big stat cards
    cards_data = [
        ("📊 Karten gelernt", "156", INDIGO),
        ("🔥 Beste Serie", "12 Tage", GOLD),
        ("⏱️ Zeit gelernt", "8.5h", PURPLE),
    ]
    for i, (label, val, color) in enumerate(cards_data):
        cx = 60 + i * 340
        rounded_rect(draw, (cx, 270, cx+300, 400), 20, hex_to_rgba(WHITE))
        draw.text((cx+20, 290), label, font=find_font(26, bold=False), fill=hex_to_rgba(TEXT_SUB))
        draw.text((cx+20, 335), val, font=find_font(52, bold=True), fill=hex_to_rgba(color))

    # Chart area (mock bar chart)
    rounded_rect(draw, (40, 440, W-40, 780), 20, hex_to_rgba(WHITE))
    draw.text((60, 460), "📈 Lernaktivität (letzte 7 Tage)", font=find_font(28, bold=True), fill=hex_to_rgba(TEXT))
    days = ["Mo", "Di", "Mi", "Do", "Fr", "Sa", "So"]
    vals = [12, 8, 15, 22, 18, 5, 3]
    max_val = max(vals)
    bar_w = 70
    for i, (day, v) in enumerate(zip(days, vals)):
        bx = 100 + i * 135
        bh = int(v / max_val * 200)
        by = 660 - bh
        rounded_rect(draw, (bx, by, bx+bar_w, 660), 8, hex_to_rgba(INDIGO if i < 5 else INDIGO_LIGHT))
        draw.text((bx+15, 670), str(v), font=find_font(22, bold=True), fill=hex_to_rgba(TEXT))
        draw.text((bx+10, 705), day, font=find_font(22, bold=False), fill=hex_to_rgba(TEXT_SUB))

    # Deck breakdown
    rounded_rect(draw, (40, 820, W-40, 1100), 20, hex_to_rgba(WHITE))
    draw.text((60, 840), "📚 Decks-Übersicht", font=find_font(28, bold=True), fill=hex_to_rgba(TEXT))
    decks = [
        ("🇬🇧 Englisch", "45/120 gelernt", INDIGO, 45/120),
        ("💻 Programmierung", "28/60 gelernt", EMERALD, 28/60),
        ("🏛️ Geschichte", "63/80 gelernt", PURPLE, 63/80),
        ("🔬 Wissenschaft", "20/40 gelernt", CYAN, 20/40),
    ]
    for i, (name, status, color, pct) in enumerate(decks):
        dy = 890 + i * 50
        draw.text((60, dy), name, font=find_font(26, bold=False), fill=hex_to_rgba(TEXT))
        draw.text((280, dy), status, font=find_font(24, bold=False), fill=hex_to_rgba(TEXT_SUB))
        # Mini progress bar
        rx, ry = 520, dy+6
        rounded_rect(draw, (rx, ry, rx+200, ry+16), 8, hex_to_rgba("#E0E7FF"))
        rounded_rect(draw, (rx, ry, int(rx+200*pct), ry+16), 8, hex_to_rgba(color))

    out = OUT_DIR / "04_stats.png"
    img.save(out, "PNG", optimize=True)
    size = os.path.getsize(out)
    print(f"✅ {out.name}  ({size/1024:.0f} KB)")

# ═══════════════════════════════════════════════════════════════════
#  SCREENSHOT 5: Add-Deck
# ═══════════════════════════════════════════════════════════════════
def make_05_add_deck():
    img = Image.new("RGB", (W, H), hex_to_rgba(SURFACE)[:3])
    draw = ImageDraw.Draw(img)
    draw_status_bar(draw, "Neues Deck")
    # No bottom nav (modal screen)

    # Form card
    rounded_rect(draw, (40, 170, W-40, 900), 24, hex_to_rgba(WHITE))

    draw.text((70, 200), "📝 Deck erstellen", font=find_font(36, bold=True), fill=hex_to_rgba(TEXT))

    # Form fields
    fields = [
        ("Emoji", "🇩🇪"),
        ("Name", "Deutsch Wortschatz"),
        ("Beschreibung", "Die 500 wichtigsten deutschen Wörter"),
        ("Tags", "Sprache, Deutsch, A1"),
    ]
    for i, (label, value) in enumerate(fields):
        fy = 280 + i * 120
        draw.text((70, fy), label, font=find_font(26, bold=False), fill=hex_to_rgba(TEXT_SUB))
        rounded_rect(draw, (70, fy+35, W-70, fy+95), 12, hex_to_rgba("#F9FAFB"))
        draw.text((90, fy+48), value, font=find_font(28, bold=False), fill=hex_to_rgba(TEXT))

    # Color picker
    draw.text((70, 705), "Farbe", font=find_font(26, bold=False), fill=hex_to_rgba(TEXT_SUB))
    colors = [INDIGO, EMERALD, RED, ORANGE, PURPLE, PINK, CYAN, LIME]
    for i, c in enumerate(colors):
        cx = 80 + i * 120
        outer = 4 if i == 0 else 0
        draw.ellipse([cx, 750, cx+64, 814], fill=hex_to_rgba(c))
        if i == 0:
            draw.ellipse([cx+4, 754, cx+60, 810], fill=hex_to_rgba(WHITE, 50))
            draw.ellipse([cx, 750, cx+64, 814], outline=hex_to_rgba(INDIGO), width=4)

    # Create button
    rounded_rect(draw, (70, 840, W-70, 920), 20, hex_to_rgba(INDIGO))
    draw.text((W//2-80, 860), "✅ Deck erstellen", font=find_font(32, bold=True), fill=hex_to_rgba(WHITE))

    # Privacy note
    draw.text((70, 960), "🔒 Alle Daten werden lokal auf deinem Gerät gespeichert.", font=find_font(22, bold=False), fill=hex_to_rgba(TEXT_SUB))

    # Preview of existing decks
    rounded_rect(draw, (40, 1040, W-40, 1300), 24, hex_to_rgba(WHITE))
    draw.text((70, 1060), "📚 Bereits vorhanden", font=find_font(28, bold=True), fill=hex_to_rgba(TEXT))

    existing = [
        ("🇬🇧 Englisch Grundlagen", "8 Karten", INDIGO),
        ("💻 Programmierung Basics", "6 Karten", EMERALD),
        ("🏛️ Geschichte", "10 Karten", PURPLE),
    ]
    for i, (name, count, color) in enumerate(existing):
        ey = 1110 + i * 60
        draw.text((70, ey), name, font=find_font(26, bold=False), fill=hex_to_rgba(TEXT))
        draw.text((400, ey), count, font=find_font(24, bold=False), fill=hex_to_rgba(TEXT_SUB))

    out = OUT_DIR / "05_add_deck.png"
    img.save(out, "PNG", optimize=True)
    size = os.path.getsize(out)
    print(f"✅ {out.name}  ({size/1024:.0f} KB)")

# ═══════════════════════════════════════════════════════════════════
#  SCREENSHOT 6: Settings
# ═══════════════════════════════════════════════════════════════════
def make_06_settings():
    img = Image.new("RGB", (W, H), hex_to_rgba(SURFACE)[:3])
    draw = ImageDraw.Draw(img)
    draw_status_bar(draw, "Einstellungen")
    draw_bottom_nav(draw, 3)

    # Settings groups
    groups = [
        ("🎯 Lernen", [
            ("Karten pro Tag", "20", "Maximale neue Karten pro Tag"),
            ("Wiederholungen", "SM-2", "Algorithmus für optimales Timing"),
            ("Intervalle", "1, 3, 7, 21, 60d", "Abstände zwischen Wiederholungen"),
        ]),
        ("🔔 Erinnerungen", [
            ("Tägliche Erinnerung", "08:00", "Täglich an fällige Karten erinnern"),
            ("Benachrichtigungen", "An", "Push-Benachrichtigungen"),
        ]),
        ("🎨 Darstellung", [
            ("Theme", "Indigo", "Farbschema der App"),
            ("Schriftgröße", "Mittel", "Für Kartenvorder- und Rückseite"),
        ]),
        ("🔒 Privatsphäre", [
            ("Lokale Speicherung", "✅ Aktiv", "Keine Daten auf Servern"),
            ("Analytics", "Aus", "Keine Nutzungsdaten werden gesendet"),
        ]),
    ]

    y = 170
    for group_name, items in groups:
        rounded_rect(draw, (40, y, W-40, y+40+len(items)*70), 16, hex_to_rgba(WHITE))
        draw.text((60, y+8), group_name, font=find_font(26, bold=True), fill=hex_to_rgba(TEXT))
        for i, (label, value, desc) in enumerate(items):
            iy = y + 50 + i * 70
            draw.text((60, iy), label, font=find_font(24, bold=False), fill=hex_to_rgba(TEXT))
            draw.text((360, iy), value, font=find_font(24, bold=True), fill=hex_to_rgba(INDIGO))
            draw.text((60, iy+30), desc, font=find_font(20, bold=False), fill=hex_to_rgba(TEXT_SUB))
        y += 40 + len(items)*70 + 16

    out = OUT_DIR / "06_settings.png"
    img.save(out, "PNG", optimize=True)
    size = os.path.getsize(out)
    print(f"✅ {out.name}  ({size/1024:.0f} KB)")

# ═══════════════════════════════════════════════════════════════════
#  SCREENSHOT 7: About / Privacy
# ═══════════════════════════════════════════════════════════════════
def make_07_about_privacy():
    img = Image.new("RGB", (W, H), hex_to_rgba("#EEF2FF")[:3])
    draw = ImageDraw.Draw(img)
    draw_status_bar(draw, "Über Recall")
    draw_bottom_nav(draw, 3)

    # App icon placeholder
    draw.ellipse([W//2-70, 200, W//2+70, 340], fill=hex_to_rgba(INDIGO))
    draw.text((W//2-40, 240), "R", font=find_font(100, bold=True), fill=hex_to_rgba(WHITE))

    draw.text((W//2-120, 370), "Recall v1.0.0", font=find_font(36, bold=True), fill=hex_to_rgba(TEXT))
    draw.text((W//2-200, 420), "Lerne smarter mit SM-2", font=find_font(28, bold=False), fill=hex_to_rgba(TEXT_SUB))

    # Privacy card
    rounded_rect(draw, (40, 490, W-40, 780), 24, hex_to_rgba(WHITE))
    draw.text((70, 510), "🔒 Datenschutz & Privatsphäre", font=find_font(30, bold=True), fill=hex_to_rgba(TEXT))
    privacy_items = [
        "✅ 100% lokale Speicherung – keine Cloud",
        "✅ Keine Tracking-Dienste eingebunden",
        "✅ Open Source – Code einsehbar auf GitHub",
        "✅ Keine Registrierung erforderlich",
        "✅ Daten gehören dir, bleiben auf deinem Gerät",
    ]
    for i, item in enumerate(privacy_items):
        draw.text((70, 570+i*48), item, font=find_font(24, bold=False), fill=hex_to_rgba(TEXT))

    # Features card
    rounded_rect(draw, (40, 820, W-40, 1050), 24, hex_to_rgba(WHITE))
    draw.text((70, 840), "✨ Funktionen", font=find_font(30, bold=True), fill=hex_to_rgba(TEXT))
    features = [
        "🧠 SM-2 Algorithmus für optimale Wiederholung",
        "📚 Unbegrenzt Decks und Karten",
        "📊 Detaillierte Lernstatistiken",
        "🔥 Streak-Tracker für tägliche Motivation",
        "🌙 Dark Mode Unterstützung",
    ]
    for i, feat in enumerate(features):
        draw.text((70, 900+i*48), feat, font=find_font(24, bold=False), fill=hex_to_rgba(TEXT))

    # Tech stack
    rounded_rect(draw, (40, 1090, W-40, 1200), 24, hex_to_rgba(WHITE, 230))
    draw.text((70, 1105), "📱 Flutter · Dart · SQLite · Material 3", font=find_font(24, bold=False), fill=hex_to_rgba(TEXT_SUB))

    # Footer
    draw.text((W//2-160, 1260), "© 2025 Recall App", font=find_font(22, bold=False), fill=hex_to_rgba(TEXT_SUB))

    out = OUT_DIR / "07_about_privacy.png"
    img.save(out, "PNG", optimize=True)
    size = os.path.getsize(out)
    print(f"✅ {out.name}  ({size/1024:.0f} KB)")

# ═══════════════════════════════════════════════════════════════════
#  SCREENSHOT 8: Streak-Tracker
# ═══════════════════════════════════════════════════════════════════
def make_08_streak_tracker():
    img = Image.new("RGB", (W, H), hex_to_rgba("#F5F3FF")[:3])
    draw = ImageDraw.Draw(img)
    draw_status_bar(draw, "Streak-Tracker")
    draw_bottom_nav(draw, 0)

    # Big streak counter
    rounded_rect(draw, (40, 170, W-40, 420), 24, hex_to_rgba(INDIGO))
    f_streak = find_font(120, bold=True)
    draw.text((W//2-100, 190), "🔥", font=find_font(80, bold=False), fill=hex_to_rgba(WHITE))
    draw.text((W//2-100, 250), "7", font=f_streak, fill=hex_to_rgba(WHITE))
    draw.text((W//2-100, 350), "Tage am Stück", font=find_font(32, bold=False), fill=hex_to_rgba("#C7D2FE"))

    # Calendar streak grid
    rounded_rect(draw, (40, 460, W-40, 720), 24, hex_to_rgba(WHITE))
    draw.text((60, 480), "📅 Letzte 4 Wochen", font=find_font(28, bold=True), fill=hex_to_rgba(TEXT))

    # Draw a grid of 28 days (4 weeks x 7 days)
    days_labels = ["Mo", "Di", "Mi", "Do", "Fr", "Sa", "So"]
    for i, dl in enumerate(days_labels):
        draw.text((80+i*135, 530), dl, font=find_font(20, bold=False), fill=hex_to_rgba(TEXT_SUB))

    # Simulate streak data (last 7 days active, some older)
    streak_data = [0, 0, 1, 0, 1, 1, 1,  # week 1
                    1, 1, 0, 1, 1, 1, 1,  # week 2
                    1, 1, 1, 1, 1, 0, 0,  # week 3
                    1, 1, 1, 1, 1, 1, 1]  # week 4 (current streak)
    for week in range(4):
        for day in range(7):
            idx = week * 7 + day
            active = streak_data[idx] == 1
            dx = 80 + day * 135
            dy = 565 + week * 50
            color = INDIGO if active else "#E0E7FF"
            draw.ellipse([dx, dy, dx+30, dy+30], fill=hex_to_rgba(color))
            if active and idx >= 21:
                # current streak days get a special mark
                draw.ellipse([dx+5, dy+5, dx+25, dy+25], fill=hex_to_rgba(PURPLE_LIGHT))

    # Milestones
    rounded_rect(draw, (40, 760, W-40, 1000), 24, hex_to_rgba(WHITE))
    draw.text((60, 780), "🏆 Meilensteine", font=find_font(28, bold=True), fill=hex_to_rgba(TEXT))
    milestones = [
        ("🔥 7 Tage", "✅ Erreicht!", GOLD),
        ("🔥 14 Tage", "🏃 7 verbleibend", TEXT_SUB),
        ("🔥 30 Tage", "🏃 23 verbleibend", TEXT_SUB),
        ("🔥 60 Tage", "🔒 Noch nicht erreicht", TEXT_SUB),
        ("🔥 100 Tage", "🔒 Noch nicht erreicht", TEXT_SUB),
    ]
    for i, (label, status, color) in enumerate(milestones):
        my = 830 + i * 34
        draw.text((60, my), label, font=find_font(24, bold=False), fill=hex_to_rgba(TEXT))
        draw.text((320, my), status, font=find_font(24, bold=True), fill=hex_to_rgba(color))

    # Motivation
    rounded_rect(draw, (40, 1040, W-40, 1120), 20, hex_to_rgba(PURPLE, 50))
    draw.text((60, 1060), "💪 Täglich lernen macht den Unterschied!", font=find_font(28, bold=True), fill=hex_to_rgba(PURPLE))

    out = OUT_DIR / "08_streak_tracker.png"
    img.save(out, "PNG", optimize=True)
    size = os.path.getsize(out)
    print(f"✅ {out.name}  ({size/1024:.0f} KB)")

# ═══════════════════════════════════════════════════════════════════
#  MAIN
# ═══════════════════════════════════════════════════════════════════
def main():
    print("=" * 60)
    print("  Recall — Play Store Screenshot Generator")
    print("=" * 60)
    make_01_home()
    make_02_card_flip()
    make_03_study_session()
    make_04_stats()
    make_05_add_deck()
    make_06_settings()
    make_07_about_privacy()
    make_08_streak_tracker()

    total = sum(
        os.path.getsize(OUT_DIR / f) for f in os.listdir(OUT_DIR)
        if f.endswith(".png")
    )
    print(f"\n🎉 8 Screenshots in {OUT_DIR}/")
    print(f"📦 Gesamt: {total/1024:.0f} KB")
    return 0

if __name__ == "__main__":
    sys.exit(main())