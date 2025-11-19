import 'package:collection/collection.dart';
import 'package:expense_tracker/Services/widget_extension_service.dart';
import 'package:expense_tracker/application/transactions/notifiers/queries/latest_transactions_notifier.dart';
import 'package:expense_tracker/application/transactions/notifiers/queries/total_balance_notifier.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/domain/models/account.dart';
import 'package:expense_tracker/domain/models/category.dart';
import 'package:expense_tracker/domain/models/transaction.dart';
import 'package:expense_tracker/notifiers/account_provider.dart';
import 'package:expense_tracker/notifiers/category_provider.dart';
import 'package:expense_tracker/presentation/pages/account_detail_page/account_detail_page.dart';
import 'package:expense_tracker/presentation/pages/common/delete_transaction_snackbar.dart';
import 'package:expense_tracker/presentation/pages/common/list_tiles/transaction_list_cell.dart';
import 'package:expense_tracker/presentation/pages/home_page/home_flexible_app_bar.dart';
import 'package:expense_tracker/presentation/pages/home_page/home_app_bar.dart';
import 'package:expense_tracker/presentation/pages/options_page/accounts_page/new_edit_account_page.dart';
import 'package:expense_tracker/presentation/pages/new_edit_transaction_flow/new_edit_transaction_page.dart';
import 'package:expense_tracker/presentation/pages/common/list_tiles/account_list_tile.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  AppLocalizations? appLocalizations;
  static const double horizontalPadding = 18;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    appLocalizations = AppLocalizations.of(context)!;

    // Opens new transaction page when app is in background
    WidgetExtensionService().listenWidgetClick();

    // Opens new transaction page when app is closed
    WidgetExtensionService().checkForWidgetLaunch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _buildFloatingActionButton(),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: CustomColors.blue,
            pinned: true,
            automaticallyImplyLeading: false,
            expandedHeight: 190,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return FlexibleSpaceBar(
                  title: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: constraints.biggest.height ==
                            MediaQuery.of(context).padding.top + kToolbarHeight
                        ? 1.0
                        : 0.0,
                    child: const HomeAppBar(),
                  ),
                  background: const HomeFlexibleSpaceBar(),
                );
              },
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                AccountSection(horizontalPadding: horizontalPadding),
                const SizedBox(
                  height: 14,
                ),
                LastTransactionList(horizontalPadding: horizontalPadding),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Category? getCategoryForTransaction(Transaction transaction) {
    if (transaction.categoryId != null) {
      return ref
          .read(categoryProvider.notifier)
          .getCategoryFromId(transaction.categoryId!);
    }

    return null;
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: CustomColors.darkBlue,
      shape: const CircleBorder(),
      onPressed: () =>
          Navigator.pushNamed(context, NewEditTransactionPage.routeName),
      child: const Icon(Icons.add),
    );
  }
}

class AccountSection extends ConsumerWidget {
  final double horizontalPadding;

  const AccountSection({
    super.key,
    required this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 8),
          child: Text(
            appLocalizations!.yourAccounts,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ref.watch(provider)
        list.isNotEmpty
            ? SizedBox(
                height: 100,
                child: ListView.separated(
                  clipBehavior: Clip.none,
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  scrollDirection: Axis.horizontal,
                  itemCount: list.length,
                  itemBuilder: (context, index) {

                    ref.watch(totalBalanceProvider(TotalBalanceParams()))
                    return AccountListTile(
                        account: list.keys.toList()[index],
                        balance: list.values.toList()[index]);
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
                        style: const TextStyle(color: Colors.grey),
                        textAlign: TextAlign.start,
                      ),
                      TextButton(
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              alignment: Alignment.center),
                          onPressed: () => Navigator.of(context)
                              .pushNamed(NewAccountPage.routeName),
                          child: Text(appLocalizations.addOne)),
                    ],
                  ),
                ),
              ),
      ],
    );
  }

  /// Returns a Map where for each account, there is a sum of all the transactions value
  Map<Account, double> getAccountBalance(
      WidgetRef ref, AppLocalizations? appLocalizations) {
    final Map<Account, double> accountMap = {};

    double balanceTransactionsWithoutAccount = 0;

    final accountList = ref.watch(accountProvider);
    final transactionList = ref.watch(transactionProvider);

    for (var account in accountList) {
      accountMap[account] = 0;
    }

    for (var transaction in transactionList) {
      Account? transactionAccount = accountList
          .firstWhereOrNull((element) => element.id == transaction.accountId);

      if (transactionAccount != null) {
        accountMap[transactionAccount] =
            accountMap[transactionAccount]! + transaction.amount;
      } else {
        balanceTransactionsWithoutAccount += transaction.amount;
      }
    }

    if (balanceTransactionsWithoutAccount != 0) {
      Account otherAccount = Account(
          name: appLocalizations!.other,
          colorValue: Colors.grey.toARGB32(),
          iconPath: 'assets/icons/box.svg');

      accountMap[otherAccount] = balanceTransactionsWithoutAccount;
    }

    return accountMap;
  }
}

class LastTransactionList extends ConsumerWidget {
  final double horizontalPadding;

  const LastTransactionList({
    super.key,
    required this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = AppLocalizations.of(context);

    final latestTransactionsAsync = ref.watch(latestTransactionsProvider);

    return latestTransactionsAsync.when(
      data: (lastTransactionList) {
        if (lastTransactionList.isEmpty) {
          return Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                appLocalizations!.noTransactions,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Row(
                children: [
                  Text(
                    appLocalizations!.lastTransactions,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context)
                        .pushNamed(AccountDetailPage.routeName),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Row(
                      children: [
                        Text(
                          appLocalizations.viewAll,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: lastTransactionList.length,
              itemBuilder: (_, index) {
                return TransactionListCell(
                  transaction: lastTransactionList[index],
                  horizontalPadding: horizontalPadding,
                  onTransactionDelete: (transaction) {
                    showDeleteTransactionSnackbar(
                        context, ref, transaction, index);
                  },
                );
              },
              separatorBuilder: (_, __) => const Divider(),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Text('Error loading transactions: $err'),
      ),
    );
  }
}
