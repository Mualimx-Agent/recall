import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/deck_provider.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const RecallApp());
}

class RecallApp extends StatelessWidget {
  const RecallApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DeckProvider(),
      child: MaterialApp.router(
        title: 'Recall',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
