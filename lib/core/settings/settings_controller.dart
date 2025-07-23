import 'package:flutter/cupertino.dart';

import 'package:shartflix/core/settings/settings_service.dart';

class SettingsController with ChangeNotifier {
  SettingsController(this._settingsService);

  final SettingsService _settingsService;

  late Brightness _themeMode;

  late int _themeStyle;

  Brightness get themeMode => _themeMode;

  int get themeStyle => _themeStyle;

  Future<void>  loadSettings() async {
    _themeMode = await _settingsService.themeMode();
    _themeStyle = await _settingsService.themeStyle();

    notifyListeners();
  }

  Future<void> updateThemeMode(Brightness? newThemeMode) async {
    if (newThemeMode == null) return;

    if (newThemeMode == _themeMode) return;

    _themeMode = newThemeMode;

    notifyListeners();

    await _settingsService.updateThemeMode(newThemeMode);
    debugPrint(
      'ThemeMode updated to ${newThemeMode.toString().split('.').last}',
    );
  }

  Future<void> updateThemeStyle(int newThemeStyle) async {
    if (newThemeStyle == _themeStyle) return;

    _themeStyle = newThemeStyle;
    notifyListeners();
    await _settingsService.updateThemeStyle(_themeStyle);
    debugPrint('ThemeStyle updated to $_themeStyle');
  }

  Future<void> setDefaultThemeMode() async {
    _themeMode = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    notifyListeners();
    _settingsService.updateDefaultThemeMode();
  }

  Future<void> listenToThemeMode() async {
    _themeMode = await _settingsService.themeMode();
    notifyListeners();
  }
}
