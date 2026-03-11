import 'package:expense_tracker/Helper/double_helper.dart';
import 'package:expense_tracker/application/categories/notifiers/queries/categories_list_notifier.dart';
import 'package:expense_tracker/application/common/notifiers/app_localizations_provider.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/domain/models/category.dart';
import 'package:expense_tracker/domain/models/transaction.dart';
import 'package:expense_tracker/application/common/notifiers/currency_provider.dart';
import 'package:expense_tracker/style/app_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vector_graphics/vector_graphics.dart';
import 'package:collection/collection.dart';

enum AccountPieChartModeTransactionType { income, expense, all }

class AccountPieChart extends ConsumerStatefulWidget {
  final List<Transaction> transactionList;
  final AccountPieChartModeTransactionType mode;

  const AccountPieChart({
    super.key,
    required this.transactionList,
    required this.mode,
  });

  @override
  ConsumerState<AccountPieChart> createState() => _AccountPieChartState();
}

class _AccountPieChartState extends ConsumerState<AccountPieChart> {
  int touchedIndex = -1;

  /// Processes the [widget.transactionList] and returns the calculated
  /// [categoryTotalValuePairs] and the [totalValue].
  (List<CategoryTotalValue> pairs, double total) _calculateData(
    AppColors colors,
    AppLocalizations appLocalizations,
  ) {
    final List<CategoryTotalValue> categoryTotalValuePairs = [];
    double totalValue = 0;

    switch (widget.mode) {
      case AccountPieChartModeTransactionType.all:
        final incomeCategory = CategoryTotalValue(
          category: Category(
            id: -1,
            name: appLocalizations.incomes,
            colorValue: colors.income.toARGB32(),
          ),
          totalValue: 0,
        );

        final expenseCategory = CategoryTotalValue(
          category: Category(
              id: -2,
              name: appLocalizations.expenses,
              colorValue: colors.expense.toARGB32()),
          totalValue: 0,
        );

        categoryTotalValuePairs.add(incomeCategory);
        categoryTotalValuePairs.add(expenseCategory);

        double absoluteTotal = 0;
        for (var transaction in widget.transactionList) {
          absoluteTotal += transaction.amount.abs();

          if (transaction.amount >= 0) {
            categoryTotalValuePairs[0].totalValue += transaction.amount;
          } else {
            categoryTotalValuePairs[1].totalValue += transaction.amount;
          }
        }

        totalValue = absoluteTotal;
        categoryTotalValuePairs[1].totalValue *= -1;

      case AccountPieChartModeTransactionType.income:
      case AccountPieChartModeTransactionType.expense:
        final categories =
            ref.watch(categoriesListProvider).asData?.value ?? [];

        for (var transaction in widget.transactionList) {
          totalValue += transaction.amount;

          Category? category;
          if (transaction.categoryId != null) {
            category = categories.firstWhereOrNull(
              (element) => element.id == transaction.categoryId,
            );
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
            // Handle "Other" category
            final indexFound = categoryTotalValuePairs
                .indexWhere((element) => element.category.id == null);

            if (indexFound != -1) {
              categoryTotalValuePairs[indexFound].totalValue +=
                  transaction.amount;
            } else {
              final otherEntry = CategoryTotalValue(
                  category: Category(
                    name: appLocalizations.other,
                    colorValue: colors.textSecondary.toARGB32(),
                  ),
                  totalValue: transaction.amount);
              categoryTotalValuePairs.add(otherEntry);
            }
          }
        }

        if (widget.mode == AccountPieChartModeTransactionType.income) {
          categoryTotalValuePairs
              .sort((a, b) => a.totalValue < b.totalValue ? 1 : -1);
        } else if (widget.mode == AccountPieChartModeTransactionType.expense) {
          categoryTotalValuePairs
              .sort((a, b) => a.totalValue > b.totalValue ? 1 : -1);
        }

        if (totalValue != 0) {
          for (var pair in categoryTotalValuePairs) {
            pair.percentage = (pair.totalValue / totalValue * 100).abs();
          }
        }
    }

    return (categoryTotalValuePairs, totalValue);
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final colors = context.appColors;
    final (categoryTotalValuePairs, totalValue) =
        _calculateData(colors, appLocalizations);

    return Row(
      spacing: 30,
      children: <Widget>[
        Expanded(
          child: _buildGraph(
              appLocalizations, colors, categoryTotalValuePairs, totalValue),
        ),
        Expanded(
          child: _buildIndicators(categoryTotalValuePairs),
        )
      ],
    );
  }

  Padding _buildGraph(
    AppLocalizations appLocalizations,
    AppColors colors,
    List<CategoryTotalValue> categoryTotalValuePairs,
    double totalValue,
  ) {
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
                    appLocalizations.total,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.textSecondary,
                        ),
                  ),
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      widget.mode == AccountPieChartModeTransactionType.all
                          ? (categoryTotalValuePairs.isNotEmpty
                              ? (categoryTotalValuePairs[0].totalValue -
                                      categoryTotalValuePairs[1].totalValue)
                                  .toStringAsFixedRoundedWithCurrency(2,
                                      currentCurrency, currentCurrencyPosition)
                              : 0.0.toStringAsFixedRoundedWithCurrency(
                                  2, currentCurrency, currentCurrencyPosition))
                          : totalValue.toStringAsFixedRoundedWithCurrency(
                              2, currentCurrency, currentCurrencyPosition),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
              sections: showingSections(categoryTotalValuePairs, totalValue),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the list of indicators (category names and values) next to the chart.
  ListView _buildIndicators(List<CategoryTotalValue> pairs) {
    return ListView.builder(
        itemCount: pairs.length,
        itemBuilder: (context, index) {
          final currentPair = pairs[index];

          return Indicator(
            color: currentPair.category.color,
            text: currentPair.category.name,
            value: currentPair.totalValue,
          );
        });
  }

  /// Returns the section data for the [PieChart] based on the calculated [pairs].
  List<PieChartSectionData> showingSections(
      List<CategoryTotalValue> pairs, double totalValue) {
    return List.generate(
      pairs.length,
      (i) {
        final currentCategoryTotalValuePair = pairs[i];

        final isTouched = i == touchedIndex;
        final radius = isTouched ? 50.0 : 40.0;

        return PieChartSectionData(
          color: currentCategoryTotalValuePair.category.color,
          value: currentCategoryTotalValuePair.totalValue.abs(),
          showTitle: false,
          title: currentCategoryTotalValuePair.category.name,
          radius: radius,
          badgeWidget: isTouched
              ? Text(
                  '${((currentCategoryTotalValuePair.totalValue / totalValue) * 100).toStringAsFixedRounded(2)}%',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )
              : pairs[i].category.iconPath != null && pairs[i].percentage > 5
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: VectorGraphic(
                        loader: AssetBytesLoader(pairs[i].category.iconPath!),
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
                      ),
                    )
                  : null,
        );
      },
    );
  }
}

class CategoryTotalValue {
  final Category category;
  double totalValue;
  double percentage;

  CategoryTotalValue({
    required this.category,
    required this.totalValue,
    this.percentage = 0.0,
  });
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
              // color: color,
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
              style: Theme.of(context).textTheme.bodyMedium,
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
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
        ],
      ),
    );
  }
}
