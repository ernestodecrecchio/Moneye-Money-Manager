import 'package:expense_tracker/core/configuration/constants.dart';
import 'package:expense_tracker/core/presentation/common/list_tiles/account_list_tile.dart';
import 'package:expense_tracker/core/presentation/common/list_tiles/add_account_list_tile.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/features/accounts/presentation/pages/accounts_list_page/new_edit_account_page.dart';
import 'package:expense_tracker/features/accounts/presentation/providers/queries/accounts_with_balance_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountSection extends ConsumerWidget {
  const AccountSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Constants.horizontalPadding, vertical: 8),
          child: Text(
            appLocalizations.yourAccounts,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ref.watch(accountsWithBalanceProvider).when(
              data: (list) {
                return list.isNotEmpty
                    ? SizedBox(
                        height: 100,
                        child: ListView.separated(
                          clipBehavior: Clip.none,
                          padding: EdgeInsets.symmetric(
                              horizontal: Constants.horizontalPadding),
                          scrollDirection: Axis.horizontal,
                          itemCount: list.length + 1,
                          itemBuilder: (context, index) {
                            if (index == list.length) {
                              return const AddAccountListTile();
                            }
                            return AccountListTile(
                              account: list[index].account,
                              balance: list[index].balance,
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                            width: 12,
                          ),
                        ),
                      )
                    : Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                          child: Column(
                            children: [
                              Text(
                                appLocalizations.noAccountAdded,
                                style: TextStyle(
                                  color: context.appColors.textSecondary,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              TextButton(
                                  style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      alignment: Alignment.center),
                                  onPressed: () => Navigator.of(context)
                                      .pushNamed(NewEditAccountPage.routeName),
                                  child: Text(appLocalizations.addOne)),
                            ],
                          ),
                        ),
                      );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Text('Error loading accounts: $err'),
              ),
            ),
      ],
    );
  }
}
