import 'package:expense_tracker/core/presentation/common/widgets/list_empty_state.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/features/accounts/presentation/pages/accounts_list_page/account_list_cell.dart';
import 'package:expense_tracker/features/accounts/presentation/pages/accounts_list_page/new_edit_account_page.dart';
import 'package:expense_tracker/features/accounts/presentation/providers/queries/accounts_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountsListPage extends ConsumerWidget {
  static const routeName = '/accountsListPage';

  const AccountsListPage({super.key});

  void _openCreateAccount(BuildContext context) {
    Navigator.pushNamed(context, NewEditAccountPage.routeName);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final accountsAsync = ref.watch(accountsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.yourAccounts),
      ),
      body: SafeArea(
        child: accountsAsync.when(
          data: (accountsList) {
            if (accountsList.isEmpty) {
              return ListEmptyState(
                icon: Icons.account_balance_rounded,
                message: appLocalizations.noAccountsListMessage,
                actionLabel: appLocalizations.newAccount,
                onAction: () => _openCreateAccount(context),
              );
            }

            return ListView.builder(
              itemCount: accountsList.length,
              itemBuilder: (context, index) {
                return AccountListCell(account: accountsList[index]);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              const Center(child: Text('Error loading accounts list')),
        ),
      ),
      floatingActionButton: accountsAsync.asData?.value.isNotEmpty == true
          ? FloatingActionButton(
              onPressed: () => _openCreateAccount(context),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
