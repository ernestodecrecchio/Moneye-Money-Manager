import 'package:collection/collection.dart';
import 'package:expense_tracker/Helper/date_time_helper.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/notifiers/account_provider.dart';
import 'package:expense_tracker/notifiers/category_provider.dart';
import 'package:expense_tracker/notifiers/transaction_provider.dart';
import 'package:expense_tracker/pages/account_detail_page/account_bar_chart.dart';
import 'package:expense_tracker/pages/account_detail_page/account_pie_chart.dart';
import 'package:expense_tracker/pages/account_detail_page/transaction_list_page.dart';
import 'package:expense_tracker/pages/common/custom_modal_bottom_sheet.dart';
import 'package:expense_tracker/pages/common/list_tiles/transaction_list_cell.dart';
import 'package:expense_tracker/pages/options_page/accounts_page/new_edit_account_page.dart';
import 'package:expense_tracker/pages/new_edit_transaction_flow/new_edit_transaction_page.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum TransactionTimePeriod {
  day,
  week,
  month,
  year,
  custom,
}

enum AccountDetailTransactionListMode {
  transactionList,
  forCategory,
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

  Widget _buildIncomePage() {
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

    return transactionList.isEmpty
        ? Align(
            child: Text(AppLocalizations.of(context)!.noTransactions),
          )
        : Column(
            children: [
              //  _buildLineChart(    transactionList, AccountPieChartModeTransactionType.income),
              _buildBarChart(
                transactionList: transactionList,
                transactionType: AccountBarChartModeTransactionType.income,
                timeMode: selectedTransactionTimePeriod,
              ),
              _buildPieChart(
                  transactionList, AccountPieChartModeTransactionType.income),
              Expanded(
                child: _buildTransactionListSection(transactionList),
              )
            ],
          );
  }

