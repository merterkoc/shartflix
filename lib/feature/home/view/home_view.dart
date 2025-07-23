import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shartflix/core/settings/settings_controller.dart';
import 'package:shartflix/ui/app_ui.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Text(context.l10n.app_name),
              ElevatedButton(
                onPressed: () {
                  GetIt.instance<SettingsController>().updateThemeMode(
                    GetIt.instance<SettingsController>().themeMode ==
                            Brightness.dark
                        ? Brightness.light
                        : Brightness.dark,
                  );
                },
                child: const Text('teme'),
              ),
              ElevatedButton(
                onPressed: () {
                  GetIt.instance<SettingsController>().updateThemeStyle(
                    (GetIt.instance<SettingsController>().themeStyle + 1) % 4,
                  );
                },
                child: const Text('theme style'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
