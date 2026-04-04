import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/presentation/common/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactsPage extends ConsumerWidget {
  static const routeName = '/contactsPage';

  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.contacts),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appLocalizations.contactsPageHeader,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 32),
                CustomElevatedButton(
                  text: appLocalizations.reportBug,
                  isLoading: false,
                  onPressed: () => _launchEmail('[Moneye - Bug Report] Report'),
                ),
                const SizedBox(height: 16),
                CustomElevatedButton(
                  text: appLocalizations.suggestFeature,
                  isLoading: false,
                  onPressed: () =>
                      _launchEmail('[Moneye - Feature Suggestion] Suggestion'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchEmail(String subject) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'moneyeapp@gmail.com',
      query: _encodeQueryParameters(<String, String>{
        'subject': subject,
      }),
    );

    await launchUrl(emailLaunchUri);
  }

  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
}
