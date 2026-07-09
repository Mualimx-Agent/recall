import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 3-Schritt-Onboarding (Wertversprechen, Demo-Daten, Start).
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  final _pages = const [
    _OnboardingPageData(
      emoji: '🧠',
      title: 'Lerne smarter, nicht härter',
      body:
          'Recall nutzt den SM-2 Algorithmus – die gleiche Methode wie Anki, aber mit einer modernen Oberfläche, die sich anfühlt wie 2026.',
    ),
    _OnboardingPageData(
      emoji: '📚',
      title: '4 Demo-Decks inklusive',
      body:
          'Starte sofort mit Englisch, Programmierung, Geschichte und Naturwissenschaft. Insgesamt 30 Karten, vollständig spielbar.',
    ),
    _OnboardingPageData(
      emoji: '🔒',
      title: '100% lokal & privat',
      body:
          'Keine Cloud, keine Tracker, keine Accounts. Deine Karten bleiben auf deinem Gerät. Open Source, faire Preise.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip-Button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => context.go('/home'),
                child: const Text('Überspringen'),
              ),
            ),
            // Pages
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, idx) {
                  final p = _pages[idx];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(p.emoji, style: const TextStyle(fontSize: 96)),
                        const SizedBox(height: 32),
                        Text(
                          p.title,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          p.body,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withOpacity(0.7),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Dots indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _page == i ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _page == i
                        ? theme.colorScheme.primary
                        : theme.colorScheme.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Action button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (_page < _pages.length - 1) {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      context.go('/home');
                    }
                  },
                  child: Text(
                    _page < _pages.length - 1 ? 'Weiter' : 'Loslegen',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPageData {
  final String emoji;
  final String title;
  final String body;
  const _OnboardingPageData({
    required this.emoji,
    required this.title,
    required this.body,
  });
}
