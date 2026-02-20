import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expense_tracker/configuration/analytics_manager.dart';

class AnalyticsConsentNotifier extends Notifier<bool?> {
  static const String consentKey = 'analytics_consent';

  @override
  bool? build() {
    return null;
  }

  void setFromLocalStorage(bool? localStorageValue) {
    state = localStorageValue;
    // Disable collection if debug mode or consent is null (undecided) or false (refused)
    AnalyticsManager.setAnalyticsCollectionEnabled(
        kDebugMode ? false : localStorageValue ?? false);
  }

  Future<void> updateConsent(bool consent) async {
    state = consent;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(consentKey, consent);
    await AnalyticsManager.setAnalyticsCollectionEnabled(consent);
  }
}

final analyticsConsentProvider =
    NotifierProvider<AnalyticsConsentNotifier, bool?>(() {
  return AnalyticsConsentNotifier();
});
