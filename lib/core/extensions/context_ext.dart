import 'package:flutter/widgets.dart';
import 'package:shartflix/app_ui/app_ui.dart';

extension ContextExt on BuildContext {
  AppLocalizations get l10n {
    return AppLocalizations.of(this)!;
  }
}
