import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/deck_provider.dart';

/// Form: Neue Karte zu einem Deck hinzufügen.
class AddCardScreen extends StatefulWidget {
  final String deckId;
  const AddCardScreen({super.key, required this.deckId});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _frontCtrl = TextEditingController();
  final _backCtrl = TextEditingController();
  final _hintCtrl = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _frontCtrl.dispose();
    _backCtrl.dispose();
    _hintCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    context.read<DeckProvider>().addCardToDeck(
          deckId: widget.deckId,
          front: _frontCtrl.text.trim(),
          back: _backCtrl.text.trim(),
          hint: _hintCtrl.text.trim().isEmpty ? null : _hintCtrl.text.trim(),
        );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Karte hinzugefügt ✓')),
    );
    _frontCtrl.clear();
    _backCtrl.clear();
    _hintCtrl.clear();
    setState(() => _saving = false);
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Neue Karte'),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: const Text('Speichern'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Front
            Text('Vorderseite (Frage)', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            TextFormField(
              controller: _frontCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'z.B. "Was bedeutet API?"',
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Bitte Vorderseite eingeben'
                  : null,
            ),
            const SizedBox(height: 24),
            // Back
            Text('Rückseite (Antwort)', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            TextFormField(
              controller: _backCtrl,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'z.B. "Application Programming Interface – ..."',
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Bitte Rückseite eingeben'
                  : null,
            ),
            const SizedBox(height: 24),
            // Hint (optional)
            Text('Tipp (optional)',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                )),
            const SizedBox(height: 8),
            TextFormField(
              controller: _hintCtrl,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'z.B. "Wichtige Reise-Frage"',
              ),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: const Icon(Icons.add),
              label: const Text('Karte hinzufügen'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => context.pop(),
              child: const Text('Zurück zum Deck'),
            ),
          ],
        ),
      ),
    );
  }
}
