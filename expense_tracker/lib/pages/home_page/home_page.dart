import 'package:expense_tracker/Graphs/monthly_balance_graph.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/notifiers/account_provider.dart';
import 'package:expense_tracker/notifiers/category_provider.dart';
import 'package:expense_tracker/notifiers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      body: SingleChildScrollView(
        child: Column(children: [
          _buildMonthlyBalanceSection(),
          const SizedBox(
            height: 5,
          ),
          _buildAccountSection(),
          const SizedBox(
            height: 5,
          ),
          _buildLastTransactionsSection(),
        ]),
      ),
    );
  }

  Widget _buildMonthlyBalanceSection() {
    return FutureBuilder(
      future: Provider.of<TransactionProvider>(context, listen: false)
          .getMonthlyBalance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          if (snapshot.hasData) {
            final currentMonthTransactions = snapshot.data as List<Transaction>;

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
                const SizedBox(
                  height: 20,
                ),
                const MonthlyBalanceGraph(),
              ],
            );
          }
        }

        return const Icon(Icons.error);
      },
    );
  }

  _buildAccountSection() {
    return FutureBuilder(
      future: Provider.of<AccountProvider>(context, listen: false)
          .getAllAccountsWithBalance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          if (snapshot.hasData) {
            final list = snapshot.data as List<Map<String, dynamic>>;

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
                        list[index]['account'],
                        list[index]['balance'] as double,
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

          return const Icon(Icons.error);
        }
      },
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

  _buildLastTransactionsSection() {
    return FutureBuilder(
      future: Provider.of<TransactionProvider>(context, listen: false)
          .getLastTransactions(5),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          if (snapshot.hasData) {
            final list = snapshot.data as List<Transaction>;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Le ultime transazione',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...list
                    .map((transaction) => _buildTransactionCell(transaction)),
              ],
            );
          }

          return const Icon(Icons.error);
        }
      },
    );
  }

  Future<Account?> getAccountForTransaction(Transaction transaction) async {
    if (transaction.accountId != null) {
      return await Provider.of<AccountProvider>(context, listen: false)
          .getAccountFromId(transaction.accountId!);
    }

    return null;
  }

  Future<Category?> getCategoryForTransaction(Transaction transaction) async {
    if (transaction.categoryId != null) {
      return await Provider.of<CategoryProvider>(context, listen: false)
          .getCategoryFromId(transaction.categoryId!);
    }

    return null;
  }

  _buildTransactionCell(Transaction transaction) {
    return FutureBuilder(
      future: Future.wait<dynamic>([
        getAccountForTransaction(transaction),
        getCategoryForTransaction(transaction),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          final account = (snapshot.data! as List<dynamic>)[0] as Account?;
          final category = (snapshot.data! as List<dynamic>)[1] as Category?;

          return Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            height: 60,
            color: Colors.grey,
            child: Row(
              children: [
                Container(
                  width: 50,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: category?.icon,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(category?.name ?? 'ERROR'),
                  ],
                ),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(transaction.value.toString()),
                    Text(account?.name ?? 'ERROR'),
                  ],
                ),
              ],
            ),
          );
        } else {
          return const Icon(Icons.error);
        }
      },
    );
  }
}
