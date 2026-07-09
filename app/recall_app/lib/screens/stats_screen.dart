import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/deck_provider.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stats = context.watch<DeckProvider>().stats;
    final sessions = context.watch<DeckProvider>().recentSessions;

    return Scaffold(
      appBar: AppBar(title: const Text('Statistiken')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Top stats grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: [
              _StatBox(
                emoji: '🔥',
                label: 'Streak',
                value: '${stats.currentStreakDays} Tage',
                sub: 'Längster: ${stats.longestStreakDays}',
                color: const Color(0xFFFEF3C7),
              ),
              _StatBox(
                emoji: '📚',
                label: 'Decks',
                value: '${stats.totalDecks}',
                sub: '${stats.totalCards} Karten total',
                color: const Color(0xFFDBEAFE),
              ),
              _StatBox(
                emoji: '✅',
                label: 'Gelernt',
                value: '${stats.cardsLearned}',
                sub: 'repetitions ≥ 2',
                color: const Color(0xFFD1FAE5),
              ),
              _StatBox(
                emoji: '🎯',
                label: 'Genauigkeit',
                value: '${(stats.overallAccuracy * 100).toStringAsFixed(0)}%',
                sub: '${stats.totalReviews} Reviews total',
                color: const Color(0xFFFCE7F3),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Last 7 days placeholder
          Text(
            'Letzte 7 Tage',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (i) {
                final heights = [12.0, 24.0, 18.0, 32.0, 28.0, 20.0, 16.0];
                return Column(
                  children: [
                    Container(
                      width: 24,
                      height: heights[i],
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'][i],
                      style: TextStyle(
                        fontSize: 10,
                        color: theme.colorScheme.onPrimaryContainer
                            .withOpacity(0.6),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
          const SizedBox(height: 24),
          // Recent sessions
          Text(
            'Letzte Sessions',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          if (sessions.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'Noch keine Sessions. Starte eine Lernrunde!',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ),
            )
          else
            ...sessions.take(5).map(
                  (s) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Text('📖',
                          style: TextStyle(fontSize: 28)),
                      title: Text(
                        '${s.cardsStudied} Karten · '
                        '${(s.accuracy * 100).toStringAsFixed(0)}% richtig',
                      ),
                      subtitle: Text(
                        '${s.endedAt?.day}.${s.endedAt?.month}.${s.endedAt?.year} · '
                        '${s.duration.inMinutes} Min',
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final String sub;
  final Color color;
  const _StatBox({
    required this.emoji,
    required this.label,
    required this.value,
    required this.sub,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const Spacer(),
          Text(label,
              style: TextStyle(
                fontSize: 11,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              )),
          Text(value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              )),
          Text(sub,
              style: TextStyle(
                fontSize: 10,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              )),
        ],
      ),
    );
  }
}
