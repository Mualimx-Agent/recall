import 'package:flutter/foundation.dart';

import '../data/demo_data.dart';
import '../models/deck.dart';
import '../models/flash_card.dart';
import '../models/study_session.dart';
import '../services/sm2_algorithm.dart';

/// Haupt-Provider für Decks, Karten und Study-Sessions.
/// Hält State im Speicher (in v2.0: Hive/SQLite-Persistenz).
class DeckProvider extends ChangeNotifier {
  final List<Deck> _decks = [];
  final List<FlashCard> _allCards = [];
  final List<StudySession> _recentSessions = [];
  UserStats _stats = UserStats();

  DeckProvider() {
    _loadDemoData();
  }

  // ============================================================
  // Public read API
  // ============================================================

  List<Deck> get decks => List.unmodifiable(_decks);

  UserStats get stats => _stats;

  List<StudySession> get recentSessions =>
      List.unmodifiable(_recentSessions);

  /// Liefert alle Karten eines Decks.
  List<FlashCard> cardsForDeck(String deckId) {
    return _allCards.where((c) => c.deckId == deckId).toList();
  }

  /// Liefert die Karten eines Decks, die heute fällig sind.
  List<FlashCard> dueCardsForDeck(String deckId, {int? limit}) {
    final due = _allCards
        .where((c) => c.deckId == deckId && c.isDue)
        .toList()
      ..sort((a, b) {
        // Neue Karten zuerst, dann nach fälligkeitsdatum
        if (a.isNew && !b.isNew) return -1;
        if (!a.isNew && b.isNew) return 1;
        if (a.nextReviewAt == null) return -1;
        if (b.nextReviewAt == null) return 1;
        return a.nextReviewAt!.compareTo(b.nextReviewAt!);
      });
    if (limit != null && due.length > limit) {
      return due.sublist(0, limit);
    }
    return due;
  }

  Deck? deckById(String id) {
    try {
      return _decks.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  // ============================================================
  // Study-Flow
  // ============================================================

  /// Verarbeitet eine Antwort (Quality 0-5) auf eine Karte.
  void reviewCard(FlashCard card, int quality) {
    final updated = SM2Algorithm.review(card: card, quality: quality);
    final idx = _allCards.indexWhere((c) => c.id == card.id);
    if (idx != -1) {
      _allCards[idx] = updated;
    }
    _recalcDeckStats(card.deckId);
    _recalcUserStats();
    notifyListeners();
  }

  /// Beendet eine Study-Session (wird beim Verlassen des Study-Screens aufgerufen).
  void finishSession(StudySession session) {
    _recentSessions.insert(0, session);
    if (_recentSessions.length > 50) {
      _recentSessions.removeLast();
    }
    _recalcUserStats();
    notifyListeners();
  }

  // ============================================================
  // Deck-Management
  // ============================================================

  void createDeck({
    required String name,
    required String description,
    String emoji = '📚',
    int colorValue = 0xFF4F46E5,
    List<String> tags = const [],
  }) {
    final id = 'deck_${DateTime.now().millisecondsSinceEpoch}';
    final newDeck = Deck(
      id: id,
      name: name,
      description: description,
      emoji: emoji,
      colorValue: colorValue,
      createdAt: DateTime.now(),
      tags: tags,
    );
    _decks.add(newDeck);
    _recalcUserStats();
    notifyListeners();
  }

  void deleteDeck(String deckId) {
    _decks.removeWhere((d) => d.id == deckId);
    _allCards.removeWhere((c) => c.deckId == deckId);
    _recalcUserStats();
    notifyListeners();
  }

  void addCardToDeck({
    required String deckId,
    required String front,
    required String back,
    String? hint,
    List<String> tags = const [],
  }) {
    final card = FlashCard(
      id: 'card_${DateTime.now().millisecondsSinceEpoch}',
      deckId: deckId,
      front: front,
      back: back,
      hint: hint,
      tags: tags,
      createdAt: DateTime.now(),
    );
    _allCards.add(card);
    _recalcDeckStats(deckId);
    _recalcUserStats();
    notifyListeners();
  }

  // ============================================================
  // Interne Berechnungen
  // ============================================================

  void _recalcDeckStats(String deckId) {
    final idx = _decks.indexWhere((d) => d.id == deckId);
    if (idx == -1) return;

    final cards = cardsForDeck(deckId);
    final due = dueCardsForDeck(deckId).length;
    final newC = cards.where((c) => c.isNew).length;
    final learned = cards.where((c) => c.repetitions >= 2).length;
    final totalRev = cards.fold<int>(0, (s, c) => s + c.totalReviews);
    final correct = cards.fold<int>(0, (s, c) => s + c.correctReviews);
    final lastStudied = cards
        .map((c) => c.lastReviewedAt)
        .where((d) => d != null)
        .fold<DateTime?>(null, (acc, d) {
      if (acc == null) return d;
      return d!.isAfter(acc) ? d : acc;
    });

    _decks[idx] = _decks[idx].copyWith(
      totalCards: cards.length,
      dueCards: due,
      newCards: newC,
      learnedCards: learned,
      totalReviews: totalRev,
      averageAccuracy: totalRev == 0 ? 0.0 : correct / totalRev,
      lastStudiedAt: lastStudied,
    );
  }

  void _recalcUserStats() {
    final totalCards = _allCards.length;
    final learned = _allCards.where((c) => c.repetitions >= 2).length;
    final totalRev =
        _allCards.fold<int>(0, (s, c) => s + c.totalReviews);
    final correctRev =
        _allCards.fold<int>(0, (s, c) => s + c.correctReviews);

    // Streak (vereinfacht: zähle rückwärts Tage mit Reviews)
    final reviewDays = <String>{};
    for (final card in _allCards) {
      if (card.lastReviewedAt != null) {
        reviewDays.add(
            '${card.lastReviewedAt!.year}-${card.lastReviewedAt!.month.toString().padLeft(2, '0')}-${card.lastReviewedAt!.day.toString().padLeft(2, '0')}');
      }
    }
    int streak = 0;
    var d = DateTime.now();
    while (true) {
      final key =
          '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
      if (reviewDays.contains(key)) {
        streak++;
        d = d.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    _stats = _stats.copyWith(
      totalDecks: _decks.length,
      totalCards: totalCards,
      cardsLearned: learned,
      totalReviews: totalRev,
      overallAccuracy: totalRev == 0 ? 0.0 : correctRev / totalRev,
      currentStreakDays: streak,
      reviewsToday: _allCards
          .where((c) =>
              c.lastReviewedAt != null &&
              _isSameDay(c.lastReviewedAt!, DateTime.now()))
          .fold<int>(0, (s, c) => s + 1),
      lastStudyDate: _allCards
          .map((c) => c.lastReviewedAt)
          .where((d) => d != null)
          .fold<DateTime?>(null, (acc, d) {
        if (acc == null) return d;
        return d!.isAfter(acc) ? d : acc;
      }),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _loadDemoData() {
    for (final entry in DemoData.all()) {
      _decks.add(entry.deck);
      _allCards.addAll(entry.cards);
    }
    // Aggregierte Stats neu berechnen
    for (final deck in _decks) {
      _recalcDeckStats(deck.id);
    }
    _recalcUserStats();
  }
}
