import '../models/flash_card.dart';

/// SM-2 Spaced Repetition Algorithmus (SuperMemo 2).
///
/// Quality-Skala (0-5):
///   0 - Wieder totale Blackout
///   1 - Falsch, aber die richtige Antwort war vertraut
///   2 - Falsch, aber leicht zu merken nach Anschauen
///   3 - Korrekt, aber mit grosser Schwierigkeit
///   4 - Korrekt nach einigem Zögern
///   5 - Perfekte Antwort, kein Zögern
///
/// Wir mappen UI-Buttons auf Quality:
///   "Again" -> 1
///   "Hard"  -> 3
///   "Good"  -> 4
///   "Easy"  -> 5
class SM2Algorithm {
  /// Berechnet die nächste Wiederholung für eine Karte.
  /// Liefert eine neue FlashCard mit aktualisierten SM-2-Werten.
  static FlashCard review({
    required FlashCard card,
    required int quality,
    DateTime? now,
  }) {
    assert(quality >= 0 && quality <= 5, 'Quality muss 0-5 sein');

    now ??= DateTime.now();
    final wasCorrect = quality >= 3;

    // EF (Ease Factor) anpassen
    // EF' = EF + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02))
    double newEase = card.easeFactor +
        (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
    if (newEase < 1.3) newEase = 1.3;
    if (newEase > 3.0) newEase = 3.0;

    int newRepetitions;
    int newIntervalDays;

    if (quality < 3) {
      // Falsch: Reset repetitions, neues Intervall = 1 Tag
      newRepetitions = 0;
      newIntervalDays = 1;
    } else {
      // Korrekt
      newRepetitions = card.repetitions + 1;
      if (newRepetitions == 1) {
        newIntervalDays = 1;
      } else if (newRepetitions == 2) {
        newIntervalDays = 6;
      } else {
        // I(n) = I(n-1) * EF
        final baseInterval =
            (card.intervalDays * newEase).round().clamp(1, 365);
        newIntervalDays = baseInterval;
        // Easy-Bonus
        if (quality == 5) {
          newIntervalDays = (newIntervalDays * 1.3).round();
        }
      }
    }

    final nextReview = now.add(Duration(days: newIntervalDays));

    return card.copyWith(
      repetitions: newRepetitions,
      easeFactor: newEase,
      intervalDays: newIntervalDays,
      nextReviewAt: nextReview,
      lastReviewedAt: now,
      totalReviews: card.totalReviews + 1,
      correctReviews: card.correctReviews + (wasCorrect ? 1 : 0),
    );
  }

  /// Berechnet einen "Preview" des nächsten Intervalls (für UI-Vorschau).
  static int previewIntervalDays(FlashCard card, int quality) {
    final preview = review(card: card, quality: quality, now: DateTime.now());
    return preview.intervalDays;
  }
}
