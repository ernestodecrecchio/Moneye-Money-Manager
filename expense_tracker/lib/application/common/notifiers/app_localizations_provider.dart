import 'dart:io';

import 'package:expense_tracker/application/common/notifiers/locale_provider.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Provider that returns the [AppLocalizations] instance for the current application locale.
///
/// This provider watches [localeProvider] and automatically updates when the language changes.
/// By using this provider, widgets can access localized strings without needing a [BuildContext],
/// which is useful in non-UI classes or when building complex widget trees.
///
/// Example usage:
/// ```dart
/// final appLocalizations = ref.watch(appLocalizationsProvider);
/// return Text(appLocalizations.helloWorld);
/// ```
final appLocalizationsProvider = Provider<AppLocalizations>((ref) {
  final locale = ref.watch(localeProvider);

  // If locale is null, it defaults to the system locale.
  if (locale == null) {
    final systemLocaleCode = Intl.shortLocale(Platform.localeName);

    final isSupported =
        L10n.all.any((element) => element.languageCode == systemLocaleCode);

    if (isSupported) {
      return lookupAppLocalizations(Locale(systemLocaleCode));
    }

    // English 'en' is used as the fallback default if no system locale matches.
    return lookupAppLocalizations(const Locale('en'));
  }

  return lookupAppLocalizations(locale);
});
