import 'package:expense_tracker/Graphs/monthly_balance_graph.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/notifiers/account_provider.dart';
import 'package:expense_tracker/notifiers/category_provider.dart';
import 'package:expense_tracker/notifiers/transaction_provider.dart';
import 'package:expense_tracker/pages/new_transaction_flow/new_transaction_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
      body: SingleChildScrollView(
        child: Column(children: [
          _buildMonthlyBalanceSection(),
          const SizedBox(
            height: 20,
          ),
          const MonthlyBalanceGraph(),
          const SizedBox(
            height: 5,
          ),
          _buildAccountSection(),
        ]),
      ),
    );
  }

  Widget _buildMonthlyBalanceSection() {
    final List<Transaction> currentMonthTransactions =
        Provider.of<TransactionProvider>(context, listen: true)
            .currentMonthTransactionList;

    double monthlyBalance = 0;
    double monthlyIncome = 0;
    double monthlyExpenses = 0;
    for (var transaction in currentMonthTransactions) {
      monthlyBalance += transaction.value;

      transaction.value >= 0
          ? monthlyIncome += transaction.value
          : monthlyExpenses += transaction.value;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 36,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: monthlyBalance.toString(),
              ),
              const TextSpan(
                text: '€',
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
        ),
        const Text('Monthly  balance'),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(monthlyIncome.toString()),
                const Text('INCOME'),
              ],
            ),
            Column(
              children: [
                Text(monthlyExpenses.toString()),
                const Text('EXPENSES'),
              ],
            )
          ],
        ),
      ],
    );
  }

  _buildAccountSection() {
    final list = Provider.of<TransactionProvider>(context, listen: false)
        .getAccountBalance();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'I tuoi conti',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 70,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            scrollDirection: Axis.horizontal,
            itemCount: list.length,
            itemBuilder: (context, index) {
              return _buildAccountCell(
                list.keys.toList()[index],
                list.values.toList()[index],
              );
            },
            separatorBuilder: (context, index) => const SizedBox(
              width: 10,
            ),
          ),
        ),
      ],
    );
  }

  _buildAccountCell(Account account, double balance) {
    return Container(
      padding: const EdgeInsets.all(5),
      width: 150,
      color: Colors.grey,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  account.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Text(
              balance.toStringAsFixed(2),
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ]),
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

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () =>
          Navigator.pushNamed(context, NewTransactionPage.routeName),
    );
  }
}
