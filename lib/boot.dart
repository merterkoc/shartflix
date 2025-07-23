import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shartflix/core/cache/shared_preferences.dart';
import 'package:shartflix/core/environment_manager/environment_manager.dart';
import 'package:shartflix/core/settings/settings_controller.dart';
import 'package:shartflix/core/settings/settings_service.dart';

class BootService {
  BootService._();

  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    GetIt.instance.registerSingleton<SettingsController>(
      SettingsController(SettingsService()),
    );

    await Shared().init();
    await Future.wait([
          GetIt.instance<SettingsController>().loadSettings(),
          EnvironmentManager().init(),
        ])
        .then((_) {
          debugPrint('BootService initialized successfully.');
        })
        .catchError((dynamic error) {
          debugPrint('BootService initialization failed: $error');
        });
  }
}
