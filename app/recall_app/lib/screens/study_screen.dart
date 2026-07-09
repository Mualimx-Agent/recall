import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/flash_card.dart';
import '../models/study_session.dart';
import '../providers/deck_provider.dart';
import '../services/sm2_algorithm.dart';

/// Study-Screen: Card-Flip + 4-Button Bewertung (Again/Hard/Good/Easy).
class StudyScreen extends StatefulWidget {
  final String deckId;
  const StudyScreen({super.key, required this.deckId});

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  late StudySession _session;
  late List<FlashCard> _queue;
  int _index = 0;
  bool _flipped = false;
  late FlashCard _current;
  int _reviewedCount = 0;
  int _correctCount = 0;

  @override
  void initState() {
    super.initState();
    final provider = context.read<DeckProvider>();
    _queue = provider.dueCardsForDeck(widget.deckId, limit: 20);
    if (_queue.isEmpty) {
      _queue = provider.cardsForDeck(widget.deckId).take(10).toList();
    }
    _session = StudySession(
      id: 'session_${DateTime.now().millisecondsSinceEpoch}',
      deckId: widget.deckId,
      startedAt: DateTime.now(),
    );
    _current = _queue.first;
  }

  void _onGrade(int quality) {
    HapticFeedback.mediumImpact();
    final provider = context.read<DeckProvider>();
    provider.reviewCard(_current, quality);
    final wasCorrect = quality >= 3;

    setState(() {
      _reviewedCount++;
      if (wasCorrect) _correctCount++;
      // Update session stats
      _session = _session.copyWith(
        cardsStudied: _reviewedCount,
        correctCount: _correctCount,
        againCount: _session.againCount + (quality < 2 ? 1 : 0),
        hardCount: _session.hardCount + (quality == 3 ? 1 : 0),
        goodCount: _session.goodCount + (quality == 4 ? 1 : 0),
        easyCount: _session.easyCount + (quality == 5 ? 1 : 0),
      );

      if (_index < _queue.length - 1) {
        _index++;
        _current = _queue[_index];
        _flipped = false;
      } else {
        // Session beendet
        _showSummary();
      }
    });
  }

  void _showSummary() {
    final finishedSession = _session.copyWith(
      endedAt: DateTime.now(),
    );
    context.read<DeckProvider>().finishSession(finishedSession);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: const [
            Text('🎉', style: TextStyle(fontSize: 32)),
            SizedBox(width: 12),
            Text('Session beendet!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SummaryRow('Karten', '$_reviewedCount'),
            _SummaryRow('Richtig', '$_correctCount'),
            _SummaryRow(
                'Quote',
                '${((_correctCount / _reviewedCount) * 100).toStringAsFixed(0)}%'),
            _SummaryRow(
                'Dauer',
                '${finishedSession.duration.inSeconds ~/ 60}:${(finishedSession.duration.inSeconds % 60).toString().padLeft(2, '0')} min'),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.pop();
            },
            child: const Text('Fertig'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_queue.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Study')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('✨', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 16),
              const Text('Keine Karten zum Lernen!'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.pop(),
                child: const Text('Zurück'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Karte ${_index + 1} / ${_queue.length}'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: (_index + 1) / _queue.length,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Card
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _flipped = !_flipped),
                child: _FlipCard(
                  front: _current.front,
                  back: _current.back,
                  hint: _current.hint,
                  flipped: _flipped,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Grade buttons
            if (_flipped)
              _GradeButtons(
                current: _current,
                onGrade: _onGrade,
              )
            else
              FilledButton.tonal(
                onPressed: () => setState(() => _flipped = true),
                child: const Text('Antwort zeigen'),
              ),
          ],
        ),
      ),
    );
  }
}

class _FlipCard extends StatelessWidget {
  final String front;
  final String back;
  final String? hint;
  final bool flipped;
  const _FlipCard({
    required this.front,
    required this.back,
    required this.hint,
    required this.flipped,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, anim) =>
          FadeTransition(opacity: anim, child: child),
      child: flipped
          ? Card(
              key: const ValueKey('back'),
              color: theme.colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: SingleChildScrollView(
                    child: Text(
                      back,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Card(
              key: const ValueKey('front'),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (hint != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.tertiaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '💡 $hint',
                            style: TextStyle(
                              color:
                                  theme.colorScheme.onTertiaryContainer,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                      Text(
                        front,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Tippe zum Aufdecken',
                        style: TextStyle(
                          color:
                              theme.colorScheme.onSurface.withOpacity(0.5),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class _GradeButtons extends StatelessWidget {
  final FlashCard current;
  final Function(int) onGrade;
  const _GradeButtons({required this.current, required this.onGrade});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: _GradeButton(
            label: 'Again',
            subtitle: '${SM2Algorithm.previewIntervalDays(current, 1)}d',
            color: const Color(0xFFEF4444),
            onPressed: () => onGrade(1),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _GradeButton(
            label: 'Hard',
            subtitle: '${SM2Algorithm.previewIntervalDays(current, 3)}d',
            color: const Color(0xFFF59E0B),
            onPressed: () => onGrade(3),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _GradeButton(
            label: 'Good',
            subtitle: '${SM2Algorithm.previewIntervalDays(current, 4)}d',
            color: const Color(0xFF10B981),
            onPressed: () => onGrade(4),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _GradeButton(
            label: 'Easy',
            subtitle: '${SM2Algorithm.previewIntervalDays(current, 5)}d',
            color: theme.colorScheme.primary,
            onPressed: () => onGrade(5),
          ),
        ),
      ],
    );
  }
}

class _GradeButton extends StatelessWidget {
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onPressed;
  const _GradeButton({
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.white)),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
