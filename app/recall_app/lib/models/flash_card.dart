import 'package:flutter/foundation.dart';

/// Eine einzelne Karte in einem Deck.
@immutable
class FlashCard {
  final String id;
  final String deckId;
  final String front;
  final String back;
  final String? hint;
  final List<String> tags;
  final DateTime createdAt;

  // SM-2 Spaced Repetition State
  final int repetitions; // 0 = neu, n = mal korrekt in Folge
  final double easeFactor; // 1.3 - 2.5, default 2.5
  final int intervalDays; // Tage bis zur nächsten Wiederholung
  final DateTime? nextReviewAt;
  final DateTime? lastReviewedAt;
  final int totalReviews;
  final int correctReviews;

  const FlashCard({
    required this.id,
    required this.deckId,
    required this.front,
    required this.back,
    this.hint,
    this.tags = const [],
    required this.createdAt,
    this.repetitions = 0,
    this.easeFactor = 2.5,
    this.intervalDays = 0,
    this.nextReviewAt,
    this.lastReviewedAt,
    this.totalReviews = 0,
    this.correctReviews = 0,
  });

  bool get isDue {
    if (nextReviewAt == null) return true; // Neue Karten sind fällig
    return DateTime.now().isAfter(nextReviewAt!);
  }

  bool get isNew => repetitions == 0 && totalReviews == 0;

  double get accuracy =>
      totalReviews == 0 ? 0.0 : correctReviews / totalReviews;

  FlashCard copyWith({
    String? front,
    String? back,
    String? hint,
    List<String>? tags,
    int? repetitions,
    double? easeFactor,
    int? intervalDays,
    DateTime? nextReviewAt,
    DateTime? lastReviewedAt,
    int? totalReviews,
    int? correctReviews,
  }) {
    return FlashCard(
      id: id,
      deckId: deckId,
      front: front ?? this.front,
      back: back ?? this.back,
      hint: hint ?? this.hint,
      tags: tags ?? this.tags,
      createdAt: createdAt,
      repetitions: repetitions ?? this.repetitions,
      easeFactor: easeFactor ?? this.easeFactor,
      intervalDays: intervalDays ?? this.intervalDays,
      nextReviewAt: nextReviewAt ?? this.nextReviewAt,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      totalReviews: totalReviews ?? this.totalReviews,
      correctReviews: correctReviews ?? this.correctReviews,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'deckId': deckId,
        'front': front,
        'back': back,
        'hint': hint,
        'tags': tags,
        'createdAt': createdAt.toIso8601String(),
        'repetitions': repetitions,
        'easeFactor': easeFactor,
        'intervalDays': intervalDays,
        'nextReviewAt': nextReviewAt?.toIso8601String(),
        'lastReviewedAt': lastReviewedAt?.toIso8601String(),
        'totalReviews': totalReviews,
        'correctReviews': correctReviews,
      };

  factory FlashCard.fromJson(Map<String, dynamic> json) => FlashCard(
        id: json['id'] as String,
        deckId: json['deckId'] as String,
        front: json['front'] as String,
        back: json['back'] as String,
        hint: json['hint'] as String?,
        tags: (json['tags'] as List?)?.cast<String>() ?? const [],
        createdAt: DateTime.parse(json['createdAt'] as String),
        repetitions: json['repetitions'] as int? ?? 0,
        easeFactor: (json['easeFactor'] as num?)?.toDouble() ?? 2.5,
        intervalDays: json['intervalDays'] as int? ?? 0,
        nextReviewAt: json['nextReviewAt'] != null
            ? DateTime.parse(json['nextReviewAt'] as String)
            : null,
        lastReviewedAt: json['lastReviewedAt'] != null
            ? DateTime.parse(json['lastReviewedAt'] as String)
            : null,
        totalReviews: json['totalReviews'] as int? ?? 0,
        correctReviews: json['correctReviews'] as int? ?? 0,
      );
}
