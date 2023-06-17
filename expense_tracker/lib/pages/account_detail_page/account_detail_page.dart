import 'package:collection/collection.dart';
import 'package:expense_tracker/Helper/date_time_helper.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/notifiers/account_provider.dart';
import 'package:expense_tracker/notifiers/transaction_provider.dart';
import 'package:expense_tracker/pages/account_detail_page/account_bar_chart.dart';
import 'package:expense_tracker/pages/account_detail_page/account_pie_chart.dart';
import 'package:expense_tracker/pages/account_detail_page/transaction_list/transaction_list.dart';
import 'package:expense_tracker/pages/common/custom_modal_bottom_sheet.dart';
import 'package:expense_tracker/pages/options_page/accounts_page/new_edit_account_page.dart';
import 'package:expense_tracker/pages/new_edit_transaction_flow/new_edit_transaction_page.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum AccountDetailTransactionTypeMode { income, expense, all }

enum TransactionTimePeriod {
  day,
  week,
  month,
  year,
  custom,
}

class AccountDetailPage extends StatefulWidget {
  static const routeName = '/accountDetailPage';

  final Account? account;

  const AccountDetailPage({super.key, this.account});

  @override
  State<AccountDetailPage> createState() => _AccountDetailPageState();
}

class _AccountDetailPageState extends State<AccountDetailPage>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  AccountDetailTransactionListMode transactionListMode =
      AccountDetailTransactionListMode.transactionList;

  AccountDetailTransactionTypeMode transactionTypeMode =
      AccountDetailTransactionTypeMode.income;

  int selectedTimeIndex = 0;

  TransactionTimePeriod selectedTransactionTimePeriod =
      TransactionTimePeriod.month;

  DateTime startDate = currentMonthFirstDay(DateTime.now());
  DateTime endDate = currentMonthLastDay(DateTime.now());

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Account? referenceAccount;

    if (widget.account != null) {
      referenceAccount = Provider.of<AccountProvider>(context, listen: true)
          .accountList
          .firstWhereOrNull((element) => element.id == widget.account!.id);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.account != null
            ? referenceAccount?.name ?? widget.account!.name
            : AppLocalizations.of(context)!.allTransactions),
        backgroundColor: CustomColors.blue,
        elevation: 0,
        actions: [
          if (widget.account != null && widget.account!.id != null)
            _buildEditAction(context)
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: _buildFloatingActionButton(context),
      body: _buildBody(context),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: CustomColors.darkBlue,
      onPressed: () => Navigator.pushNamed(
        context,
        NewEditTransactionPage.routeName,
        arguments: NewEditTransactionPageScreenArguments(
          account: widget.account?.id != null ? widget.account : null,
        ),
      ),
      child: const Icon(Icons.add),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          _buildTabBar(),
          _buildDateBar(),
          Expanded(
              child: TabBarView(
            controller: _tabController,
            children: [
              _buildContentPage(
                  transactionType: AccountDetailTransactionTypeMode.income),
              _buildContentPage(
                  transactionType: AccountDetailTransactionTypeMode.expense),
              _buildContentPage(
                  transactionType: AccountDetailTransactionTypeMode.all),
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
          onTap: (value) {
            switch (value) {
              case 0:
                transactionTypeMode = AccountDetailTransactionTypeMode.income;
                break;
              case 1:
                transactionTypeMode = AccountDetailTransactionTypeMode.expense;
                break;
              case 2:
                transactionTypeMode = AccountDetailTransactionTypeMode.all;
                break;
            }
          },
          tabs: [
            Tab(
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  AppLocalizations.of(context)!.incomes,
                ),
              ),
            ),
            Tab(
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  AppLocalizations.of(context)!.outcomes,
                ),
              ),
            ),
            Tab(
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  AppLocalizations.of(context)!.balance,
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
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      width: double.infinity,
      color: CustomColors.clearGrey,
      child: Row(
        children: [
          SizedBox(
            width: (MediaQuery.of(context).size.width - 28) / 3,
            child: ElevatedButton(
              onPressed: () {
                showCustomModalBottomSheet(
                  context: context,
                  builder: ((context) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 17),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .selectTimeInterval,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  icon: const Icon(Icons.close),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                ListTile(
                                  title:
                                      Text(AppLocalizations.of(context)!.day),
                                  trailing: selectedTransactionTimePeriod ==
                                          TransactionTimePeriod.day
                                      ? SvgPicture.asset(
                                          'assets/icons/checkmark.svg')
                                      : null,
                                  onTap: () {
                                    selectedTransactionTimePeriod =
                                        TransactionTimePeriod.day;

                                    final currentDate = DateTime.now();

                                    startDate = DateTime(
                                        currentDate.year,
                                        currentDate.month,
                                        currentDate.day,
                                        0,
                                        0,
                                        0);

                                    endDate = DateTime(
                                        currentDate.year,
                                        currentDate.month,
                                        currentDate.day,
                                        23,
                                        59,
                                        59);

                                    setState(() {});
                                    Navigator.of(context).pop();
                                  },
                                ),
                                ListTile(
                                  title:
                                      Text(AppLocalizations.of(context)!.week),
                                  trailing: selectedTransactionTimePeriod ==
                                          TransactionTimePeriod.week
                                      ? SvgPicture.asset(
                                          'assets/icons/checkmark.svg')
                                      : null,
                                  onTap: () {
                                    selectedTransactionTimePeriod =
                                        TransactionTimePeriod.week;

                                    final currentDate = DateTime.now();

                                    startDate =
                                        currentWeekFirstDay(currentDate);
                                    endDate = currentWeekLastDay(currentDate);

                                    setState(() {});
                                    Navigator.of(context).pop();
                                  },
                                ),
                                ListTile(
                                  title:
                                      Text(AppLocalizations.of(context)!.month),
                                  trailing: selectedTransactionTimePeriod ==
                                          TransactionTimePeriod.month
                                      ? SvgPicture.asset(
                                          'assets/icons/checkmark.svg')
                                      : null,
                                  onTap: () {
                                    selectedTransactionTimePeriod =
                                        TransactionTimePeriod.month;

                                    final currentDate = DateTime.now();

                                    startDate =
                                        currentMonthFirstDay(currentDate);
                                    endDate = currentMonthLastDay(currentDate);

                                    setState(() {});
                                    Navigator.of(context).pop();
                                  },
                                ),
                                ListTile(
                                  title:
                                      Text(AppLocalizations.of(context)!.year),
                                  trailing: selectedTransactionTimePeriod ==
                                          TransactionTimePeriod.year
                                      ? SvgPicture.asset(
                                          'assets/icons/checkmark.svg')
                                      : null,
                                  onTap: () {
                                    selectedTransactionTimePeriod =
                                        TransactionTimePeriod.year;

                                    final currentDate = DateTime.now();

                                    startDate =
                                        currentYearFirstDay(currentDate);
                                    endDate = currentYearLastDay(currentDate);

                                    setState(() {});
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.blue,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(55 / 2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        selectedTransactionTimePeriod ==
                                TransactionTimePeriod.day
                            ? AppLocalizations.of(context)!.day
                            : selectedTransactionTimePeriod ==
                                    TransactionTimePeriod.week
                                ? AppLocalizations.of(context)!.week
                                : selectedTransactionTimePeriod ==
                                        TransactionTimePeriod.month
                                    ? AppLocalizations.of(context)!.month
                                    : selectedTransactionTimePeriod ==
                                            TransactionTimePeriod.year
                                        ? AppLocalizations.of(context)!.year
                                        : 'Custom',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down_rounded)
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  selectedTransactionTimePeriod == TransactionTimePeriod.day
                      ? DateFormat("dd MMM yyyy").format(startDate)
                      : selectedTransactionTimePeriod ==
                              TransactionTimePeriod.week
                          ? '${DateFormat("dd MMM yy").format(startDate)} - ${DateFormat("dd MMM yy").format(endDate)}'
                          : selectedTransactionTimePeriod ==
                                  TransactionTimePeriod.month
                              ? DateFormat("MMM yyyy").format(startDate)
                              : selectedTransactionTimePeriod ==
                                      TransactionTimePeriod.year
                                  ? DateFormat("yyyy").format(startDate)
                                  : '${startDate.day} ${startDate.month} - ${endDate.day} ${endDate.month}',
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 14,
                    color: CustomColors.clearGreyText,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          ElevatedButton(
            onPressed: () {
              switch (selectedTransactionTimePeriod) {
                case TransactionTimePeriod.day:
                  startDate = previousDay(startDate);
                  endDate = previousDay(endDate);

                  break;
                case TransactionTimePeriod.week:
                  startDate = previousWeekFirstDay(startDate);
                  endDate = previousWeekLastDay(endDate);

                  break;
                case TransactionTimePeriod.month:
                  startDate = previousMonthFirstDay(startDate);
                  endDate = previousMonthLastDay(endDate);

                  break;
                case TransactionTimePeriod.year:
                  startDate = previousYearFirstDay(startDate);
                  endDate = previousYearLastDay(endDate);

                  break;
                case TransactionTimePeriod.custom:
                  break;
              }

              setState(() {});
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(35, 35),
              elevation: 0,
              backgroundColor: CustomColors.blue,
              shape: const CircleBorder(),
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Icon(Icons.chevron_left_rounded),
          ),
          const SizedBox(
            width: 8,
          ),
          ElevatedButton(
            onPressed: () {
              switch (selectedTransactionTimePeriod) {
                case TransactionTimePeriod.day:
                  startDate = nextDay(startDate);
                  endDate = nextDay(endDate);

                  break;
                case TransactionTimePeriod.week:
                  startDate = nextWeekFirstDay(startDate);
                  endDate = nextWeekLastDay(endDate);

                  break;
                case TransactionTimePeriod.month:
                  startDate = nextMonthFirstDay(startDate);
                  endDate = nextMonthLastDay(endDate);

                  break;
                case TransactionTimePeriod.year:
                  startDate = nextYearFirstDay(startDate);
                  endDate = nextYearLastDay(endDate);

                  break;
                case TransactionTimePeriod.custom:
                  break;
              }
              setState(() {});
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(35, 35),
              elevation: 0,
              backgroundColor: CustomColors.blue,
              shape: const CircleBorder(),
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Icon(Icons.chevron_right_rounded),
          ),
        ],
      ),
    );
  }

  List<Transaction> _getIncomeTransactionList() {
    List<Transaction> transactionList = [];

    final transactionProvider =
        Provider.of<TransactionProvider>(context, listen: true);

    if (widget.account != null) {
      transactionList = transactionProvider.transactionList
          .where(
            (element) =>
                element.accountId == widget.account!.id &&
                element.value >= 0 &&
                element.date.isAfterIncludingZero(startDate) &&
                element.date.isBeforeIncludingZero(endDate),
          )
          .toList()
          .sorted((a, b) => a.date.isBefore(b.date) ? 1 : 0);
    } else {
      transactionList = transactionProvider.transactionList
          .where(
            (element) =>
                element.value >= 0 &&
                element.date.isAfterIncludingZero(startDate) &&
                element.date.isBeforeIncludingZero(endDate),
          )
          .toList()
          .sorted((a, b) => a.date.isBefore(b.date) ? 1 : 0);
    }

    return transactionList;
  }

  List<Transaction> _getOutcomeTransactionList() {
    List<Transaction> transactionList = [];

    final transactionProvider =
        Provider.of<TransactionProvider>(context, listen: true);

    if (widget.account != null) {
      transactionList = transactionProvider.transactionList
          .where((element) =>
              element.accountId == widget.account!.id &&
              element.value < 0 &&
              element.date.isAfterIncludingZero(startDate) &&
              element.date.isBeforeIncludingZero(endDate))
          .toList()
          .sorted((a, b) => a.date.isBefore(b.date) ? 1 : 0);
    } else {
      transactionList = transactionProvider.transactionList
          .where(
            (element) =>
                element.value < 0 &&
                element.date.isAfterIncludingZero(startDate) &&
                element.date.isBeforeIncludingZero(endDate),
          )
          .toList()
          .sorted((a, b) => a.date.isBefore(b.date) ? 1 : 0);
    }

    return transactionList;
  }

  List<Transaction> _getTotalTransactionList() {
    List<Transaction> transactionList = [];

    final transactionProvider =
        Provider.of<TransactionProvider>(context, listen: true);

    if (widget.account != null) {
      transactionList = transactionProvider.transactionList
          .where(
            (element) =>
                element.accountId == widget.account!.id &&
                element.date.isAfterIncludingZero(startDate) &&
                element.date.isBeforeIncludingZero(endDate),
          )
          .toList()
          .sorted((a, b) => a.date.isBefore(b.date) ? 1 : 0);
    } else {
      transactionList = transactionProvider.transactionList
          .where(
            (element) =>
                element.date.isAfterIncludingZero(startDate) &&
                element.date.isBeforeIncludingZero(endDate),
          )
          .toList()
          .sorted((a, b) => a.date.isBefore(b.date) ? 1 : 0);
    }

    return transactionList;
  }

  Widget _buildContentPage(
      {required AccountDetailTransactionTypeMode transactionType}) {
    List<Transaction> transactionList = [];
    AccountBarChartModeTransactionType barChartTransactionType;
    AccountPieChartModeTransactionType pieChartTransactionType;

    switch (transactionType) {
      case AccountDetailTransactionTypeMode.income:
        transactionList = _getIncomeTransactionList();
        barChartTransactionType = AccountBarChartModeTransactionType.income;
        pieChartTransactionType = AccountPieChartModeTransactionType.income;
        break;
      case AccountDetailTransactionTypeMode.expense:
        transactionList = _getOutcomeTransactionList();
        barChartTransactionType = AccountBarChartModeTransactionType.expense;
        pieChartTransactionType = AccountPieChartModeTransactionType.expense;
        break;
      case AccountDetailTransactionTypeMode.all:
        transactionList = _getTotalTransactionList();
        barChartTransactionType = AccountBarChartModeTransactionType.all;
        pieChartTransactionType = AccountPieChartModeTransactionType.all;
        break;
    }

    return transactionList.isEmpty
        ? Align(child: Text(AppLocalizations.of(context)!.noTransactions))
        : Column(
            children: [
              Container(
                height: 200,
                margin: const EdgeInsets.only(
                    top: 10, bottom: 0, left: 18, right: 18),
                child: PageView(
                  children: [
                    _buildBarChart(
                      transactionList: transactionList,
                      transactionType: barChartTransactionType,
                      timeMode: selectedTransactionTimePeriod,
                    ),
                    _buildPieChart(transactionList, pieChartTransactionType),
                  ],
                ),
              ),
              Expanded(
                child: _buildTransactionListSection(transactionList),
              )
            ],
          );
  }

  Widget _buildBarChart({
    required List<Transaction> transactionList,
    required AccountBarChartModeTransactionType transactionType,
    required TransactionTimePeriod timeMode,
  }) {
    return AccountBarChart(
      transactionType: transactionType,
      transactionTimePeriod: timeMode,
      startDate: startDate,
      endDate: endDate,
      transactionList: transactionList,
    );
  }

  Widget _buildPieChart(List<Transaction> transactionList,
      AccountPieChartModeTransactionType mode) {
    return AccountPieChart(
      transactionList: transactionList,
      mode: mode,
    );
  }

  Widget _buildTransactionListSection(List<Transaction> transactionList) {
    return TransactionList(transactionList: transactionList);
  }

  Widget _buildEditAction(BuildContext context) {
    return TextButton(
      child: Text(
        AppLocalizations.of(context)!.edit,
        style: const TextStyle(color: Colors.white),
      ),
      onPressed: () => Navigator.of(context).pushNamed(
        NewAccountPage.routeName,
        arguments: widget.account,
      ),
    );
  }
}
