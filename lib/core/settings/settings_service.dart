import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:shartflix/core/cache/shared_preferences.dart';

class SettingsService {
  factory SettingsService() => _instance;

  SettingsService._();

  static final SettingsService _instance = SettingsService._();

  Future<Brightness> themeMode() async {
    final theme = Shared().getInt('theme');
    if (theme == null || theme.isNegative || theme > Brightness.values.length) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness;
    }
    return Brightness.values[theme];
  }

  Future<int> themeStyle() async {
    final themeStyle = Shared().getInt('themeStyle');
    if (themeStyle == null || themeStyle.isNegative) {
      if (themeStyle == null) {
        final randomTheme = Random().nextInt(4);
        unawaited(updateThemeStyle(randomTheme));
        return randomTheme;
      }
      return 1;
    }
    return themeStyle;
  }

  Future<void> updateThemeStyle(int themeStyle) async {
    await Shared().setInt('themeStyle', themeStyle);
  }

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(Brightness theme) async {
    await Shared().setInt('theme', theme.index);
  }

  void updateDefaultThemeMode() {
    Shared().remove('theme');
  }
}
