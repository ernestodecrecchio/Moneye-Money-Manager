import 'package:expense_tracker/application/common/notifiers/analytics_consent_provider.dart';
import 'package:expense_tracker/application/common/notifiers/app_localizations_provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnalyticsManager {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static bool _enabled = false;

  static final FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: _analytics);

  /// Shows the analytics consent dialog.
  static void showConsentDialog({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    final appLocalizations = ref.read(appLocalizationsProvider);

    showAdaptiveDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog.adaptive(
        title: Text(appLocalizations.analyticsTitle),
        content: Text(appLocalizations.analyticsDescription),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(analyticsConsentProvider.notifier).updateConsent(false);
              Navigator.of(context).pop();
            },
            child: Text(appLocalizations.decline),
          ),
          TextButton(
            onPressed: () {
              ref.read(analyticsConsentProvider.notifier).updateConsent(true);
              Navigator.of(context).pop();
            },
            child: Text(appLocalizations.accept),
          ),
        ],
      ),
    );
  }

  /// Logs a custom event.
  static Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    if (!_enabled) return;

    await _analytics.logEvent(
      name: name,
      parameters: parameters,
    );
  }

  /// Logs when the user adds a new transaction.
  static Future<void> logTransactionAdded() async {
    await logEvent(
      name: 'add_transaction',
    );
  }

  /// Logs when the user updates a transaction.
  static Future<void> logTransactionUpdated() async {
    await logEvent(
      name: 'update_transaction',
    );
  }

  /// Logs when the user deletes a transaction.
  static Future<void> logTransactionDeleted() async {
    await logEvent(name: 'delete_transaction');
  }

  /// Logs when the user creates a new account.
  static Future<void> logAccountCreated() async {
    await logEvent(
      name: 'create_account',
    );
  }

  /// Logs when the user changes the app language.
  static Future<void> logLanguageChanged(String languageCode) async {
    await logEvent(
      name: 'change_language',
      parameters: {
        'language': languageCode,
      },
    );
  }

  /// Logs when the user changes the currency.
  static Future<void> logCurrencyChanged(String currencyCode) async {
    await logEvent(
      name: 'change_currency',
      parameters: {
        'currency': currencyCode,
      },
    );
  }

  /// Logs a screen view manually if needed.
  static Future<void> logScreenView({required String screenName}) async {
    if (!_enabled) return;
    await _analytics.logScreenView(screenName: screenName);
  }

  /// Enables or disables analytics collection.
  static Future<void> setAnalyticsCollectionEnabled(bool enabled) async {
    _enabled = enabled;
    await _analytics.setAnalyticsCollectionEnabled(enabled);
  }

  /// Forces a crash to test Crashlytics integration.
  static void crashApp() {
    FirebaseCrashlytics.instance.crash();
  }
}
