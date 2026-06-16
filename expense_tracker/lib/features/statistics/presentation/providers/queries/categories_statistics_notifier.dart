import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/style/style.dart';
import 'package:expense_tracker/features/categories/domain/models/category.dart';
import 'package:expense_tracker/features/categories/presentation/providers/categories_repository_provider.dart';
import 'package:expense_tracker/features/statistics/domain/logic/categories_statistics_calculator.dart';
import 'package:expense_tracker/features/statistics/domain/models/categories_statistics_series.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/statistics_period_provider.dart';
import 'package:expense_tracker/features/transactions/presentation/providers/transactions_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesStatisticsNotifier
    extends AsyncNotifier<CategoriesStatisticsSeries> {
  @override
  Future<CategoriesStatisticsSeries> build() async {
    final period = ref.watch(statisticsPeriodProvider);
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final transactionsRepository = ref.read(transactionsRepositoryProvider);
    final categoriesRepository = ref.read(categoriesRepositoryProvider);

    final expenseRecords =
        await transactionsRepository.getExpensesByCategoryInPeriod(
      start: period.startDate,
      end: period.endDate,
    );
    final incomeRecords =
        await transactionsRepository.getIncomeByCategoryInPeriod(
      start: period.startDate,
      end: period.endDate,
    );
    final categories = await categoriesRepository.getCategories();

    return CategoriesStatisticsCalculator.build(
      expenseRecords: expenseRecords,
      incomeRecords: incomeRecords,
      categories: categories,
      uncategorizedCategory: Category(
        name: appLocalizations.other,
        colorValue: CustomColors.clearGreyText.toARGB32(),
        isOtherCategory: true,
      ),
    );
  }
}

final categoriesStatisticsProvider =
    AsyncNotifierProvider<CategoriesStatisticsNotifier, CategoriesStatisticsSeries>(
  CategoriesStatisticsNotifier.new,
);
