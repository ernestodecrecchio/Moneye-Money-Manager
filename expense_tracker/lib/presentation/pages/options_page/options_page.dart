import 'package:expense_tracker/application/common/notifiers/app_localizations_provider.dart';
import 'package:expense_tracker/application/common/notifiers/currency_provider.dart';
import 'package:expense_tracker/application/common/notifiers/locale_provider.dart';
import 'package:expense_tracker/application/common/notifiers/notification_provider.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/presentation/pages/options_page/about_page/about_page.dart';
import 'package:expense_tracker/presentation/pages/options_page/accounts_page/accounts_list_page.dart';
import 'package:expense_tracker/presentation/pages/options_page/categories_page/categories_list_page.dart';
import 'package:expense_tracker/presentation/pages/options_page/currency_page/currency_page.dart';
import 'package:expense_tracker/presentation/pages/options_page/language_page/languages_list_page.dart';
import 'package:expense_tracker/presentation/pages/options_page/notification_page/notification_page.dart';
import 'package:expense_tracker/style.dart';
import 'package:expense_tracker/services/database_export_import_service.dart';
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
        backgroundColor: CustomColors.blue,
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

    return ListView(
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
          onTap: () => Navigator.of(context).pushNamed(CurrencyPage.routeName),
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
          onTap: () => Navigator.of(context).pushNamed(ReminderPage.routeName),
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
        ListTile(
          leading: const SizedBox(
            height: double.infinity,
            child: Icon(
              Icons.backup_rounded,
              color: CustomColors.darkBlue,
            ),
          ),
          title: Text(appLocalizations.backupAndRestore),
          subtitle: Text(appLocalizations.backupAndRestoreOptionDescription),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => _showBackupRestoreDialog(context, ref, appLocalizations),
        ),
      ],
    );
  }

  void _showBackupRestoreDialog(
      BuildContext context, WidgetRef ref, AppLocalizations appLocalizations) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share_rounded),
              title: Text(appLocalizations.shareBackup),
              onTap: () async {
                Navigator.pop(context);
                try {
                  await DatabaseExportImportService.instance.exportDatabase();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(appLocalizations.exportSuccess)),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(appLocalizations.exportError)),
                    );
                  }
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.save_rounded),
              title: Text(appLocalizations.saveToDevice),
              onTap: () async {
                Navigator.pop(context);
                try {
                  final success = await DatabaseExportImportService.instance
                      .saveDatabaseLocally();
                  if (success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(appLocalizations.exportSuccess)),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(appLocalizations.exportError)),
                    );
                  }
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.file_download_rounded),
              title: Text(appLocalizations.importData),
              onTap: () async {
                Navigator.pop(context);
                final proceed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(appLocalizations.areYouSure),
                    content: Text(appLocalizations.importWarning),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(appLocalizations.cancel),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(appLocalizations.delete),
                      ),
                    ],
                  ),
                );

                if (proceed == true) {
                  try {
                    final success = await DatabaseExportImportService.instance
                        .importDatabase();
                    if (success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(appLocalizations.importSuccess)),
                      );
                      // Ideally we would trigger a global state refresh here.
                      // Depending on how Riverpod is set up, we might need to invalidate providers.
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(appLocalizations.importError)),
                      );
                    }
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
