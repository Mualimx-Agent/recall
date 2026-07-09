import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/deck_provider.dart';

/// Form: Neues Deck erstellen.
class AddDeckScreen extends StatefulWidget {
  const AddDeckScreen({super.key});

  @override
  State<AddDeckScreen> createState() => _AddDeckScreenState();
}

class _AddDeckScreenState extends State<AddDeckScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _emoji = '📚';
  int _color = 0xFF4F46E5;

  static const _emojis = ['📚', '🇬🇧', '💻', '🏛️', '🔬', '🎨', '🎵', '🧪', '🌍', '🧠'];
  static const _colors = [
    0xFF4F46E5, // Indigo
    0xFF059669, // Emerald
    0xFFDC2626, // Red
    0xFFEA580C, // Orange
    0xFF7C3AED, // Purple
    0xFFDB2777, // Pink
    0xFF0891B2, // Cyan
    0xFF65A30D, // Lime
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    context.read<DeckProvider>().createDeck(
          name: _nameCtrl.text.trim(),
          description: _descCtrl.text.trim().isEmpty
              ? 'Eigene Karteikarten'
              : _descCtrl.text.trim(),
          emoji: _emoji,
          colorValue: _color,
        );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Deck erstellt ✓')),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Neues Deck')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Name', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                hintText: 'z.B. "Spanisch Vokabeln"',
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Bitte Name eingeben'
                  : null,
            ),
            const SizedBox(height: 24),
            Text('Beschreibung (optional)',
                style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descCtrl,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'Worum geht es in diesem Deck?',
              ),
            ),
            const SizedBox(height: 24),
            Text('Icon', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _emojis
                  .map((e) => GestureDetector(
                        onTap: () => setState(() => _emoji = e),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: _emoji == e
                                ? Color(_color).withOpacity(0.2)
                                : theme.colorScheme.surface,
                            border: Border.all(
                              color: _emoji == e
                                  ? Color(_color)
                                  : theme.colorScheme.outline
                                      .withOpacity(0.3),
                              width: _emoji == e ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(e,
                                style: const TextStyle(fontSize: 24)),
                          ),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 24),
            Text('Farbe', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _colors
                  .map((c) => GestureDetector(
                        onTap: () => setState(() => _color = c),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(c),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _color == c
                                  ? theme.colorScheme.onSurface
                                  : Colors.transparent,
                              width: 3,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.add),
              label: const Text('Deck erstellen'),
            ),
          ],
        ),
      ),
    );
  }
}
