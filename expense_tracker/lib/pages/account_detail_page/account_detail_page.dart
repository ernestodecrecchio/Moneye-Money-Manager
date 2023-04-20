import 'package:collection/collection.dart';
import 'package:expense_tracker/Helper/date_time_helper.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/notifiers/account_provider.dart';
import 'package:expense_tracker/notifiers/transaction_provider.dart';
import 'package:expense_tracker/pages/account_detail_page/account_pie_chart.dart';
import 'package:expense_tracker/pages/options_page/accounts_page/new_account_page.dart';
import 'package:expense_tracker/pages/home_page/transaction_list_cell.dart';
import 'package:expense_tracker/pages/new_transaction_flow/new_transaction_page.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum Sky { midnight, viridian, cerulean, alto }

Map<Sky, Color> skyColors = <Sky, Color>{
  Sky.midnight: const Color(0xff191970),
  Sky.viridian: const Color(0xff40826d),
  Sky.cerulean: const Color(0xff007ba7),
};

class AccountDetailPage extends StatefulWidget {
  static const routeName = '/accountDetailPage';

  final Account account;

  const AccountDetailPage({super.key, required this.account});

  @override
  State<AccountDetailPage> createState() => _AccountDetailPageState();
}

class _AccountDetailPageState extends State<AccountDetailPage>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  late final TabController _timeTabController;

  int selectedTimeIndex = 0;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
    _timeTabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final referenceAccount = Provider.of<AccountProvider>(context, listen: true)
        .accountList
        .firstWhereOrNull((element) => element.id == widget.account.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(referenceAccount?.name ?? widget.account.name),
        backgroundColor: CustomColors.blue,
        elevation: 0,
        actions: [if (widget.account.id != null) _buildEditAction(context)],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: _buildFloatingActionButton(context),
      body: _buildBody(context),
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

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildTabBar(),
          _buildDateBar(),
          Expanded(
              child: TabBarView(
            controller: _tabController,
            children: [
              _buildIncomePage(),
              _buildOutcomePage(),
              _buildTotalPage(),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Stack(
      fit: StackFit.passthrough,
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                  color: CustomColors.grey.withOpacity(0.25), width: 2.0),
            ),
          ),
        ),
        TabBar(
          controller: _tabController,
          indicatorColor: CustomColors.blue,
          labelColor: CustomColors.darkBlue,
          labelStyle: const TextStyle(fontSize: 16),
          tabs: const [
            Tab(
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  'Entrate',
                ),
              ),
            ),
            Tab(
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  'Uscite',
                ),
              ),
            ),
            Tab(
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  'Bilancio',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateBar() {
    return Container(
      height: 44,
      width: double.infinity,
      color: CustomColors.clearGrey,
      child: TabBar(
        controller: _timeTabController,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
        tabs: const [
          Tab(
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                'Settimana',
              ),
            ),
          ),
          Tab(
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                'Mese',
              ),
            ),
          ),
          Tab(
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                'Anno',
              ),
            ),
          ),
        ],
        unselectedLabelColor: CustomColors.clearGreyText,
        labelColor: Colors.white,
        indicator: BoxDecoration(
            color: CustomColors.blue,
            borderRadius: BorderRadius.circular(44 / 2)),
        onTap: (selectedTabIndex) {
          if (selectedTimeIndex != selectedTabIndex) {
            selectedTimeIndex = selectedTabIndex;
            setState(() {});
          }
        },
      ),
    );
  }

  Widget _buildIncomePage() {
    List<Transaction> transactionList = [];

    final currentDate = DateTime.now();
    final currentWeekNumber = weekNumber(currentDate);
    final currentMonth = currentDate.month;
    final currentYear = currentDate.year;

    final transactionProvider =
        Provider.of<TransactionProvider>(context, listen: true);

    switch (selectedTimeIndex) {
      case 0:
        transactionList = transactionProvider.transactionList
            .where((element) =>
                element.accountId == widget.account.id &&
                element.value >= 0 &&
                weekNumber(element.date) == currentWeekNumber &&
                element.date.year == currentYear)
            .toList();
        break;
      case 1:
        transactionList = transactionProvider.transactionList
            .where((element) =>
                element.accountId == widget.account.id &&
                element.value >= 0 &&
                element.date.month == currentMonth &&
                element.date.year == currentYear)
            .toList();
        break;
      case 2:
        transactionList = transactionProvider.transactionList
            .where((element) =>
                element.accountId == widget.account.id &&
                element.value >= 0 &&
                element.date.year == currentYear)
            .toList();
        break;
    }

    return Column(
      children: [
        _buildPieChart(
            transactionList, AccountPieChartModeTransactionType.income),
        Expanded(
          child: _buildTransactionListView(transactionList),
        )
      ],
    );
  }

  Widget _buildOutcomePage() {
    List<Transaction> transactionList = [];

    final currentDate = DateTime.now();
    final currentWeekNumber = weekNumber(currentDate);
    final currentMonth = currentDate.month;
    final currentYear = currentDate.year;

    final transactionProvider =
        Provider.of<TransactionProvider>(context, listen: true);

    switch (selectedTimeIndex) {
      case 0:
        transactionList = transactionProvider.transactionList
            .where((element) =>
                element.accountId == widget.account.id &&
                element.value < 0 &&
                weekNumber(element.date) == currentWeekNumber &&
                element.date.year == currentYear)
            .toList();
        break;
      case 1:
        transactionList = transactionProvider.transactionList
            .where((element) =>
                element.accountId == widget.account.id &&
                element.value < 0 &&
                element.date.month == currentMonth &&
                element.date.year == currentYear)
            .toList();
        break;
      case 2:
        transactionList = transactionProvider.transactionList
            .where((element) =>
                element.accountId == widget.account.id &&
                element.value < 0 &&
                element.date.year == currentYear)
            .toList();
        break;
    }

    return Column(
      children: [
        _buildPieChart(
            transactionList, AccountPieChartModeTransactionType.expense),
        Expanded(
          child: _buildTransactionListView(transactionList),
        )
      ],
    );
  }

  Widget _buildTotalPage() {
    List<Transaction> transactionList = [];

    final currentDate = DateTime.now();
    final currentWeekNumber = weekNumber(currentDate);
    final currentMonth = currentDate.month;
    final currentYear = currentDate.year;

    final transactionProvider =
        Provider.of<TransactionProvider>(context, listen: true);

    switch (selectedTimeIndex) {
      case 0:
        transactionList = transactionProvider.transactionList
            .where((element) =>
                element.accountId == widget.account.id &&
                weekNumber(element.date) == currentWeekNumber &&
                element.date.year == currentYear)
            .toList();
        break;
      case 1:
        transactionList = transactionProvider.transactionList
            .where((element) =>
                element.accountId == widget.account.id &&
                element.date.month == currentMonth &&
                element.date.year == currentYear)
            .toList();
        break;
      case 2:
        transactionList = transactionProvider.transactionList
            .where((element) =>
                element.accountId == widget.account.id &&
                element.date.year == currentYear)
            .toList();
        break;
    }

    return Column(
      children: [
        _buildPieChart(transactionList, AccountPieChartModeTransactionType.all),
        Expanded(
          child: _buildTransactionListView(transactionList),
        )
      ],
    );
  }

  Widget _buildPieChart(List<Transaction> transactionList,
      AccountPieChartModeTransactionType mode) {
    return transactionList.isEmpty
        ? const Expanded(child: Align(child: Text('Nessuna transazione')))
        : Container(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
            child: AccountPieChart(
              transactionList: transactionList,
              mode: mode,
            ),
          );
  }

  Widget _buildTransactionListView(List<Transaction> transactionList) {
    return ListView.builder(
      itemCount: transactionList.length,
      itemBuilder: (context, index) => TransactionListCell(
        transaction: transactionList[index],
        showAccountLabel: false,
      ),
    );
  }

  Widget _buildEditAction(BuildContext context) {
    return TextButton(
      child: const Text(
        'Modifica',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () => Navigator.of(context).pushNamed(
        NewAccountPage.routeName,
        arguments: widget.account,
      ),
    );
  }
}
