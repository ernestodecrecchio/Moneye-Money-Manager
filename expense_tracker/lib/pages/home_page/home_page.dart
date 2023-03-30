import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/notifiers/account_provider.dart';
import 'package:expense_tracker/notifiers/category_provider.dart';
import 'package:expense_tracker/notifiers/transaction_provider.dart';
import 'package:expense_tracker/pages/home_page/account_list_cell.dart';
import 'package:expense_tracker/pages/home_page/transaction_list_cell.dart';
import 'package:expense_tracker/pages/new_transaction_flow/new_transaction_page.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const double horizontalPadding = 17;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _buildFloatingActionButton(context),
      body: Container(
        color: CustomColors.blue,
        child: SingleChildScrollView(
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
          height: 25,
        ),
        _buildLastTransactionList(),
      ]),
    );
  }

  Widget _buildMonthlyBalanceSection() {
    final List<Transaction> currentMonthTransactions =
        Provider.of<TransactionProvider>(context, listen: true)
            .currentMonthTransactionList;

    // double monthlyBalance = 0;
    double monthlyIncome = 0;
    double monthlyExpenses = 0;
    for (var transaction in currentMonthTransactions) {
      // monthlyBalance += transaction.value;

      transaction.value >= 0
          ? monthlyIncome += transaction.value
          : monthlyExpenses += transaction.value;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Total balance',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            '${Provider.of<TransactionProvider>(context, listen: false).totalBalance} €',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 40,
              color: Colors.white,
            ),
          ),
          const Divider(
            color: Colors.white,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'This month',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.arrow_downward_rounded,
                        color: Colors.green,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Introiti',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            monthlyIncome.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.arrow_upward_rounded,
                        color: Colors.red,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sperse',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            monthlyExpenses.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
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
          )
        ],
      ),
    );
  }

  Widget _buildAccountSection() {
    final list = Provider.of<TransactionProvider>(context, listen: false)
        .getAccountBalance();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding:
              EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 8),
          child: Text(
            'I tuoi conti',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        list.isNotEmpty
            ? SizedBox(
                height: 80,
                child: ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: horizontalPadding),
                  scrollDirection: Axis.horizontal,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return AccountListCell(
                        account: list.keys.toList()[index],
                        balance: list.values.toList()[index]);
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                    width: 10,
                  ),
                ),
              )
            : const Align(
                alignment: Alignment.center,
                child: Text(
                  'Nessuna transazione inserita',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.start,
                ),
              ),
      ],
    );
  }

  Account? getAccountForTransaction(Transaction transaction) {
    return Provider.of<AccountProvider>(context, listen: false)
        .accountList
        .firstWhereOrNull((element) => element.id == transaction.accountId);
  }

  Future<Category?> getCategoryForTransaction(Transaction transaction) async {
    if (transaction.categoryId != null) {
      return await Provider.of<CategoryProvider>(context, listen: false)
          .getCategoryFromId(transaction.categoryId!);
    }

    return null;
  }

  Widget _buildLastTransactionList() {
    final lastTransactionList =
        Provider.of<TransactionProvider>(context, listen: true)
            .transactionList
            .take(5)
            .toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ultime transazioni',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          lastTransactionList.isNotEmpty
              ? ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: lastTransactionList.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                        key: Key(lastTransactionList[index].id.toString()),
                        confirmDismiss: (_) {
                          return Provider.of<TransactionProvider>(context,
                                  listen: false)
                              .deleteTransaction(lastTransactionList[index]);
                        },
                        background: Container(color: Colors.red),
                        child: TransactionListCell(
                            transaction: lastTransactionList[index]));
                  },
                  separatorBuilder: (context, index) => const Divider(),
                )
              : const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Nessuna transazione inserita',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.start,
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () =>
          Navigator.pushNamed(context, NewTransactionPage.routeName),
    );
  }
}
