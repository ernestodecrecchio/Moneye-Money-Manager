import 'package:expense_tracker/Helper/double_helper.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/notifiers/category_provider.dart';
import 'package:expense_tracker/notifiers/currency_provider.dart';
import 'package:expense_tracker/style.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum AccountPieChartModeTransactionType { income, expense, all }

class AccountPieChart extends ConsumerStatefulWidget {
  final List<Transaction> transactionList;
  final AccountPieChartModeTransactionType? mode;

  const AccountPieChart({
    super.key,
    required this.transactionList,
    this.mode,
  });

  @override
  ConsumerState<AccountPieChart> createState() => _AccountPieChartState();
}

class _AccountPieChartState extends ConsumerState<AccountPieChart> {
  int touchedIndex = -1;

  Map<int, double> categoryTotalValueMap = {};
  final List<CategoryTotalValue> categoryTotalValuePairs = [];
  double totalValue = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _loadData();
  }

  @override
  void didUpdateWidget(covariant AccountPieChart oldWidget) {
    super.didUpdateWidget(oldWidget);

    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _buildGraph(),
        ),
        const SizedBox(
          width: 30,
        ),
        Expanded(
          child: _buildIndicators(),
        )
      ],
    );
  }

  _buildGraph() {
    final currentCurrency = ref.watch(currentCurrencyProvider);
    final currentCurrencyPosition =
        ref.watch(currentCurrencySymbolPositionProvider);
    const centerSpaceRadius = 50.0;

    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              height: (centerSpaceRadius) * 2,
              width: (centerSpaceRadius) * 2,
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.total,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: CustomColors.grey,
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      widget.mode == AccountPieChartModeTransactionType.all
                          ? (categoryTotalValuePairs[0].totalValue -
                                  categoryTotalValuePairs[1].totalValue)
                              .toStringAsFixedRoundedWithCurrency(
                                  2, currentCurrency, currentCurrencyPosition)
                          : totalValue.toStringAsFixedRoundedWithCurrency(
                              2, currentCurrency, currentCurrencyPosition),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }

                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(
                show: false,
              ),
              sectionsSpace: 0,
              centerSpaceRadius: centerSpaceRadius,
              sections: showingSections(),
            ),
          ),
        ],
      ),
    );
  }

  _buildIndicators() {
    return ListView.builder(
        itemCount: categoryTotalValuePairs.length,
        itemBuilder: (context, index) {
          final currentPair = categoryTotalValuePairs[index];

          return Indicator(
            color: currentPair.category.color,
            text: currentPair.category.name,
            // value: (e.totalValue / totalValue) * 100,
            value: currentPair.totalValue,
          );
        });
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(
      categoryTotalValuePairs.length,
      (i) {
        final currentCategoryTotalValuePair = categoryTotalValuePairs[i];

        final isTouched = i == touchedIndex;
        final fontSize = isTouched ? 25.0 : 16.0;
        final radius = isTouched ? 50.0 : 40.0;
        const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

        return PieChartSectionData(
          color: currentCategoryTotalValuePair.category.color,
          value: currentCategoryTotalValuePair.totalValue,
          showTitle: false,
          title: currentCategoryTotalValuePair.category.name,
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: shadows,
          ),
          badgeWidget: isTouched
              ? Text(
                  '${((currentCategoryTotalValuePair.totalValue / totalValue) * 100).toStringAsFixedRounded(2)}%',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )
              : categoryTotalValuePairs[i].category.iconPath != null
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: SvgPicture.asset(
                        categoryTotalValuePairs[i].category.iconPath!,
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
                      ),
                    )
                  : null,
        );
      },
    );
  }

  _loadData() {
    categoryTotalValuePairs.clear();
    totalValue = 0;

    if (widget.mode == AccountPieChartModeTransactionType.all) {
      final incomeCategory = CategoryTotalValue(
        category: Category(
            id: -1,
            name: AppLocalizations.of(context)!.incomes,
            colorValue: CustomColors.income.value),
        totalValue: 0,
      );

      final expenseCategory = CategoryTotalValue(
        category: Category(
            id: -2,
            name: AppLocalizations.of(context)!.expenses,
            colorValue: CustomColors.expense.value),
        totalValue: 0,
      );

      categoryTotalValuePairs.add(incomeCategory);
      categoryTotalValuePairs.add(expenseCategory);

      for (var transaction in widget.transactionList) {
        totalValue += transaction.amount.abs();

        if (transaction.amount >= 0) {
          categoryTotalValuePairs[0].totalValue += transaction.amount;
        } else {
          categoryTotalValuePairs[1].totalValue += transaction.amount;
        }
      }

      totalValue = totalValue.abs();
      categoryTotalValuePairs[1].totalValue *= -1;
    } else {
      categoryTotalValuePairs.clear();
      totalValue = 0;

      for (var transaction in widget.transactionList) {
        totalValue += transaction.amount;

        Category? category;

        if (transaction.categoryId != null) {
          category = ref
              .read(categoryProvider.notifier)
              .getCategoryFromId(transaction.categoryId!);
        }

        if (category != null) {
          final indexFound = categoryTotalValuePairs
              .indexWhere((element) => element.category == category);

          if (indexFound != -1) {
            categoryTotalValuePairs[indexFound].totalValue +=
                transaction.amount;
          } else {
            final newEntry = CategoryTotalValue(
              category: category,
              totalValue: transaction.amount,
            );

            categoryTotalValuePairs.add(newEntry);
          }
        } else {
          _addToOtherCategoryIndicator(transaction);
        }
      }
    }

    if (widget.mode == AccountPieChartModeTransactionType.income) {
      categoryTotalValuePairs
          .sort((a, b) => a.totalValue < b.totalValue ? 1 : 0);
    } else if (widget.mode == AccountPieChartModeTransactionType.expense) {
      categoryTotalValuePairs
          .sort((a, b) => a.totalValue > b.totalValue ? 1 : 0);
    }
  }

  _addToOtherCategoryIndicator(Transaction transaction) {
    final indexFound = categoryTotalValuePairs
        .indexWhere((element) => element.category.id == null);

    if (indexFound != -1) {
      categoryTotalValuePairs[indexFound].totalValue += transaction.amount;
    } else {
      final otherEntry = CategoryTotalValue(
          category: Category(
              name: AppLocalizations.of(context)!.other,
              colorValue: Colors.grey.value),
          totalValue: transaction.amount);

      categoryTotalValuePairs.add(otherEntry);
    }
  }
}

class CategoryTotalValue {
  final Category category;
  double totalValue;

  CategoryTotalValue({required this.category, required this.totalValue});
}

class Indicator extends ConsumerWidget {
  final Color color;
  final String text;
  final double? value;

  const Indicator({
    super.key,
    required this.color,
    required this.text,
    this.value,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentCurrency = ref.watch(currentCurrencyProvider);
    final currentCurrencyPosition =
        ref.watch(currentCurrencySymbolPositionProvider);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            height: 12,
            width: 12,
            decoration: BoxDecoration(
              //  color: color,
              border: Border.all(color: color, width: 3),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: Text(
              text,
            ),
          ),
          if (value != null)
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Text(
                value!.toStringAsFixedRoundedWithCurrency(
                  2,
                  currentCurrency,
                  currentCurrencyPosition,
                ),
                textAlign: TextAlign.end,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}
