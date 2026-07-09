import 'package:go_router/go_router.dart';

import '../screens/about_screen.dart';
import '../screens/add_card_screen.dart';
import '../screens/add_deck_screen.dart';
import '../screens/deck_detail_screen.dart';
import '../screens/home_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/stats_screen.dart';
import '../screens/study_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/deck/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return DeckDetailScreen(deckId: id);
        },
      ),
      GoRoute(
        path: '/deck/:id/study',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return StudyScreen(deckId: id);
        },
      ),
      GoRoute(
        path: '/deck/:id/add-card',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return AddCardScreen(deckId: id);
        },
      ),
      GoRoute(
        path: '/add-deck',
        builder: (context, state) => const AddDeckScreen(),
      ),
      GoRoute(
        path: '/stats',
        builder: (context, state) => const StatsScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) => const AboutScreen(),
      ),
    ],
  );
}
