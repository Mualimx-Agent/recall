import '../models/deck.dart';
import '../models/flash_card.dart';
import '../models/study_session.dart';

/// 4 Demo-Decks mit insgesamt ~30 Karten, sofort spielbar.
/// Themen: Sprachen (Englisch), IT/Programmierung, Geschichte, Wissenschaft.
class DemoData {
  static final DateTime _now = DateTime.now();

  static List<({Deck deck, List<FlashCard> cards})> all() {
    return [
      _englishDeck(),
      _programmingDeck(),
      _historyDeck(),
      _scienceDeck(),
    ];
  }

  static ({Deck deck, List<FlashCard> cards}) _englishDeck() {
    final deck = Deck(
      id: 'deck_english_basics',
      name: 'Englisch Grundlagen',
      description: 'Die 500 wichtigsten englischen Wörter für Alltag und Reise.',
      emoji: '🇬🇧',
      colorValue: 0xFF4F46E5,
      createdAt: _now.subtract(const Duration(days: 7)),
      tags: const ['Sprache', 'Englisch', 'A1'],
      totalCards: 8,
      dueCards: 8,
      newCards: 8,
      learnedCards: 0,
    );

    final cards = <FlashCard>[
      FlashCard(
        id: 'card_en_1',
        deckId: deck.id,
        front: 'Hello',
        back: 'Hallo',
        hint: 'Begrüssung',
        createdAt: _now.subtract(const Duration(days: 7)),
      ),
      FlashCard(
        id: 'card_en_2',
        deckId: deck.id,
        front: 'Goodbye',
        back: 'Auf Wiedersehen',
        createdAt: _now.subtract(const Duration(days: 7)),
      ),
      FlashCard(
        id: 'card_en_3',
        deckId: deck.id,
        front: 'Thank you',
        back: 'Danke',
        createdAt: _now.subtract(const Duration(days: 7)),
      ),
      FlashCard(
        id: 'card_en_4',
        deckId: deck.id,
        front: 'Please',
        back: 'Bitte',
        createdAt: _now.subtract(const Duration(days: 7)),
      ),
      FlashCard(
        id: 'card_en_5',
        deckId: deck.id,
        front: 'Yes / No',
        back: 'Ja / Nein',
        createdAt: _now.subtract(const Duration(days: 7)),
      ),
      FlashCard(
        id: 'card_en_6',
        deckId: deck.id,
        front: 'Where is the bathroom?',
        back: 'Wo ist die Toilette?',
        hint: 'Wichtige Reise-Frage',
        createdAt: _now.subtract(const Duration(days: 7)),
      ),
      FlashCard(
        id: 'card_en_7',
        deckId: deck.id,
        front: 'How much does it cost?',
        back: 'Wie viel kostet es?',
        createdAt: _now.subtract(const Duration(days: 7)),
      ),
      FlashCard(
        id: 'card_en_8',
        deckId: deck.id,
        front: 'I don\'t understand',
        back: 'Ich verstehe nicht',
        createdAt: _now.subtract(const Duration(days: 7)),
      ),
    ];

    return (deck: deck, cards: cards);
  }

