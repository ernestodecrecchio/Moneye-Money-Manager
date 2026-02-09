import 'package:expense_tracker/application/common/notifiers/analytics_consent_provider.dart';
import 'package:expense_tracker/application/common/notifiers/app_localizations_provider.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnalyticsSettingsPage extends ConsumerWidget {
  static const String routeName = '/analytics-settings';

  const AnalyticsSettingsPage({super.key});

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
        ],
      ),
    );
  }
}
