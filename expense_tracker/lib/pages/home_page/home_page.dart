import 'package:expense_tracker/Database/double_helper.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/notifiers/account_provider.dart';
import 'package:expense_tracker/notifiers/category_provider.dart';
import 'package:expense_tracker/notifiers/transaction_provider.dart';
import 'package:expense_tracker/pages/account_detail_page/account_detail_page.dart';
import 'package:expense_tracker/pages/options_page/accounts_page/new_edit_account_page.dart';
import 'package:expense_tracker/pages/home_page/transaction_list_cell.dart';
import 'package:expense_tracker/pages/new_edit_transaction_flow/new_edit_transaction_page.dart';
import 'package:expense_tracker/pages/home_page/account_list_tile.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Migliorie:
// Aggiungi icone sensate

/// Nuove feature
// Onboarding
// Allega foto
// OCR Scontrino
// Spesa condivisa
// Widget esterno
// Password/Face recognition
// Export dei dati CVS

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppLocalizations? appLocalizations;
  static const double horizontalPadding = 18;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    appLocalizations = AppLocalizations.of(context)!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _buildFloatingActionButton(context),
      backgroundColor: Colors.white,
      body: Container(
        color: CustomColors.blue,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: SafeArea(
            child: Column(children: [
              _buildTopSection(),
              const SizedBox(
                height: 20,
              ),
              _buildBottomSection(),
            ]),
          ),
        ),
      ),
    );
  }

  _buildTopSection() {
    return _buildMonthlyBalanceSection();
  }

  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.only(top: 8),
      color: Colors.white,
      child: Column(children: [
        _buildAccountSection(),
        const SizedBox(
          height: 14,
        ),
        _buildLastTransactionList(),
      ]),
    );
  }

  Widget _buildMonthlyBalanceSection() {
    final List<Transaction> currentMonthTransactions =
        Provider.of<TransactionProvider>(context, listen: true)
            .currentMonthTransactionList;

    double monthlyIncome = 0;
    double monthlyExpenses = 0;
    for (var transaction in currentMonthTransactions) {
      transaction.value >= 0
          ? monthlyIncome += transaction.value
          : monthlyExpenses += transaction.value;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: horizontalPadding, vertical: 18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            appLocalizations!.financialOverviewForThisMonth,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            appLocalizations!.totalBalance,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
          Row(
            children: [
              Flexible(
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    Provider.of<TransactionProvider>(context, listen: false)
                        .totalBalance
                        .toStringAsFixedRoundedWithCurrency(context, 2),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      overflow: TextOverflow.clip,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 28,
              ),
              _buildPercentageDifference()
            ],
          ),
          const SizedBox(
            height: 14,
          ),
          Row(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/icons/pocket_out.svg'),
                  const SizedBox(
                    width: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appLocalizations!.outcomes,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        monthlyExpenses.toStringAsFixedRoundedWithCurrency(
                            context, 2),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                width: 30,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/icons/pocket_in.svg'),
                  const SizedBox(
                    width: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appLocalizations!.incomes,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        monthlyIncome.toStringAsFixedRoundedWithCurrency(
                            context, 2),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPercentageDifference() {
    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, child) {
        final currMonthDate = DateTime.now();
        final prevMonthDate =
            DateTime(currMonthDate.year, currMonthDate.month, 1);

        double currMonthBalance =
            transactionProvider.getTotalBanalceUntilDate(currMonthDate);
        double prevMonthBalance =
            transactionProvider.getTotalBanalceUntilDate(prevMonthDate);

        if (prevMonthBalance != 0) {
          final diffPercentage =
              ((currMonthBalance - prevMonthBalance) / prevMonthBalance) * 100;

          return Container(
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 20,
                top: 8,
                bottom: 8,
              ),
              child: Row(
                children: [
                  Icon(
                    diffPercentage >= 0
                        ? Icons.arrow_drop_up_rounded
                        : Icons.arrow_drop_down_rounded,
                    color: Colors.white,
                  ),
                  Text(
                    '${diffPercentage.toStringAsFixedRounded(2)}%',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
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
                height: 90,
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

    final accountList =
        Provider.of<AccountProvider>(context, listen: true).accountList;
    final transactionList =
        Provider.of<TransactionProvider>(context, listen: true).transactionList;

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
      return Provider.of<CategoryProvider>(context, listen: false)
          .getCategoryFromId(transaction.categoryId!);
    }

    return null;
  }

  Widget _buildLastTransactionList() {
    final List<Transaction> lastTransactionList =
        Provider.of<TransactionProvider>(context, listen: true)
            .transactionList
            .sorted((a, b) => b.date.compareTo(a.date))
            .take(5)
            .toList();

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                TextButton(
                  onPressed: () => Navigator.of(context)
                      .pushNamed(AccountDetailPage.routeName),
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      alignment: Alignment.centerLeft),
                  child: Text(
                    appLocalizations!.viewAll,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          lastTransactionList.isNotEmpty
              ? ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: lastTransactionList.length,
                  itemBuilder: (context, index) {
                    return TransactionListCell(
                      transaction: lastTransactionList[index],
                      horizontalPadding: horizontalPadding,
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(
                    height: 1,
                  ),
                )
              : Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      appLocalizations!.noTransactions,
                      style: const TextStyle(color: Colors.grey),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: CustomColors.darkBlue,
      onPressed: () =>
          Navigator.pushNamed(context, NewEditTransactionPage.routeName),
      child: const Icon(Icons.add),
    );
  }
}
