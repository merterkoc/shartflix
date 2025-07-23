import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shartflix/core/router/go_router.dart';
import 'package:shartflix/core/settings/settings_controller.dart';
import 'package:shartflix/core/theme/blue/blue_theme.dart';
import 'package:shartflix/core/theme/default/default_theme.dart';
import 'package:shartflix/core/theme/green/green_theme.dart';
import 'package:shartflix/core/theme/material_theme.dart';
import 'package:shartflix/core/theme/pink/pink_theme.dart';
import 'package:shartflix/feature/login/bloc/user_bloc.dart';
import 'package:shartflix/repository/user_repository.dart';
import 'package:shartflix/ui/app_ui.dart';

class ShartflixApp extends StatelessWidget {
  const ShartflixApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = GetIt.instance<SettingsController>();

    return BlocProvider<UserBloc>(
      create: (context) => UserBloc(
        userRepository: UserRepository(),
      ),
      child: ListenableBuilder(
        listenable: GetIt.instance<SettingsController>(),
        builder: (BuildContext context, Widget? child) {
          final themeMap = <int, MaterialTheme>{
            0: const DefaultMaterialTheme(),
            1: const BlueMaterialTheme(),
            2: const GreenMaterialTheme(),
            3: const PinkMaterialTheme(),
          };

          final theme =
              themeMap[settingsController.themeStyle] ??
              const DefaultMaterialTheme();

          return MaterialApp.router(
            routerConfig: AppRouter().router,
            themeMode: settingsController.themeMode == Brightness.dark
                ? ThemeMode.dark
                : ThemeMode.light,
            theme: settingsController.themeMode == Brightness.light
                ? theme.light()
                : theme.dark(),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
          );
        },
      ),
    );
  }
}
