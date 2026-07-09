import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/flash_card.dart';
import '../providers/deck_provider.dart';

/// Deck-Detail: Karten-Liste + Study-Button.
class DeckDetailScreen extends StatelessWidget {
  final String deckId;
  const DeckDetailScreen({super.key, required this.deckId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<DeckProvider>();
    final deck = provider.deckById(deckId);
    if (deck == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Deck nicht gefunden')),
      );
    }
    final cards = provider.cardsForDeck(deckId);
    final due = provider.dueCardsForDeck(deckId).length;
    final color = Color(deck.colorValue);

    return Scaffold(
      appBar: AppBar(
        title: Text(deck.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Deck löschen?'),
                  content: const Text(
                      'Dieses Deck und alle Karten werden dauerhaft gelöscht.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Abbrechen'),
                    ),
                    FilledButton.tonal(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Löschen'),
                    ),
                  ],
                ),
              );
              if (ok == true && context.mounted) {
                provider.deleteDeck(deckId);
                context.pop();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(deck.emoji, style: const TextStyle(fontSize: 36)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        deck.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withOpacity(0.7),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _MiniStat(label: 'Karten', value: '${deck.totalCards}'),
                    const SizedBox(width: 8),
                    _MiniStat(
                        label: 'Fällig', value: '$due', highlight: due > 0),
                    const SizedBox(width: 8),
                    _MiniStat(
                        label: 'Gelernt', value: '${deck.learnedCards}'),
                    const SizedBox(width: 8),
                    _MiniStat(
                        label: 'Quote',
                        value:
                            '${(deck.averageAccuracy * 100).toStringAsFixed(0)}%'),
                  ],
                ),
                if (due > 0) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () =>
                          context.push('/deck/$deckId/study'),
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: Text('$due Karten lernen'),
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Cards header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  'Karten (${cards.length})',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () =>
                      context.push('/deck/$deckId/add-card'),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Hinzufügen'),
                ),
              ],
            ),
          ),
          // Cards list
          Expanded(
            child: cards.isEmpty
                ? const _EmptyCardsState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                    itemCount: cards.length,
                    itemBuilder: (context, i) => _CardRow(card: cards[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;
  const _MiniStat({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: highlight
              ? theme.colorScheme.primary
              : Colors.white.withOpacity(0.6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                color: highlight ? Colors.white : null,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: highlight
                    ? Colors.white70
                    : theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardRow extends StatelessWidget {
  final FlashCard card;
  const _CardRow({required this.card});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(top: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: card.isDue
              ? theme.colorScheme.primary
              : theme.colorScheme.primary.withOpacity(0.2),
          child: Text(
            card.isDue ? '→' : '✓',
            style: TextStyle(
              color: card.isDue
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          card.front,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          card.back,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        trailing: Text(
          card.isNew
              ? 'NEU'
              : 'Tag ${card.intervalDays}',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: card.isNew
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}

class _EmptyCardsState extends StatelessWidget {
  const _EmptyCardsState();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🃏', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text(
            'Noch keine Karten',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Füge deine erste Karte hinzu.',
            style: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