  static ({Deck deck, List<FlashCard> cards}) _programmingDeck() {
    final deck = Deck(
      id: 'deck_programming',
      name: 'Programmierung Basics',
      description: 'Grundbegriffe aus Software-Entwicklung und Web.',
      emoji: '💻',
      colorValue: 0xFF059669,
      createdAt: _now.subtract(const Duration(days: 14)),
      tags: const ['IT', 'Programmierung'],
      totalCards: 6,
      dueCards: 6,
      newCards: 6,
      learnedCards: 0,
    );

    final cards = <FlashCard>[
      FlashCard(
        id: 'card_prog_1',
        deckId: deck.id,
        front: 'Was ist eine Variable?',
        back: 'Ein benannter Speicherort für einen Wert, der sich ändern kann.',
        hint: 'Grundkonzept jeder Programmiersprache',
        createdAt: _now.subtract(const Duration(days: 14)),
      ),
      FlashCard(
        id: 'card_prog_2',
        deckId: deck.id,
        front: 'Was ist eine Funktion?',
        back: 'Ein wiederverwendbarer Codeblock, der eine bestimmte Aufgabe erfüllt.',
        createdAt: _now.subtract(const Duration(days: 14)),
      ),
      FlashCard(
        id: 'card_prog_3',
        deckId: deck.id,
        front: 'Was bedeutet API?',
        back: 'Application Programming Interface – Schnittstelle zwischen Programmen.',
        createdAt: _now.subtract(const Duration(days: 14)),
      ),
      FlashCard(
        id: 'card_prog_4',
        deckId: deck.id,
        front: 'Was ist Git?',
        back: 'Ein Versionskontrollsystem zum Verfolgen von Code-Änderungen.',
        createdAt: _now.subtract(const Duration(days: 14)),
      ),
      FlashCard(
        id: 'card_prog_5',
        deckId: deck.id,
        front: 'Was ist eine Datenbank?',
        back: 'Strukturierte Sammlung von Daten, elektronisch gespeichert und abrufbar.',
        createdAt: _now.subtract(const Duration(days: 14)),
      ),
      FlashCard(
        id: 'card_prog_6',
        deckId: deck.id,
        front: 'Was bedeutet "Open Source"?',
        back:
            'Software, deren Quellcode öffentlich ist und frei verwendet, geändert und geteilt werden darf.',
        createdAt: _now.subtract(const Duration(days: 14)),
      ),
    ];

    return (deck: deck, cards: cards);
  }

  static ({Deck deck, List<FlashCard> cards}) _historyDeck() {
    final deck = Deck(
      id: 'deck_history',
      name: 'Weltgeschichte Meilensteine',
      description: 'Schlüsselereignisse, die die Welt verändert haben.',
      emoji: '🏛️',
      colorValue: 0xFFDC2626,
      createdAt: _now.subtract(const Duration(days: 30)),
      tags: const ['Geschichte', 'Schule'],
      totalCards: 8,
      dueCards: 8,
      newCards: 8,
      learnedCards: 0,
    );

    final cards = <FlashCard>[
      FlashCard(
        id: 'card_hist_1',
        deckId: deck.id,
        front: 'Wann fiel die Berliner Mauer?',
        back: 'Am 9. November 1989.',
        createdAt: _now.subtract(const Duration(days: 30)),
      ),
      FlashCard(
        id: 'card_hist_2',
        deckId: deck.id,
        front: 'Wann begann der Zweite Weltkrieg?',
        back: 'Am 1. September 1939 (Überfall auf Polen).',
        createdAt: _now.subtract(const Duration(days: 30)),
      ),
      FlashCard(
        id: 'card_hist_3',
        deckId: deck.id,
        front: 'Wer war Mahatma Gandhi?',
        back:
            'Indischer Rechtsanwalt und politischer Führer, der Indien durch gewaltlosen Widerstand zur Unabhängigkeit führte.',
        createdAt: _now.subtract(const Duration(days: 30)),
      ),
      FlashCard(
        id: 'card_hist_4',
        deckId: deck.id,
        front: 'Wann wurde die UNO gegründet?',
        back: 'Am 24. Oktober 1945.',
        createdAt: _now.subtract(const Duration(days: 30)),
      ),
      FlashCard(
        id: 'card_hist_5',
        deckId: deck.id,
        front: 'Was war die Französische Revolution?',
        back:
            'Eine Revolution in Frankreich (1789–1799), die die absolute Monarchie stürzte und die Republik einführte.',
        createdAt: _now.subtract(const Duration(days: 30)),
      ),
      FlashCard(
        id: 'card_hist_6',
        deckId: deck.id,
        front: 'Wer entdeckte Amerika?',
        back:
            'Christoph Kolumbus erreichte 1492 die Karibik (für Europa). Indigene Völker lebten dort schon Jahrtausende.',
        createdAt: _now.subtract(const Duration(days: 30)),
      ),
      FlashCard(
        id: 'card_hist_7',
        deckId: deck.id,
        front: 'Wann war die industrielle Revolution?',
        back:
            'Etwa 1760 bis 1840, beginnend in Grossbritannien, mit Übergang zu maschineller Produktion.',
        createdAt: _now.subtract(const Duration(days: 30)),
      ),
      FlashCard(
        id: 'card_hist_8',
        deckId: deck.id,
        front: 'Wer war Nikola Tesla?',
        back:
            'Serbisch-amerikanischer Erfinder, Pionier der Wechselstromtechnik und des drahtlosen Energietransfers.',
        createdAt: _now.subtract(const Duration(days: 30)),
      ),
    ];

    return (deck: deck, cards: cards);
  }

