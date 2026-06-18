import 'package:expense_tracker/core/debug/demo_data_seeder.dart';
import 'package:expense_tracker/core/presentation/providers/analytics_consent_provider.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/configuration/analytics_manager.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/core/presentation/common/custom_form_switch.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
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
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.privacy),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.only(left: 16.0, right: 16, top: 8),
        child: ListView(
          children: [
            Text(
              appLocalizations.privacyIntroduction,
              style: textTheme.bodyLarge?.copyWith(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            _buildPrivacyAssurance(appLocalizations, colors, textTheme),
            const SizedBox(height: 24),
            CustomFormSwitch(
              label: appLocalizations.essentialDataOptionTitle,
              subtitle: appLocalizations.essentialDataOptionDescription,
              value: true,
              onChanged: null,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(
                height: 1,
              ),
            ),
            CustomFormSwitch(
              label: appLocalizations.analyticsOptionTitle,
              subtitle: appLocalizations.analyticsOptionDescription,
              value: consent ?? false,
              onChanged: (value) {
                ref
                    .read(analyticsConsentProvider.notifier)
                    .updateConsent(value);
              },
            ),
            if (kDebugMode) ...[
              const SizedBox(
                height: 32,
              ),
              Text(
                "Debug",
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => AnalyticsManager.crashApp(),
                  icon: const Icon(Icons.bug_report),
                  label: Text(appLocalizations.crashTest),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.expense,
                    foregroundColor: colors.onPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const DemoDataSeedButton(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyAssurance(AppLocalizations appLocalizations,
      AppColors colors, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Row(
            spacing: 8,
            children: [
              Icon(Icons.privacy_tip, color: colors.primary, size: 20),
              Text(
                appLocalizations.privacyAssuranceLabel,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.primary,
                ),
              ),
            ],
          ),
          Text(
            appLocalizations.privacyAssurance,
            style: textTheme.bodyMedium?.copyWith(
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
