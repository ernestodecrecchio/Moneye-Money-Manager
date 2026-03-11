import 'package:expense_tracker/application/common/notifiers/analytics_consent_provider.dart';
import 'package:expense_tracker/application/common/notifiers/app_localizations_provider.dart';
import 'package:expense_tracker/configuration/analytics_manager.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/style/app_theme.dart';
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
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              appLocalizations.privacyIntroduction,
              style: textTheme.bodyLarge?.copyWith(
                fontSize: 16,
              ),
            ),
          ),
          _buildPrivacyAssurance(appLocalizations, colors, textTheme),
          const SizedBox(height: 8),
          _buildSettingsSection(
            context,
            colors: colors,
            textTheme: textTheme,
            title: appLocalizations.essentialDataOptionTitle,
            description: appLocalizations.essentialDataOptionDescription,
            value: true,
            isLocked: true,
            onChanged: null,
          ),
          const Divider(height: 1),
          _buildSettingsSection(
            context,
            colors: colors,
            textTheme: textTheme,
            title: appLocalizations.analyticsOptionTitle,
            description: appLocalizations.analyticsOptionDescription,
            value: consent ?? false,
            isLocked: false,
            onChanged: (value) {
              ref.read(analyticsConsentProvider.notifier).updateConsent(value);
            },
          ),
          if (kDebugMode) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 8),
              child: Text(
                "Debug",
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
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
                    backgroundColor: colors.expense,
                    foregroundColor: colors.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPrivacyAssurance(AppLocalizations appLocalizations,
      AppColors colors, TextTheme textTheme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.privacy_tip, color: colors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                appLocalizations.privacyAssuranceLabel,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
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

  Widget _buildSettingsSection(
    BuildContext context, {
    required AppColors colors,
    required TextTheme textTheme,
    required String title,
    required String description,
    required bool value,
    required bool isLocked,
    required ValueChanged<bool>? onChanged,
  }) {
    return ListTile(
      title: Text(
        title,
        style: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          description,
          style: textTheme.bodyMedium?.copyWith(
            fontSize: 14,
            color: colors.textSecondary,
          ),
        ),
      ),
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeTrackColor: colors.primary,
      ),
    );
  }
}
