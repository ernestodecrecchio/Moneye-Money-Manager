import 'package:expense_tracker/application/common/notifiers/analytics_consent_provider.dart';
import 'package:expense_tracker/application/common/notifiers/app_localizations_provider.dart';
import 'package:expense_tracker/configuration/analytics_manager.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrivacySettingsPage extends ConsumerWidget {
  static const String routeName = '/privacy-settings';

  const PrivacySettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final consent = ref.watch(analyticsConsentProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.privacy),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              appLocalizations.privacyIntroduction,
              style: const TextStyle(
                fontSize: 16,
                color: CustomColors.darkBlue,
              ),
            ),
          ),
          _buildPrivacyAssurance(appLocalizations),
          const SizedBox(height: 8),
          _buildSettingsSection(
            context,
            title: appLocalizations.essentialTitle,
            description: appLocalizations.essentialDescription,
            value: true,
            isLocked: true,
            onChanged: null,
          ),
          const Divider(height: 1),
          _buildSettingsSection(
            context,
            title: appLocalizations.analyticsTitle,
            description: appLocalizations.analyticsDescription,
            value: consent ?? false,
            isLocked: false,
            onChanged: (value) {
              ref.read(analyticsConsentProvider.notifier).updateConsent(value);
            },
          ),
          if (kDebugMode) ...[
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 32, 16, 8),
              child: Text(
                "Debug",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: CustomColors.darkBlue,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => AnalyticsManager.crashApp(),
                  icon: const Icon(Icons.bug_report),
                  label: Text(appLocalizations.crashTest),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPrivacyAssurance(AppLocalizations appLocalizations) {
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
              const Icon(Icons.privacy_tip, color: CustomColors.blue, size: 20),
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
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context, {
    required String title,
    required String description,
    required bool value,
    required bool isLocked,
    required ValueChanged<bool>? onChanged,
  }) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          description,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
        ),
      ),
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
