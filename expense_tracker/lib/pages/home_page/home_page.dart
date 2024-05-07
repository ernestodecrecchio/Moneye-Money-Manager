import 'package:collection/collection.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/notifiers/account_provider.dart';
import 'package:expense_tracker/notifiers/category_provider.dart';
import 'package:expense_tracker/notifiers/transaction_provider.dart';
import 'package:expense_tracker/pages/account_detail_page/account_detail_page.dart';
import 'package:expense_tracker/pages/common/delete_transaction_snackbar.dart';
import 'package:expense_tracker/pages/common/list_tiles/transaction_list_cell.dart';
import 'package:expense_tracker/pages/home_page/home_flexible_app_bar.dart';
import 'package:expense_tracker/pages/home_page/home_app_bar.dart';
import 'package:expense_tracker/pages/options_page/accounts_page/new_edit_account_page.dart';
import 'package:expense_tracker/pages/new_edit_transaction_flow/new_edit_transaction_page.dart';
import 'package:expense_tracker/pages/common/list_tiles/account_list_tile.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:home_widget/home_widget.dart';

const String appGroupId = 'group.moneyewidget';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  AppLocalizations? appLocalizations;
  static const double horizontalPadding = 18;

  @override
  void initState() {
    super.initState();
    HomeWidget.setAppGroupId(appGroupId);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    appLocalizations = AppLocalizations.of(context)!;

    _checkForWidgetLaunch();
    HomeWidget.widgetClicked.listen(_launchedFromWidget);
  }

  void _checkForWidgetLaunch() {
    HomeWidget.initiallyLaunchedFromHomeWidget().then(_launchedFromWidget);
  }

  void _launchedFromWidget(Uri? uri) {
    if (uri != null) {
      Navigator.pushNamed(context, NewEditTransactionPage.routeName);
      /*showDialog(
        context: context,
        builder: (buildContext) => AlertDialog(
          title: const Text('App started from HomeScreenWidget'),
          content: Text('Here is the URI: $uri'),
        ),
      );*/
    }
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
            expandedHeight: 200,
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
                _buildAccountSection(),
                const SizedBox(
                  height: 14,
                ),
                _buildLastTransactionList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection() {
    final list = getAccountBalance();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: horizontalPadding, vertical: 8),
          child: Text(
            appLocalizations!.yourAccounts,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        list.isNotEmpty
            ? SizedBox(
                height: 100,
                child: ListView.separated(
                  clipBehavior: Clip.none,
                  padding:
                      const EdgeInsets.symmetric(horizontal: horizontalPadding),
                  scrollDirection: Axis.horizontal,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
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
                        appLocalizations!.noAccountAdded,
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
                          child: Text(appLocalizations!.addOne)),
                    ],
                  ),
                ),
              ),
      ],
    );
  }

  /// Returns a Map where for each account, there is a sum of all the transactions value
  Map<Account, double> getAccountBalance() {
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
            accountMap[transactionAccount]! + transaction.value;
      } else {
        balanceTransactionsWithoutAccount += transaction.value;
      }
    }

    if (balanceTransactionsWithoutAccount != 0) {
      Account otherAccount = Account(
          name: appLocalizations!.other,
          colorValue: Colors.grey.value,
          iconPath: 'assets/icons/box.svg');

      accountMap[otherAccount] = balanceTransactionsWithoutAccount;
    }

    return accountMap;
  }

  Category? getCategoryForTransaction(Transaction transaction) {
    if (transaction.categoryId != null) {
      return ref
          .read(categoryProvider.notifier)
          .getCategoryFromId(transaction.categoryId!);
    }

    return null;
  }

  Widget _buildLastTransactionList() {
    final List<Transaction> lastTransactionList = ref
        .watch(transactionProvider)
        .sorted((a, b) => b.date.compareTo(a.date))
        .take(5)
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
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
              Wrap(
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context)
                        .pushNamed(AccountDetailPage.routeName),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Row(
                      mainAxisSize:
                          MainAxisSize.min, // Make the row take minimum space
                      children: [
                        Text(
                          appLocalizations!.viewAll,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        lastTransactionList.isNotEmpty
            ? ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: lastTransactionList.length,
                itemBuilder: (_, index) {
                  return TransactionListCell(
                    transaction: lastTransactionList[index],
                    horizontalPadding: horizontalPadding,
                    onTransactionDelete: (transaction, index) {
                      showDeleteTransactionSnackbar(
                        context,
                        ref,
                        transaction,
                        index,
                      );
                    },
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
              )
            : Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                  ),
                  child: Text(
                    appLocalizations!.noTransactions,
                    style: const TextStyle(color: Colors.grey),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () =>
          Navigator.pushNamed(context, NewEditTransactionPage.routeName),
      child: const Icon(Icons.add),
    );
  }
}
