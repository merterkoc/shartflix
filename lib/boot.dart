import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shartflix/core/cache/shared_preferences.dart';
import 'package:shartflix/core/environment_manager/environment_manager.dart';
import 'package:shartflix/core/settings/settings_controller.dart';
import 'package:shartflix/core/settings/settings_service.dart';
import 'package:shartflix/http/dio/token_storage/token_storage.dart';

class BootService {
  BootService._();

  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    GetIt.instance.registerSingleton<SettingsController>(
      SettingsController(SettingsService()),
    );

    await Shared().init().whenComplete(() async {
      await Future.wait([
            GetIt.instance<SettingsController>().loadSettings(),
            EnvironmentManager().init(),
            TokenStorageImpl().init(),
          ])
          .then((_) {
            debugPrint('BootService initialized successfully.');
          })
          .catchError((dynamic error) {
            debugPrint('BootService initialization failed: $error');
          });
    });
  }
}
