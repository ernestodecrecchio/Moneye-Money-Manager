import 'package:expense_tracker/application/accounts/notifiers/queries/accounts_list_notifier.dart';
import 'package:expense_tracker/application/common/notifiers/app_localizations_provider.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/presentation/pages/options_page/accounts_page/account_list_cell.dart';
import 'package:expense_tracker/presentation/pages/options_page/accounts_page/new_edit_account_page.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountsListPage extends ConsumerStatefulWidget {
  static const routeName = '/accountsListPage';

  const AccountsListPage({super.key});

  @override
  ConsumerState<AccountsListPage> createState() => _AccountsListPageState();
}

class _AccountsListPageState extends ConsumerState<AccountsListPage> {
  @override
  Widget build(BuildContext context) {
    final appLocalizations = ref.watch(appLocalizationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.yourAccounts),
        backgroundColor: CustomColors.blue,
      ),
      floatingActionButton: _buildFloatingActionButton(context),
      body: _buildList(appLocalizations),
    );
  }

  Widget _buildList(AppLocalizations appLocalizations) {
    return ref.watch(accountsListProvider).when(
          data: (accountsList) {
            return accountsList.isNotEmpty
                ? ListView.builder(
                    itemCount: accountsList.length,
                    itemBuilder: (context, index) {
                      final account = accountsList[index];

                      return AccountListCell(account: account);
                    },
                  )
                : Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        appLocalizations.noAccounts,
                        style: const TextStyle(color: Colors.grey),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              const Text('Error loading accounts list'),
        );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: CustomColors.darkBlue,
      shape: const CircleBorder(),
      child: const Icon(Icons.add),
      onPressed: () => Navigator.pushNamed(context, NewAccountPage.routeName),
    );
  }
}
