import 'package:flutter/foundation.dart';

/// Ein Deck (Sammlung) von Karten.
@immutable
class Deck {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final int colorValue; // ARGB
  final DateTime createdAt;
  final List<String> tags;
  final bool isPublic; // für kollaborative Decks (v2.0)

  // Aggregierte Stats (für schnelles Listen-Rendering)
  final int totalCards;
  final int dueCards;
  final int newCards;
  final int learnedCards;
  final int totalReviews;
  final double averageAccuracy;
  final DateTime? lastStudiedAt;

  const Deck({
    required this.id,
    required this.name,
    required this.description,
    this.emoji = '📚',
    this.colorValue = 0xFF4F46E5,
    required this.createdAt,
    this.tags = const [],
    this.isPublic = false,
    this.totalCards = 0,
    this.dueCards = 0,
    this.newCards = 0,
    this.learnedCards = 0,
    this.totalReviews = 0,
    this.averageAccuracy = 0.0,
    this.lastStudiedAt,
  });

  Deck copyWith({
    String? name,
    String? description,
    String? emoji,
    int? colorValue,
    List<String>? tags,
    bool? isPublic,
    int? totalCards,
    int? dueCards,
    int? newCards,
    int? learnedCards,
    int? totalReviews,
    double? averageAccuracy,
    DateTime? lastStudiedAt,
  }) {
    return Deck(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      emoji: emoji ?? this.emoji,
      colorValue: colorValue ?? this.colorValue,
      createdAt: createdAt,
      tags: tags ?? this.tags,
      isPublic: isPublic ?? this.isPublic,
      totalCards: totalCards ?? this.totalCards,
      dueCards: dueCards ?? this.dueCards,
      newCards: newCards ?? this.newCards,
      learnedCards: learnedCards ?? this.learnedCards,
      totalReviews: totalReviews ?? this.totalReviews,
      averageAccuracy: averageAccuracy ?? this.averageAccuracy,
      lastStudiedAt: lastStudiedAt ?? this.lastStudiedAt,
    );
  }
}
