import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/style/style.dart';
import 'package:expense_tracker/features/categories/domain/models/category.dart';
import 'package:expense_tracker/features/categories/presentation/providers/categories_repository_provider.dart';
import 'package:expense_tracker/features/statistics/domain/logic/category_comparison_calculator.dart';
import 'package:expense_tracker/features/statistics/domain/models/category_comparison_series.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/statistics_period_provider.dart';
import 'package:expense_tracker/features/transactions/presentation/providers/transactions_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryComparisonNotifier extends AsyncNotifier<CategoryComparisonSeries> {
  @override
  Future<CategoryComparisonSeries> build() async {
    final period = ref.watch(statisticsPeriodProvider);
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final transactionsRepository = ref.read(transactionsRepositoryProvider);
    final categoriesRepository = ref.read(categoriesRepositoryProvider);

    final records =
        await transactionsRepository.getExpensesByCategoryAndMonthInPeriod(
      start: period.startDate,
      end: period.endDate,
    );
    final categories = await categoriesRepository.getCategories();

    return CategoryComparisonCalculator.build(
      period: period,
      records: records,
      categories: categories,
      uncategorizedCategory: Category(
        name: appLocalizations.other,
        colorValue: CustomColors.clearGreyText.toARGB32(),
        isOtherCategory: true,
      ),
      locale: appLocalizations.localeName,
    );
  }
}

final categoryComparisonProvider =
    AsyncNotifierProvider<CategoryComparisonNotifier, CategoryComparisonSeries>(
  CategoryComparisonNotifier.new,
);
