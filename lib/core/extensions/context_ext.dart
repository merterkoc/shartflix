import 'package:flutter/material.dart';
import 'package:shartflix/core/l10n/generated/app_localizations.dart';

extension ContextExt on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
