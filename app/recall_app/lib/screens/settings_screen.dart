import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _haptics = true;
  String _language = 'de';
  int _dailyGoal = 20;
  bool _onboardingDone = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Einstellungen')),
      body: ListView(
        children: [
          _SectionHeader('Lernen'),
          SwitchListTile(
            title: const Text('Dunkler Modus'),
            subtitle: const Text('Schont die Augen bei langen Sessions'),
            value: _darkMode,
            onChanged: (v) => setState(() => _darkMode = v),
          ),
          ListTile(
            title: const Text('Tagesziel'),
            subtitle: Text('$_dailyGoal Karten pro Tag'),
            trailing: SizedBox(
              width: 200,
              child: Slider(
                value: _dailyGoal.toDouble(),
                min: 5,
                max: 100,
                divisions: 19,
                label: '$_dailyGoal',
                onChanged: (v) => setState(() => _dailyGoal = v.toInt()),
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Haptisches Feedback'),
            subtitle: const Text('Vibration beim Bewerten'),
            value: _haptics,
            onChanged: (v) => setState(() => _haptics = v),
          ),
          const Divider(),
          _SectionHeader('Sprache'),
          RadioListTile<String>(
            title: const Text('Deutsch'),
            value: 'de',
            groupValue: _language,
            onChanged: (v) => setState(() => _language = v!),
          ),
          RadioListTile<String>(
            title: const Text('English'),
            value: 'en',
            groupValue: _language,
            onChanged: (v) => setState(() => _language = v!),
          ),
          const Divider(),
          _SectionHeader('Daten'),
          ListTile(
            leading: const Icon(Icons.file_download_outlined),
            title: const Text('Decks importieren (CSV)'),
            subtitle: const Text('Bald verfügbar'),
            enabled: false,
          ),
          ListTile(
            leading: const Icon(Icons.upload_outlined),
            title: const Text('Decks exportieren'),
            subtitle: const Text('Bald verfügbar'),
            enabled: false,
          ),
          ListTile(
            leading: const Icon(Icons.refresh),
            title: const Text('Onboarding erneut ansehen'),
            onTap: () {
              setState(() => _onboardingDone = false);
              context.go('/');
            },
          ),
          const Divider(),
          _SectionHeader('Über'),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Über Recall'),
            onTap: () => context.push('/about'),
          ),
          const SizedBox(height: 40),
          Center(
            child: Text(
              'Recall v1.0.0',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.4),
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.primary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
