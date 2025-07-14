import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/notifiers/account_provider.dart';
import 'package:expense_tracker/pages/options_page/accounts_page/account_list_cell.dart';
import 'package:expense_tracker/pages/options_page/accounts_page/new_edit_account_page.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.yourAccounts),
        backgroundColor: CustomColors.blue,
      ),
      floatingActionButton: _buildFloatingActionButton(context),
      body: _buildList(),
    );
  }

  Widget _buildList() {
    return RefreshIndicator(
      onRefresh: () => ref.read(accountProvider.notifier).getAccountsFromDb(),
      child: Consumer(
        builder: ((context, ref, child) {
          return ref.watch(accountProvider).isNotEmpty
              ? ListView.builder(
                  itemCount: ref.watch(accountProvider).length,
                  itemBuilder: (context, index) {
                    final account = ref.watch(accountProvider)[index];

                    return AccountListCell(account: account);
                  },
                )
              : Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      AppLocalizations.of(context)!.noAccounts,
                      style: const TextStyle(color: Colors.grey),
                      textAlign: TextAlign.start,
                    ),
                  ),
                );
        }),
      ),
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
