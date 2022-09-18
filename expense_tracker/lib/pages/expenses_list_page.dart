import 'package:expense_tracker/notifiers/transaction_provider.dart';
import 'package:expense_tracker/pages/new_transaction_page.dart';
import 'package:expense_tracker/pages/transaction_list_cell.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseListPage extends StatefulWidget {
  const ExpenseListPage({Key? key}) : super(key: key);

  @override
  State<ExpenseListPage> createState() => _ExpenseListPageState();
}

class _ExpenseListPageState extends State<ExpenseListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(
              height: 20,
            ),
            _buildTransactionList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, NewTransactionPage.routeName,
              arguments: DateTime.now());
        },
      ),
    );
  }

  _buildHeader() {
    return Container(
      height: 220,
      margin: const EdgeInsets.symmetric(horizontal: 30),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
              offset: Offset(-6, -6),
              blurRadius: 36,
              spreadRadius: 18,
              color: Color.fromRGBO(255, 255, 255, 0.5)),
          BoxShadow(
              offset: Offset(6, 6),
              blurRadius: 36,
              spreadRadius: 18,
              color: Color.fromRGBO(217, 217, 217, 0.5))
        ],
      ),
      child: Consumer<TransactionProvider>(
        builder: ((context, transactionProvider, child) {
          final double totalBalance = transactionProvider.allTransaction.fold(0,
              (double previousValue, element) => previousValue + element.value);

          DateTime firstDayCurrentMonth =
              DateTime.utc(DateTime.now().year, DateTime.now().month, 1);

          DateTime lastDayCurrentMonth = DateTime.utc(
            DateTime.now().year,
            DateTime.now().month + 1,
          ).subtract(const Duration(days: 1));

          final currentMonthList = transactionProvider.transactionsBetweenDates(
              firstDayCurrentMonth, lastDayCurrentMonth);

          double currentMonthExpenses = 0;
          double currentMonthIncome = 0;

          for (var element in currentMonthList) {
            if (element.value >= 0) {
              currentMonthIncome += element.value;
            } else {
              currentMonthExpenses += element.value;
            }
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text('Total balance'),
              Text(totalBalance.toString()),
              const Divider(),
              Row(
                children: [
                  _buildHeaderCounter(
                      title: 'Income', value: currentMonthIncome),
                  const Spacer(),
                  _buildHeaderCounter(
                      title: 'Expense', value: currentMonthExpenses),
                ],
              )
            ],
          );
        }),
      ),
    );
  }

  _buildHeaderCounter({required String title, required double value}) {
    return Row(
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: value >= 0 ? Colors.green.shade400 : Colors.red.shade400,
          ),
          child: Icon(
            value >= 0 ? Icons.arrow_upward_outlined : Icons.arrow_downward,
            color: Colors.white,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            Text(
              value.toString(),
            ),
          ],
        )
      ],
    );
  }

  _buildTransactionList() {
    return Expanded(
      child: Consumer<TransactionProvider>(
        builder: ((context, transactionProvider, child) {
          final transactions = transactionProvider.allTransaction;

          return ListView.separated(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(transactions[index].id.toString()),
                confirmDismiss: (_) {
                  return Provider.of<TransactionProvider>(context,
                          listen: false)
                      .deleteTransaction(transactions[index]);
                },
                background: Container(color: Colors.red),
                child: TransactionListCell(
                  transaction: transactions[index],
                ),
              );
            },
            separatorBuilder: ((context, index) => const Divider(
                  height: 13,
                  color: Colors.transparent,
                )),
          );
        }),
      ),
    );
  }
}
