import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Über Recall')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Center(
            child: Text('🧠', style: TextStyle(fontSize: 80)),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Recall',
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Center(
            child: Text(
              'Version 1.0.0',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
          const SizedBox(height: 32),
          const _Paragraph(
            'Recall ist ein moderner Karteikarten-Lernbegleiter. '
            'Wir nutzen den SM-2 Algorithmus (die gleiche Methode wie Anki), '
            'aber mit einer Oberfläche, die sich 2026 anfühlt.',
          ),
          const _Heading('Was uns anders macht'),
          const _Bullet('Keine Abo-Falle: einmaliger Kauf, keine versteckten Kosten.'),
          const _Bullet('100% lokal: Deine Karten bleiben auf deinem Gerät.'),
          const _Bullet('Keine Tracker: Keine Analytics, keine Werbung.'),
          const _Bullet('Open Source: Du kannst den Code prüfen.'),
          const _Bullet('Faire Preise: Wir nehmen, was wir brauchen – nicht mehr.'),
          const SizedBox(height: 16),
          const _Heading('Datenschutz'),
          const _Paragraph(
            'Recall sammelt keinerlei persönliche Daten. Es gibt keinen Account, '
            'keine Cloud-Synchronisation, keine Telemetrie. Deine Lern-Fortschritte '
            'werden ausschliesslich lokal auf deinem Gerät gespeichert.',
          ),
          const _Heading('Open Source'),
          const _Paragraph(
            'Recall ist unter der Apache 2.0 Lizenz veröffentlicht. '
            'Du kannst den Quellcode einsehen, verändern und weitergeben.',
          ),
          const _Heading('Kontakt'),
          const _Paragraph(
            'Fragen oder Feedback? Schreib uns an apps@mualimx.com\n'
            'Mehr Info: mualimx.com',
          ),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: () => context.pop(),
            child: const Text('Zurück'),
          ),
        ],
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  final String text;
  const _Heading(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _Paragraph extends StatelessWidget {
  final String text;
  const _Paragraph(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(height: 1.5),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(text, style: const TextStyle(height: 1.4))),
        ],
      ),
    );
  }
}
