import 'package:expense_tracker/Helper/double_helper.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/notifiers/currency_provider.dart';
import 'package:expense_tracker/notifiers/transaction_provider.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeFlexibleSpaceBar extends ConsumerStatefulWidget {
  const HomeFlexibleSpaceBar({super.key});

  @override
  ConsumerState<HomeFlexibleSpaceBar> createState() =>
      _HomeFlexibleSpaceBarState();
}

class _HomeFlexibleSpaceBarState extends ConsumerState<HomeFlexibleSpaceBar> {
  AppLocalizations? appLocalizations;
  static const double horizontalPadding = 18;
  final double appBarHeight = 66.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    appLocalizations = AppLocalizations.of(context)!;
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.only(top: statusBarHeight),
      height: statusBarHeight + appBarHeight,
      color: CustomColors.blue,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildMonthlyBalanceSection(),
        ],
      )),
    );
  }

  Widget _buildMonthlyBalanceSection() {
    final currentCurrency = ref.watch(currentCurrencyProvider);
    final currentCurrencyPosition =
        ref.watch(currentCurrencySymbolPositionProvider);

    final List<Transaction> currentMonthTransactions =
        ref.read(transactionProvider.notifier).currentMonthTransactionList;

    double monthlyIncome = 0;
    double monthlyExpenses = 0;
    for (var transaction in currentMonthTransactions) {
      transaction.value >= 0
          ? monthlyIncome += transaction.value
          : monthlyExpenses += transaction.value;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Text(
              appLocalizations!.financialOverviewForThisMonth,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Text(
              appLocalizations!.totalBalance,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Row(
              children: [
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      ref
                          .read(transactionProvider.notifier)
                          .totalBalance
                          .toStringAsFixedRoundedWithCurrency(
                              2, currentCurrency, currentCurrencyPosition),
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
          ),
          const SizedBox(
            height: 14,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Row(
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
                        Text(
                          appLocalizations!.outcomes,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          monthlyExpenses.toStringAsFixedRoundedWithCurrency(
                              2, currentCurrency, currentCurrencyPosition),
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
                        Text(
                          appLocalizations!.incomes,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          monthlyIncome.toStringAsFixedRoundedWithCurrency(
                              2, currentCurrency, currentCurrencyPosition),
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
          ),
        ],
      ),
    );
  }

  Widget _buildPercentageDifference() {
    return Consumer(
      builder: (context, ref, child) {
        final currMonthDate = DateTime.now();
        final prevMonthDate =
            DateTime(currMonthDate.year, currMonthDate.month, 1);

        double currMonthBalance = ref
            .watch(transactionProvider.notifier)
            .getTotalBanalceUntilDate(currMonthDate);
        double prevMonthBalance = ref
            .watch(transactionProvider.notifier)
            .getTotalBanalceUntilDate(prevMonthDate);

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
}
