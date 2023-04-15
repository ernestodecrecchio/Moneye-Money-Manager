import 'package:expense_tracker/Helper/Database/double_helper.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/notifiers/account_provider.dart';
import 'package:expense_tracker/notifiers/category_provider.dart';
import 'package:expense_tracker/notifiers/transaction_provider.dart';
import 'package:expense_tracker/pages/accounts_page/new_account_page.dart';
import 'package:expense_tracker/pages/home_page/all_transaction_list_page.dart';
import 'package:expense_tracker/pages/home_page/transaction_list_cell.dart';
import 'package:expense_tracker/pages/new_transaction_flow/new_transaction_page.dart';
import 'package:expense_tracker/pages/home_page/account_list_tile.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

/// Migliorie:
// Impostare date picker basato su piattaform
// tasto entrata/uscita refactor
// Aggiungere saldo nuovo account
// Rivedere ombre account tile

/// Nuove feature
// Dettaglio conto
// Grafici
// Possibilità di cambiare la lingua
// Possibilità di cambiare la valuta
// Onboarding
// Allega foto
// OCR Scontrino
// Spesa condivisa
// Widget esterno
// Password/Face recognition
// Export dei dati CVS
// Aggiungi icone sensate

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const double horizontalPadding = 18;

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
          const Text(
            'Il resoconto finanziaro di questo mese',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Bilancio totale',
            style: TextStyle(
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
                    '${Provider.of<TransactionProvider>(context, listen: false).totalBalance.toStringAsFixedRounded(2)} €',
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
                      const Text(
                        'Uscite',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        monthlyExpenses.toStringAsFixedRounded(2),
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
                      const Text(
                        'Entrate',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        monthlyIncome.toStringAsFixedRounded(2),
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
        const Padding(
          padding:
              EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 8),
          child: Text(
            'I tuoi conti',
            style: TextStyle(
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
                      const Text(
                        'Nessun conto inserito,',
                        style: TextStyle(color: Colors.grey),
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
                          child: const Text('aggiungine uno')),
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
          name: 'Altro',
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
                const Text(
                  'Ultime transazioni',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.of(context)
                      .pushNamed(AllTransactionList.routeName),
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      alignment: Alignment.centerLeft),
                  child: const Text(
                    'Vedi tutte',
                    style: TextStyle(
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
              : const Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Nessuna transazione inserita',
                      style: TextStyle(color: Colors.grey),
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
          Navigator.pushNamed(context, NewTransactionPage.routeName),
      child: const Icon(Icons.add),
    );
  }
}
