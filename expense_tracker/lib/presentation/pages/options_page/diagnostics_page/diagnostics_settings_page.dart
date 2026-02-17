import 'package:expense_tracker/application/common/notifiers/analytics_consent_provider.dart';
import 'package:expense_tracker/application/common/notifiers/app_localizations_provider.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiagnosticsSettingsPage extends ConsumerWidget {
  static const String routeName = '/diagnostics-settings';

  const DiagnosticsSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final consent = ref.watch(analyticsConsentProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.analytics),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              appLocalizations.analyticsDescription,
              style: const TextStyle(
                fontSize: 16,
                color: CustomColors.darkBlue,
              ),
            ),
          ),
          _buildPrivacyNote(context, appLocalizations),
          const Divider(),
          SwitchListTile(
            activeThumbColor: CustomColors.blue,
            title: Text(appLocalizations.analytics),
            subtitle: Text(appLocalizations.analyticsOptionDescription),
            value: consent ?? false,
            onChanged: (value) {
              ref.read(analyticsConsentProvider.notifier).updateConsent(value);
            },
          ),
          const Divider(),
          if (kDebugMode) _buildDebugSection(appLocalizations),
        ],
      ),
    );
  }

  Widget _buildPrivacyNote(
      BuildContext context, AppLocalizations appLocalizations) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CustomColors.blue.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CustomColors.blue.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.security, color: CustomColors.blue, size: 20),
              const SizedBox(width: 8),
              Text(
                appLocalizations.privacyAssuranceLabel,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: CustomColors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            appLocalizations.privacyAssurance,
            style: const TextStyle(fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 16),
          _buildTrackingList(
            appLocalizations.whatIsTracked,
            [appLocalizations.usageData, appLocalizations.crashReports],
            Icons.check_circle_outline,
            Colors.green,
          ),
          const SizedBox(height: 12),
          _buildTrackingList(
            appLocalizations.whatIsNotTracked,
            [appLocalizations.personalInfo, appLocalizations.transactionData],
            Icons.remove_circle_outline,
            Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingList(
      String title, List<String> items, IconData icon, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Icon(icon, size: 14, color: color),
                  const SizedBox(width: 6),
                  Text(item, style: const TextStyle(fontSize: 13)),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildDebugSection(AppLocalizations appLocalizations) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Debug",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: CustomColors.darkBlue,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => throw Exception("Test Crash"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text("Test Crashlytics Crash"),
            ),
          ),
        ],
      ),
    );
  }
}
