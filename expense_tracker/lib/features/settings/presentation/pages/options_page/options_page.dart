import 'package:expense_tracker/core/presentation/providers/package_info_provider.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/presentation/providers/currency_provider.dart';
import 'package:expense_tracker/core/presentation/providers/locale_provider.dart';
import 'package:expense_tracker/core/presentation/providers/notification_provider.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/features/accounts/presentation/pages/accounts_list_page/accounts_list_page.dart';
import 'package:expense_tracker/features/settings/presentation/pages/options_page/backup_restore_page/backup_restore_page.dart';
import 'package:expense_tracker/features/recurring_rules/presentation/pages/recurring_rules_page/recurring_rules_list_page.dart';
import 'package:expense_tracker/features/transaction_shortcuts/presentation/pages/transaction_shortcuts_list_page.dart';
import 'package:expense_tracker/features/categories/presentation/pages/categories_list_page/categories_list_page.dart';
import 'package:expense_tracker/features/settings/presentation/pages/options_page/currency_page/currency_page.dart';
import 'package:expense_tracker/features/settings/presentation/pages/options_page/language_page/languages_list_page.dart';
import 'package:expense_tracker/features/settings/presentation/pages/options_page/privacy_page/privacy_settings_page.dart';
import 'package:expense_tracker/features/settings/presentation/pages/options_page/notification_page/notification_page.dart';
import 'package:expense_tracker/features/settings/presentation/pages/options_page/theme_page/theme_selection_page.dart';
import 'package:expense_tracker/features/settings/presentation/pages/options_page/update_history_page/update_history_page.dart';
import 'package:expense_tracker/core/presentation/providers/theme_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/core/presentation/common/list_tiles/option_list_tile.dart';
import 'package:expense_tracker/features/settings/presentation/pages/options_page/contacts_page/contacts_page.dart';
import 'package:expense_tracker/features/home/presentation/widgets/tab_bar/tab_bar_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';

class OptionsPage extends ConsumerWidget {
  const OptionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(appLocalizations.settings),
      ),
      body: _buildBody(context, ref, appLocalizations),
    );
  }

  Widget _buildBody(
      BuildContext context, WidgetRef ref, AppLocalizations appLocalizations) {
    final currentCurrency = ref.watch(currentCurrencyProvider);
    final currentLocale = ref.watch(localeProvider);
    final currentThemeMode = ref.watch(themeProvider);
    final packageInfoAsync = ref.watch(packageInfoProvider);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          _buildSectionHeader(context, appLocalizations.management),
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
            title: appLocalizations.recurringTransactions,
            subtitle: appLocalizations.recurringTransactionsOptionDescription,
            leadingIcon: Icons.repeat_rounded,
            onTap: () => Navigator.of(context)
                .pushNamed(RecurringRulesListPage.routeName),
          ),
          const Divider(),
          OptionListTile(
            title: appLocalizations.transactionShortcuts,
            subtitle: appLocalizations.transactionShortcutsOptionDescription,
            leadingIcon: Icons.bolt_rounded,
            onTap: () => Navigator.of(context)
                .pushNamed(TransactionShortcutsListPage.routeName),
          ),
          _buildSectionHeader(context, appLocalizations.personalization),
          OptionListTile(
            title: appLocalizations.theme,
            subtitle: appLocalizations.themeOptionDescription,
            leadingIcon: Icons.palette_outlined,
            trailingWidgets: [
              Text(currentThemeMode.getName(appLocalizations)),
            ],
            onTap: () =>
                Navigator.of(context).pushNamed(ThemeSelectionPage.routeName),
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
            title: appLocalizations.reminder,
            subtitle: appLocalizations.reminderOptionDescription,
            leadingIcon: Icons.notifications_active_rounded,
            trailingWidgets: [
              if (ref.watch(notificationsEnabledProvider) != null)
                Text(ref.watch(notificationsEnabledProvider) == true
                    ? appLocalizations.yes
                    : appLocalizations.no),
            ],
            onTap: () =>
                Navigator.of(context).pushNamed(ReminderPage.routeName),
          ),
          _buildSectionHeader(context, appLocalizations.dataAndPrivacy),
          OptionListTile(
            title: appLocalizations.backupAndRestore,
            subtitle: appLocalizations.backupAndRestoreOptionDescription,
            leadingIcon: Icons.backup_rounded,
            enableRightArrow: true,
            onTap: () =>
                Navigator.of(context).pushNamed(BackupRestorePage.routeName),
          ),
          const Divider(),
          OptionListTile(
            title: appLocalizations.privacy,
            subtitle: appLocalizations.privacyOptionDescription,
            leadingIcon: Icons.security_outlined,
            onTap: () =>
                Navigator.of(context).pushNamed(PrivacySettingsPage.routeName),
          ),
          _buildSectionHeader(context, appLocalizations.aboutAndSupport),
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
          const SizedBox(height: 40),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: packageInfoAsync.when(
                data: (packageInfo) => Text(
                  '${appLocalizations.version} ${packageInfo.version}',
                  style: TextStyle(
                    color: context.appColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                error: (_, __) => const SizedBox.shrink(),
                loading: () => const SizedBox.shrink(),
              ),
            ),
          ),
            ],
          ),
        ),
        const TabBarScrollBottomSliver(),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 17, top: 24, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: context.appColors.primary,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}
