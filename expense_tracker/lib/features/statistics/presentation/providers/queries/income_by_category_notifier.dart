import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/style/style.dart';
import 'package:expense_tracker/features/categories/domain/models/category.dart';
import 'package:expense_tracker/features/categories/presentation/providers/categories_repository_provider.dart';
import 'package:expense_tracker/features/statistics/domain/logic/expenses_by_category_calculator.dart';
import 'package:expense_tracker/features/statistics/domain/models/expenses_by_category_series.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/statistics_period_provider.dart';
import 'package:expense_tracker/features/transactions/presentation/providers/transactions_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IncomeByCategoryNotifier extends AsyncNotifier<ExpensesByCategorySeries> {
  @override
  Future<ExpensesByCategorySeries> build() async {
    final period = ref.watch(statisticsPeriodProvider);
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final transactionsRepository = ref.read(transactionsRepositoryProvider);
    final categoriesRepository = ref.read(categoriesRepositoryProvider);

    final records = await transactionsRepository.getIncomeByCategoryInPeriod(
      start: period.startDate,
      end: period.endDate,
    );
    final categories = await categoriesRepository.getCategories();

    return ExpensesByCategoryCalculator.build(
      records: records,
      categories: categories,
      uncategorizedCategory: Category(
        name: appLocalizations.other,
        colorValue: CustomColors.clearGreyText.toARGB32(),
        isOtherCategory: true,
      ),
    );
  }
}

final incomeByCategoryProvider =
    AsyncNotifierProvider<IncomeByCategoryNotifier, ExpensesByCategorySeries>(
  IncomeByCategoryNotifier.new,
);