  Widget _buildOutcomePage() {
    List<Transaction> transactionList = [];

    final transactionProvider =
        Provider.of<TransactionProvider>(context, listen: true);

    if (widget.account != null) {
      transactionList = transactionProvider.transactionList
          .where(
            (element) =>
                element.accountId == widget.account!.id &&
                element.value < 0 &&
                element.date.isAfterIncludingZero(startDate) &&
                element.date.isBeforeIncludingZero(endDate),
          )
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

    return transactionList.isEmpty
        ? Align(child: Text(AppLocalizations.of(context)!.noTransactions))
        : Column(
            children: [
              // _buildLineChart(   transactionList, AccountPieChartModeTransactionType.expense),
              _buildBarChart(
                transactionList: transactionList,
                transactionType: AccountBarChartModeTransactionType.expense,
                timeMode: selectedTransactionTimePeriod,
              ),
              _buildPieChart(
                  transactionList, AccountPieChartModeTransactionType.expense),
              Expanded(
                child: _buildTransactionListSection(transactionList),
              )
            ],
          );
  }

  Widget _buildTotalPage() {
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

    return transactionList.isEmpty
        ? Align(child: Text(AppLocalizations.of(context)!.noTransactions))
        : Column(
            children: [
              //_buildLineChart(  transactionList, AccountPieChartModeTransactionType.all),
              _buildBarChart(
                transactionList: transactionList,
                transactionType: AccountBarChartModeTransactionType.all,
                timeMode: selectedTransactionTimePeriod,
              ),
              _buildPieChart(
                  transactionList, AccountPieChartModeTransactionType.all),
              Expanded(
                child: _buildTransactionListSection(transactionList),
              )
            ],
          );
  }

/*
  Widget _buildLineChart(List<Transaction> transactionList,
      AccountPieChartModeTransactionType mode) {
    return transactionList.isEmpty
        ? Expanded(
            child: Align(
                child: Text(AppLocalizations.of(context)!.noTransactions)))
        : Container(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
            child: AccountLineChart(
              mode: TimeMode.day,
              startDate: startDate,
              endDate: endDate,
              transactionList: transactionList,
            ),
          );
  }
  */

  Widget _buildBarChart({
    required List<Transaction> transactionList,
    required AccountBarChartModeTransactionType transactionType,
    required TransactionTimePeriod timeMode,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
      height: 200,
      child: AccountBarChart(
        transactionType: transactionType,
        timeMode: timeMode,
        startDate: startDate,
        endDate: endDate,
        transactionList: transactionList,
      ),
    );
  }

  Widget _buildPieChart(List<Transaction> transactionList,
      AccountPieChartModeTransactionType mode) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
      child: AccountPieChart(
        transactionList: transactionList,
        mode: mode,
      ),
    );
  }

  Widget _buildTransactionListSection(List<Transaction> transactionList) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text(
              'Transaction list',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                transactionListMode = transactionListMode ==
                        AccountDetailTransactionListMode.transactionList
                    ? AccountDetailTransactionListMode.forCategory
                    : AccountDetailTransactionListMode.transactionList;

                setState(() {});
              },
              style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  alignment: Alignment.centerLeft),
              child: Text(
                transactionListMode ==
                        AccountDetailTransactionListMode.transactionList
                    ? AppLocalizations.of(context)!.byList
                    : AppLocalizations.of(context)!.byCategory,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ]),
        ),
        Expanded(
          child: transactionListMode ==
                  AccountDetailTransactionListMode.transactionList
              ? _buildTransactionList(transactionList)
              : _buildCategoryList(transactionList),
        )
      ],
    );
  }

  Widget _buildTransactionList(List<Transaction> transactionList) {
    return ListView.builder(
      itemCount: transactionList.length,
      itemBuilder: (context, index) => TransactionListCell(
        transaction: transactionList[index],
        showAccountLabel: false,
      ),
    );
  }

  Widget _buildCategoryList(List<Transaction> transactionList) {
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);

    final List<CategoryTotalValue> categoryTotalValuePairs = [];

    categoryTotalValuePairs.clear();

    for (var transaction in transactionList) {
      Category? category;

      if (transaction.categoryId != null) {
        category = categoryProvider.getCategoryFromId(transaction.categoryId!);
      }

      if (category != null) {
        final indexFound = categoryTotalValuePairs
            .indexWhere((element) => element.category == category);

        if (indexFound != -1) {
          categoryTotalValuePairs[indexFound].totalValue += transaction.value;
        } else {
          final newEntry = CategoryTotalValue(
            category: category,
            totalValue: transaction.value,
          );

          categoryTotalValuePairs.add(newEntry);
        }
      } else {
        final indexFound = categoryTotalValuePairs
            .indexWhere((element) => element.category.id == null);

        if (indexFound != -1) {
          categoryTotalValuePairs[indexFound].totalValue += transaction.value;
        } else {
          final otherEntry = CategoryTotalValue(
              category: Category(
                  name: AppLocalizations.of(context)!.other,
                  colorValue: Colors.grey.value),
              totalValue: transaction.value);

          categoryTotalValuePairs.add(otherEntry);
        }
      }
    }

    return ListView.builder(
      itemCount: categoryTotalValuePairs.length,
      itemBuilder: (context, index) => _buildCategoryListCell(
        categoryTotalValuePair: categoryTotalValuePairs[index],
        transactionList: transactionList
            .where((transaction) =>
                transaction.categoryId ==
                categoryTotalValuePairs[index].category.id)
            .toList(),
      ),
    );
  }

  _buildCategoryListCell(
      {required CategoryTotalValue categoryTotalValuePair,
      required List<Transaction> transactionList}) {
    return InkWell(
      onTap: () => Navigator.of(context)
          .pushNamed(TransactionList.routeName, arguments: transactionList),
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 17),
        child: Row(
          children: [
            _buildCategoryIcon(context, categoryTotalValuePair.category),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    categoryTotalValuePair.category.name,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    categoryTotalValuePair.totalValue.toString(),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
            ),
          ],
        ),
      ),
    );
  }

  _buildCategoryIcon(BuildContext context, Category category) {
    SvgPicture? categoryIcon;
    if (category.iconPath != null) {
      categoryIcon = SvgPicture.asset(
        category.iconPath!,
        colorFilter: const ColorFilter.mode(
          Colors.white,
          BlendMode.srcIn,
        ),
      );
    }

    return Container(
      width: 32,
      height: 32,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(shape: BoxShape.circle, color: category.color),
      child: categoryIcon,
    );
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