  static ({Deck deck, List<FlashCard> cards}) _scienceDeck() {
    final deck = Deck(
      id: 'deck_science',
      name: 'Naturwissenschaft A–Z',
      description: 'Physik, Chemie, Biologie – die Basics.',
      emoji: '🔬',
      colorValue: 0xFF7C3AED,
      createdAt: _now.subtract(const Duration(days: 21)),
      tags: const ['Wissenschaft', 'Schule'],
      totalCards: 8,
      dueCards: 8,
      newCards: 8,
      learnedCards: 0,
    );

    final cards = <FlashCard>[
      FlashCard(
        id: 'card_sci_1',
        deckId: deck.id,
        front: 'Was ist Photosynthese?',
        back:
            'Prozess, bei dem Pflanzen Lichtenergie in chemische Energie (Glukose) umwandeln, mit CO₂ und Wasser.',
        createdAt: _now.subtract(const Duration(days: 21)),
      ),
      FlashCard(
        id: 'card_sci_2',
        deckId: deck.id,
        front: 'Was ist die Lichtgeschwindigkeit?',
        back: 'Rund 299 792 458 Meter pro Sekunde im Vakuum.',
        createdAt: _now.subtract(const Duration(days: 21)),
      ),
      FlashCard(
        id: 'card_sci_3',
        deckId: deck.id,
        front: 'Was bedeutet DNA?',
        back:
            'Desoxyribonukleinsäure – Träger der Erbinformation in allen Lebewesen.',
        createdAt: _now.subtract(const Duration(days: 21)),
      ),
      FlashCard(
        id: 'card_sci_4',
        deckId: deck.id,
        front: 'Was sind die drei Aggregatzustände?',
        back: 'Fest, flüssig, gasförmig.',
        createdAt: _now.subtract(const Duration(days: 21)),
      ),
      FlashCard(
        id: 'card_sci_5',
        deckId: deck.id,
        front: 'Was ist Schwerkraft?',
        back:
            'Anziehungskraft zwischen Massen. Auf der Erde ca. 9,81 m/s² Beschleunigung.',
        createdAt: _now.subtract(const Duration(days: 21)),
      ),
      FlashCard(
        id: 'card_sci_6',
        deckId: deck.id,
        front: 'Was ist ein Atom?',
        back:
            'Kleinste Einheit eines chemischen Elements, bestehend aus Kern (Protonen, Neutronen) und Elektronenhülle.',
        createdAt: _now.subtract(const Duration(days: 21)),
      ),
      FlashCard(
        id: 'card_sci_7',
        deckId: deck.id,
        front: 'Woraus besteht Wasser chemisch?',
        back: 'Aus zwei Wasserstoff- und einem Sauerstoffatom: H₂O.',
        createdAt: _now.subtract(const Duration(days: 21)),
      ),
      FlashCard(
        id: 'card_sci_8',
        deckId: deck.id,
        front: 'Was ist Photosynthese-Formel?',
        back:
            '6 CO₂ + 6 H₂O + Licht → C₆H₁₂O₆ (Glukose) + 6 O₂',
        createdAt: _now.subtract(const Duration(days: 21)),
      ),
    ];

    return (deck: deck, cards: cards);
  }

  /// Beispiel-UserStats für Demo.
  static UserStats sampleStats() {
    return UserStats(
      totalDecks: 4,
      totalCards: 30,
      cardsLearned: 12,
      totalReviews: 142,
      overallAccuracy: 0.86,
      currentStreakDays: 7,
      longestStreakDays: 14,
      reviewsToday: 23,
    );
  }
}
