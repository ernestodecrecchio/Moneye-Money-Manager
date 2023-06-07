import 'package:expense_tracker/Helper/double_helper.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/notifiers/category_provider.dart';
import 'package:expense_tracker/style.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum AccountPieChartModeTransactionType { income, expense, all }

class AccountPieChart extends StatefulWidget {
  final List<Transaction> transactionList;
  final AccountPieChartModeTransactionType? mode;

  const AccountPieChart({
    super.key,
    required this.transactionList,
    this.mode,
  });

  @override
  State<AccountPieChart> createState() => _AccountPieChartState();
}

class _AccountPieChartState extends State<AccountPieChart> {
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
          width: 20,
        ),
        Expanded(
          child: _buildIndicators(),
        )
      ],
    );
  }

  _buildGraph() {
    const centerSpaceRadius = 50.0;

    return AspectRatio(
      aspectRatio: 1,
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
                              .toStringAsFixedRoundedWithCurrency(context, 2)
                          : totalValue.toStringAsFixedRoundedWithCurrency(
                              context, 2),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ...categoryTotalValuePairs
            .map(
              (e) => Indicator(
                color: e.category.color,
                text: e.category.name,
                // value: (e.totalValue / totalValue) * 100,
                value: e.totalValue,
              ),
            )
            .toList()
      ],
    );
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

      final outcomeCategory = CategoryTotalValue(
        category: Category(
            id: -2,
            name: AppLocalizations.of(context)!.outcomes,
            colorValue: CustomColors.expense.value),
        totalValue: 0,
      );

      categoryTotalValuePairs.add(incomeCategory);
      categoryTotalValuePairs.add(outcomeCategory);

      for (var transaction in widget.transactionList) {
        totalValue += transaction.value.abs();

        if (transaction.value >= 0) {
          categoryTotalValuePairs[0].totalValue += transaction.value;
        } else {
          categoryTotalValuePairs[1].totalValue += transaction.value;
        }
      }

      totalValue = totalValue.abs();
      categoryTotalValuePairs[1].totalValue *= -1;
    } else {
      final categoryProvider =
          Provider.of<CategoryProvider>(context, listen: false);

      categoryTotalValuePairs.clear();
      totalValue = 0;

      for (var transaction in widget.transactionList) {
        totalValue += transaction.value;

        Category? category;

        if (transaction.categoryId != null) {
          category =
              categoryProvider.getCategoryFromId(transaction.categoryId!);
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
          _addToOtherCategoryIndicator(transaction);
        }
      }
    }

    // categoryTotalValuePairs.sort((a, b) => a.totalValue > b.totalValue ? 1 : 0);
  }

  _addToOtherCategoryIndicator(Transaction transaction) {
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

class CategoryTotalValue {
  final Category category;
  double totalValue;

  CategoryTotalValue({required this.category, required this.totalValue});
}

class Indicator extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
                value!.toStringAsFixedRoundedWithCurrency(context, 2),
                textAlign: TextAlign.end,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}
