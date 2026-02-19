import 'package:expense_tracker/application/common/notifiers/package_info_provider.dart';
import 'package:expense_tracker/application/common/notifiers/app_localizations_provider.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/application/common/notifiers/currency_provider.dart';
import 'package:expense_tracker/application/common/notifiers/locale_provider.dart';
import 'package:expense_tracker/application/common/notifiers/notification_provider.dart';
import 'package:expense_tracker/presentation/pages/options_page/about_page/about_page.dart';
import 'package:expense_tracker/presentation/pages/options_page/accounts_page/accounts_list_page.dart';
import 'package:expense_tracker/presentation/pages/options_page/categories_page/categories_list_page.dart';
import 'package:expense_tracker/presentation/pages/options_page/currency_page/currency_page.dart';
import 'package:expense_tracker/presentation/pages/options_page/language_page/languages_list_page.dart';
import 'package:expense_tracker/presentation/pages/options_page/privacy_page/privacy_settings_page.dart';
import 'package:expense_tracker/presentation/pages/options_page/notification_page/notification_page.dart';
import 'package:expense_tracker/presentation/pages/update_history_page/update_history_page.dart';
import 'package:expense_tracker/presentation/pages/options_page/widgets/option_list_tile.dart';
import 'package:expense_tracker/presentation/pages/options_page/contacts_page/contacts_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';

class OptionsPage extends ConsumerWidget {
  const OptionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.settings),
      ),
      body: SafeArea(
        child: _buildBody(context, ref, appLocalizations),
      ),
    );
  }

  Widget _buildBody(
      BuildContext context, WidgetRef ref, AppLocalizations appLocalizations) {
    final currentCurrency = ref.watch(currentCurrencyProvider);
    final currentLocale = ref.watch(localeProvider);
    final packageInfoAsync = ref.watch(packageInfoProvider);

    return SingleChildScrollView(
      child: Column(
        children: [
          OptionListTile(
            title: appLocalizations.categories,
            subtitle: appLocalizations.categoriesOptionDescription,
            leadingIcon: Icons.grid_view_rounded,
            onTap: () =>
                Navigator.of(context).pushNamed(CategoriesListPage.routeName),
          ),
          const Divider(),
          OptionListTile(
            title: appLocalizations.accounts,
            subtitle: appLocalizations.accountsOptionDescription,
            leadingIcon: Icons.account_balance_rounded,
            onTap: () =>
                Navigator.of(context).pushNamed(AccountsListPage.routeName),
          ),
          const Divider(),
          OptionListTile(
            title: appLocalizations.language,
            subtitle: appLocalizations.languageOptionDescription,
            leadingIcon: Icons.translate_rounded,
            trailingWidgets: [
              if (currentLocale != null) Text(currentLocale.languageCode)
            ],
            onTap: () =>
                Navigator.of(context).pushNamed(LanguagesListPage.routeName),
          ),
          const Divider(),
          OptionListTile(
            title: appLocalizations.currency,
            subtitle: appLocalizations.selectCurrency,
            leadingIcon: Icons.currency_exchange_outlined,
            trailingWidgets: [
              if (currentCurrency != null) Text(currentCurrency.symbolNative),
            ],
            onTap: () =>
                Navigator.of(context).pushNamed(CurrencyPage.routeName),
          ),
          const Divider(),
          OptionListTile(
            title: appLocalizations.reminder,
            subtitle: appLocalizations.reminderOptionDescription,
            leadingIcon: Icons.notifications_active_rounded,
            trailingWidgets: [
              Text(ref.watch(notificationsEnabledProvider) != null &&
                      ref.watch(notificationsEnabledProvider) == true
                  ? appLocalizations.yes
                  : appLocalizations.no),
            ],
            onTap: () =>
                Navigator.of(context).pushNamed(ReminderPage.routeName),
          ),
          const Divider(),
          OptionListTile(
            title: appLocalizations.updateHistory,
            subtitle: appLocalizations.updateHistoryOptionDescription,
            leadingIcon: Icons.auto_awesome_rounded,
            onTap: () =>
                Navigator.of(context).pushNamed(UpdateHistoryPage.routeName),
          ),
          const Divider(),
          OptionListTile(
            title: appLocalizations.contacts,
            subtitle: appLocalizations.contactsDescription,
            leadingIcon: Icons.alternate_email_rounded,
            onTap: () =>
                Navigator.of(context).pushNamed(ContactsPage.routeName),
          ),
          const Divider(),
          OptionListTile(
            title: appLocalizations.privacy,
            subtitle: appLocalizations.privacyOptionDescription,
            leadingIcon: Icons.security_outlined,
            onTap: () =>
                Navigator.of(context).pushNamed(PrivacySettingsPage.routeName),
          ),
          const Divider(),
          OptionListTile(
            title: appLocalizations.feedback,
            subtitle: appLocalizations.feedbackAndReviewOptionDescription,
            leadingIcon: Icons.star_rounded,
            enableRightArrow: false,
            onTap: () {
              final InAppReview inAppReview = InAppReview.instance;
              inAppReview.openStoreListing(
                appStoreId: '6447369037',
              );
            },
          ),
          const Divider(),
          OptionListTile(
            title: appLocalizations.info,
            subtitle: appLocalizations.infoOptionDescription,
            leadingIcon: Icons.info_outline,
            onTap: () => Navigator.of(context).pushNamed(AboutPage.routeName),
          ),
          const Divider(),
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: packageInfoAsync.when(
              data: (packageInfo) => Text(
                '${appLocalizations.version} ${packageInfo.version}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              error: (_, __) => const SizedBox.shrink(),
              loading: () => const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}
