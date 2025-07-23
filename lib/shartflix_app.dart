import 'package:flutter/material.dart';
import 'package:shartflix/app_ui/app_ui.dart';
import 'package:shartflix/core/theme/blue/blue_theme.dart';

class ShartflixApp extends StatelessWidget {
  const ShartflixApp({super.key});

  @override
  Widget build(BuildContext context) {
    const textTheme = TextTheme();
    return MaterialApp(
      theme: const BlueMaterialTheme(textTheme).light(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(context.l10n.app_name)),
    );
  }
}
