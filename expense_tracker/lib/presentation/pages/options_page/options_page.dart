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
import 'package:expense_tracker/presentation/pages/options_page/analytics_settings_page.dart';
import 'package:expense_tracker/presentation/pages/options_page/notification_page/notification_page.dart';
import 'package:expense_tracker/style.dart';
import 'package:expense_tracker/presentation/pages/update_history_page/update_history_page.dart';
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
          ListTile(
            leading: const SizedBox(
              height: double.infinity,
              child: Icon(
                Icons.grid_view_rounded,
                color: CustomColors.darkBlue,
              ),
            ),
            title: Text(appLocalizations.categories),
            subtitle: Text(appLocalizations.categoriesOptionDescription),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () =>
                Navigator.of(context).pushNamed(CategoriesListPage.routeName),
          ),
          const Divider(),
          ListTile(
            leading: const SizedBox(
              height: double.infinity,
              child: Icon(
                Icons.account_balance_rounded,
                color: CustomColors.darkBlue,
              ),
            ),
            title: Text(appLocalizations.accounts),
            subtitle: Text(appLocalizations.accountsOptionDescription),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () =>
                Navigator.of(context).pushNamed(AccountsListPage.routeName),
          ),
          const Divider(),
          ListTile(
            leading: const SizedBox(
              height: double.infinity,
              child: Icon(
                Icons.translate_rounded,
                color: CustomColors.darkBlue,
              ),
            ),
            title: Text(appLocalizations.language),
            subtitle: Text(appLocalizations.languageOptionDescription),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (currentLocale != null) Text(currentLocale.languageCode),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
            onTap: () =>
                Navigator.of(context).pushNamed(LanguagesListPage.routeName),
          ),
          const Divider(),
          ListTile(
            leading: const SizedBox(
              height: double.infinity,
              child: Icon(
                Icons.currency_exchange_outlined,
                color: CustomColors.darkBlue,
              ),
            ),
            title: Text(appLocalizations.currency),
            subtitle: Text(appLocalizations.selectCurrency),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (currentCurrency != null) Text(currentCurrency.symbolNative),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
            onTap: () =>
                Navigator.of(context).pushNamed(CurrencyPage.routeName),
          ),
          const Divider(),
          ListTile(
            leading: const SizedBox(
              height: double.infinity,
              child: Icon(
                Icons.notifications_active_rounded,
                color: CustomColors.darkBlue,
              ),
            ),
            title: Text(appLocalizations.reminder),
            subtitle: Text(appLocalizations.reminderOptionDescription),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(ref.watch(notificationsEnabledProvider) != null &&
                        ref.watch(notificationsEnabledProvider) == true
                    ? appLocalizations.yes
                    : appLocalizations.no),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
            onTap: () =>
                Navigator.of(context).pushNamed(ReminderPage.routeName),
          ),
          const Divider(),
          ListTile(
            leading: const SizedBox(
              height: double.infinity,
              child: Icon(
                Icons.star_rounded,
                color: CustomColors.darkBlue,
              ),
            ),
            title: Text(appLocalizations.feedback),
            subtitle: Text(appLocalizations.feedbackAndReviewOptionDescription),
            onTap: () {
              final InAppReview inAppReview = InAppReview.instance;
              inAppReview.openStoreListing(
                appStoreId: '6447369037',
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const SizedBox(
              height: double.infinity,
              child: Icon(
                Icons.auto_awesome_rounded,
                color: CustomColors.darkBlue,
              ),
            ),
            title: Text(appLocalizations.updateHistory),
            subtitle: Text(appLocalizations.updateHistoryOptionDescription),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () =>
                Navigator.of(context).pushNamed(UpdateHistoryPage.routeName),
          ),
          const Divider(),
          ListTile(
            leading: const SizedBox(
              height: double.infinity,
              child: Icon(
                Icons.analytics_outlined,
                color: CustomColors.darkBlue,
              ),
            ),
            title: Text(appLocalizations.analytics),
            subtitle: Text(appLocalizations.analyticsOptionDescription),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => Navigator.of(context)
                .pushNamed(AnalyticsSettingsPage.routeName),
          ),
          const Divider(),
          ListTile(
            leading: const SizedBox(
              height: double.infinity,
              child: Icon(
                Icons.info_outline,
                color: CustomColors.darkBlue,
              ),
            ),
            title: Text(appLocalizations.info),
            subtitle: Text(appLocalizations.infoOptionDescription),
            trailing: const Icon(Icons.chevron_right_rounded),
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
