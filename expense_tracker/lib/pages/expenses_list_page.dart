import 'package:expense_tracker/notifiers/category_provider.dart';
import 'package:expense_tracker/notifiers/transaction_provider.dart';
import 'package:expense_tracker/pages/new_transaction_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class ExpenseListPage extends StatefulWidget {
  const ExpenseListPage({Key? key}) : super(key: key);

  @override
  State<ExpenseListPage> createState() => _ExpenseListPageState();
}

class _ExpenseListPageState extends State<ExpenseListPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();

    Provider.of<TransactionProvider>(context, listen: false)
        .getAllTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spese'),
      ),
      body: Column(
        children: [
          _buildCalendar(),
          _buildTransactionList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, NewTransactionPage.routeName,
              arguments: _selectedDay);
        },
      ),
    );
  }

  _buildCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(1999, 1, 1),
      lastDay: DateTime.utc(2030, 1, 1),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        Provider.of<TransactionProvider>(context, listen: false)
            .getTransactionsForDate(selectedDay);
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay; // update `_focusedDay` here as well
        });
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      calendarFormat: _calendarFormat,
      formatAnimationCurve: Curves.easeInOut,
      formatAnimationDuration: const Duration(milliseconds: 500),
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      availableCalendarFormats: const {
        CalendarFormat.month: 'Mese',
        CalendarFormat.week: 'Settimana'
      },
    );
  }

  _buildTransactionList() {
    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, child) {
        final transactionsList = transactionProvider.transactionList;

        final total = transactionsList.fold<double>(
            0, (previousValue, element) => previousValue + element.value);

        return Expanded(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: transactionsList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(transactionsList[index].title),
                      subtitle: Text(transactionsList[index].value.toString()),
                      trailing: Container(
                        color: Provider.of<CategoryProvider>(context,
                                listen: false)
                            .getCategoryFromId(
                                transactionsList[index].categoryId)
                            .color,
                        child: Text(Provider.of<CategoryProvider>(context,
                                listen: false)
                            .getCategoryFromId(
                                transactionsList[index].categoryId)
                            .name),
                      ),
                    );
                  },
                ),
              ),
              Text('Totale: $total'),
            ],
          ),
        );
      },
    );
  }
}
