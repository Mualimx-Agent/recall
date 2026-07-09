import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/deck.dart';
import '../providers/deck_provider.dart';

/// Home: Deck-Liste + Stats-Header.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<DeckProvider>();
    final stats = provider.stats;
    final decks = provider.decks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recall'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_outlined),
            tooltip: 'Statistiken',
            onPressed: () => context.push('/stats'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Einstellungen',
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Stats-Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: _StatsHeader(stats: stats),
            ),
          ),
          // Decks Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Row(
                children: [
                  Text(
                    'Deine Decks',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${decks.length} Decks · ${stats.totalCards} Karten',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Deck list
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index == decks.length) {
                    return const SizedBox(height: 80);
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _DeckCard(deck: decks[index]),
                  );
                },
                childCount: decks.length + 1,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add-deck'),
        icon: const Icon(Icons.add),
        label: const Text('Neues Deck'),
      ),
    );
  }
}

class _StatsHeader extends StatelessWidget {
  final dynamic stats;
  const _StatsHeader({required this.stats});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🔥', style: TextStyle(fontSize: 28)),
              const SizedBox(width: 8),
              Text(
                '${stats.currentStreakDays} Tage Streak',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatPill(
                  label: 'Heute',
                  value: '${stats.reviewsToday}',
                  sub: 'Karten',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatPill(
                  label: 'Gelernt',
                  value: '${stats.cardsLearned}',
                  sub: 'Karten',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatPill(
                  label: 'Quote',
                  value: '${(stats.overallAccuracy * 100).toStringAsFixed(0)}%',
                  sub: 'Richtig',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
  const _StatPill({
    required this.label,
    required this.value,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            sub,
            style: const TextStyle(color: Colors.white70, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _DeckCard extends StatelessWidget {
  final Deck deck;
  const _DeckCard({required this.deck});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = Color(deck.colorValue);

    return Card(
      child: InkWell(
        onTap: () => context.push('/deck/${deck.id}'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    deck.emoji,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      deck.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      deck.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _Chip(
                          label: '${deck.totalCards} Karten',
                          color: theme.colorScheme.surface,
                          textColor: theme.colorScheme.onSurface,
                        ),
                        const SizedBox(width: 6),
                        if (deck.dueCards > 0)
                          _Chip(
                            label: '${deck.dueCards} fällig',
                            color: theme.colorScheme.primary,
                            textColor: theme.colorScheme.onPrimary,
                          )
                        else
                          _Chip(
                            label: '✓ aktuell',
                            color: const Color(0xFFD1FAE5),
                            textColor: const Color(0xFF065F46),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurface.withOpacity(0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  const _Chip({
    required this.label,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
