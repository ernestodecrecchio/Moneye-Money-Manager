import 'package:expense_tracker/application/common/notifiers/locale_provider.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  // AppLocalizations.delegate handles async loading, but for synchronous access
  // in providers, we use lookupAppLocalizations to get the immediate instance.
  if (locale == null) {
    // English 'en' is used as the fallback default if no system locale matches.
    return lookupAppLocalizations(const Locale('en'));
  }

  return lookupAppLocalizations(locale);
});
