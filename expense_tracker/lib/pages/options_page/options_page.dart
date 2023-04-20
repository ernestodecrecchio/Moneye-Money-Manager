import 'package:expense_tracker/pages/options_page/accounts_page/accounts_list_page.dart';
import 'package:expense_tracker/pages/options_page/categories_page/categories_list_page.dart';
import 'package:expense_tracker/pages/options_page/language_page/languages_list_page.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OptionsPage extends StatelessWidget {
  const OptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        backgroundColor: CustomColors.blue,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 10),
      children: [
        ListTile(
          leading: const Icon(
            Icons.grid_view_rounded,
            color: CustomColors.darkBlue,
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
          leading: const Icon(
            Icons.account_balance_rounded,
            color: CustomColors.darkBlue,
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
          leading: const Icon(
            Icons.language_rounded,
            color: CustomColors.darkBlue,
          ),
          title: Text(AppLocalizations.of(context)!.language),
          subtitle:
              Text(AppLocalizations.of(context)!.languageOptionDescription),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () =>
              Navigator.of(context).pushNamed(LanguagesListPage.routeName),
        ),
      ],
    );
  }
}
