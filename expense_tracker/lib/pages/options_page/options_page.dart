import 'package:expense_tracker/notifiers/currency_provider.dart';
import 'package:expense_tracker/notifiers/locale_provider.dart';
import 'package:expense_tracker/pages/options_page/about_page/about_page.dart';
import 'package:expense_tracker/pages/options_page/accounts_page/accounts_list_page.dart';
import 'package:expense_tracker/pages/options_page/categories_page/categories_list_page.dart';
import 'package:expense_tracker/pages/options_page/currency_page/currency_page.dart';
import 'package:expense_tracker/pages/options_page/language_page/languages_list_page.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as p;

class OptionsPage extends ConsumerWidget {
  const OptionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        backgroundColor: CustomColors.blue,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _buildBody(context, ref),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref) {
    final currentCurrency = ref.watch(currentCurrencyProvider);

    return ListView(
      padding: const EdgeInsets.only(top: 10),
      children: [
        ListTile(
          leading: const SizedBox(
            height: double.infinity,
            child: Icon(
              Icons.grid_view_rounded,
              color: CustomColors.darkBlue,
            ),
          ),
          title: Text(AppLocalizations.of(context)!.categories),
          subtitle:
              Text(AppLocalizations.of(context)!.categoriesOptionDescription),
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
          title: Text(AppLocalizations.of(context)!.accounts),
          subtitle:
              Text(AppLocalizations.of(context)!.accountsOptionDescription),
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
          title: Text(AppLocalizations.of(context)!.language),
          subtitle:
              Text(AppLocalizations.of(context)!.languageOptionDescription),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (p.Provider.of<LocaleProvider>(context, listen: true).locale !=
                  null)
                Text(p.Provider.of<LocaleProvider>(context, listen: true)
                    .locale!
                    .languageCode),
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
          title: Text(AppLocalizations.of(context)!.currency),
          subtitle: Text(AppLocalizations.of(context)!.selectCurrency),
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
              Icons.info_outline,
              color: CustomColors.darkBlue,
            ),
          ),
          title: Text(AppLocalizations.of(context)!.info),
          subtitle: Text(AppLocalizations.of(context)!.infoOptionDescription),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => Navigator.of(context).pushNamed(AboutPage.routeName),
        ),
      ],
    );
  }
}
