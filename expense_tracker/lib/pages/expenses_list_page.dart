import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ExpenseListPage extends StatefulWidget {
  const ExpenseListPage({Key? key}) : super(key: key);

  @override
  State<ExpenseListPage> createState() => _ExpenseListPageState();
}

class _ExpenseListPageState extends State<ExpenseListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Spese'),
        ),
        body: Column(
          children: [
            _buildCalendar(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add), onPressed: () {}));
  }

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  _buildCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
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
}
