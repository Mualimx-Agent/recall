import 'package:flutter/foundation.dart';

/// Eine einzelne Lern-Session (z.B. "Heute 25 Karten gelernt").
@immutable
class StudySession {
  final String id;
  final String deckId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int cardsStudied;
  final int correctCount;
  final int againCount; // Quality 0-1
  final int hardCount; // Quality 2-3
  final int goodCount; // Quality 4
  final int easyCount; // Quality 5

  const StudySession({
    required this.id,
    required this.deckId,
    required this.startedAt,
    this.endedAt,
    this.cardsStudied = 0,
    this.correctCount = 0,
    this.againCount = 0,
    this.hardCount = 0,
    this.goodCount = 0,
    this.easyCount = 0,
  });

  Duration get duration =>
      (endedAt ?? DateTime.now()).difference(startedAt);

  double get accuracy =>
      cardsStudied == 0 ? 0.0 : correctCount / cardsStudied;

  StudySession copyWith({
    DateTime? endedAt,
    int? cardsStudied,
    int? correctCount,
    int? againCount,
    int? hardCount,
    int? goodCount,
    int? easyCount,
  }) {
    return StudySession(
      id: id,
      deckId: deckId,
      startedAt: startedAt,
      endedAt: endedAt ?? this.endedAt,
      cardsStudied: cardsStudied ?? this.cardsStudied,
      correctCount: correctCount ?? this.correctCount,
      againCount: againCount ?? this.againCount,
      hardCount: hardCount ?? this.hardCount,
      goodCount: goodCount ?? this.goodCount,
      easyCount: easyCount ?? this.easyCount,
    );
  }
}

/// Aggregierte Stats über alle Decks hinweg.
@immutable
class UserStats {
  final int totalDecks;
  final int totalCards;
  final int cardsLearned; // repetitions >= 2
  final int totalReviews;
  final double overallAccuracy;
  final int currentStreakDays;
  final int longestStreakDays;
  final int reviewsToday;
  final Map<String, int> reviewsByDay; // "2026-07-09" -> count
  final DateTime? lastStudyDate;

  const UserStats({
    this.totalDecks = 0,
    this.totalCards = 0,
    this.cardsLearned = 0,
    this.totalReviews = 0,
    this.overallAccuracy = 0.0,
    this.currentStreakDays = 0,
    this.longestStreakDays = 0,
    this.reviewsToday = 0,
    this.reviewsByDay = const {},
    this.lastStudyDate,
  });

  UserStats copyWith({
    int? totalDecks,
    int? totalCards,
    int? cardsLearned,
    int? totalReviews,
    double? overallAccuracy,
    int? currentStreakDays,
    int? longestStreakDays,
    int? reviewsToday,
    Map<String, int>? reviewsByDay,
    DateTime? lastStudyDate,
  }) {
    return UserStats(
      totalDecks: totalDecks ?? this.totalDecks,
      totalCards: totalCards ?? this.totalCards,
      cardsLearned: cardsLearned ?? this.cardsLearned,
      totalReviews: totalReviews ?? this.totalReviews,
      overallAccuracy: overallAccuracy ?? this.overallAccuracy,
      currentStreakDays: currentStreakDays ?? this.currentStreakDays,
      longestStreakDays: longestStreakDays ?? this.longestStreakDays,
      reviewsToday: reviewsToday ?? this.reviewsToday,
      reviewsByDay: reviewsByDay ?? this.reviewsByDay,
      lastStudyDate: lastStudyDate ?? this.lastStudyDate,
    );
  }
}
