import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/style/style.dart';
import 'package:expense_tracker/features/accounts/domain/models/account.dart';
import 'package:expense_tracker/features/accounts/presentation/providers/accounts_repository_provider.dart';
import 'package:expense_tracker/features/categories/domain/models/category.dart';
import 'package:expense_tracker/features/categories/presentation/providers/categories_repository_provider.dart';
import 'package:expense_tracker/features/statistics/domain/logic/categories_statistics_calculator.dart';
import 'package:expense_tracker/features/statistics/domain/logic/category_account_breakdown_calculator.dart';
import 'package:expense_tracker/features/statistics/domain/logic/category_monthly_trend_calculator.dart';
import 'package:expense_tracker/features/statistics/domain/models/category_statistics_detail.dart';
import 'package:expense_tracker/features/statistics/domain/models/category_statistics_entry.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/statistics_period_provider.dart';
import 'package:expense_tracker/features/transactions/presentation/providers/transactions_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryStatisticsDetailNotifier extends AsyncNotifier<CategoryStatisticsDetail> {
  CategoryStatisticsDetailNotifier(this.category);

  final Category category;

  @override
  Future<CategoryStatisticsDetail> build() async {
    final period = ref.watch(statisticsPeriodProvider);
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final transactionsRepository = ref.read(transactionsRepositoryProvider);
    final categoriesRepository = ref.read(categoriesRepositoryProvider);

    final uncategorizedCategory = Category(
      name: appLocalizations.other,
      colorValue: CustomColors.clearGreyText.toARGB32(),
      isOtherCategory: true,
    );

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

    final series = CategoriesStatisticsCalculator.build(
      expenseRecords: expenseRecords,
      incomeRecords: incomeRecords,
      categories: categories,
      uncategorizedCategory: uncategorizedCategory,
    );

    final summary = _findSummary(series.entries, category) ??
        CategoryStatisticsEntry(
          category: category,
          amount: 0,
          percentage: 0,
          amountType: CategoryStatisticsAmountType.expense,
        );

    final categoryId = _categoryIdForQuery(category);
    final monthlyExpenseRecords =
        await transactionsRepository.getExpensesByCategoryAndMonthInPeriod(
      start: period.startDate,
      end: period.endDate,
    );
    final monthlyIncomeRecords =
        await transactionsRepository.getIncomeByCategoryAndMonthInPeriod(
      start: period.startDate,
      end: period.endDate,
    );

    final monthlySourceRecords = summary.isExpense
        ? monthlyExpenseRecords
        : monthlyIncomeRecords;

    final monthlyTrend = CategoryMonthlyTrendCalculator.build(
      period: period,
      monthlyRecords: [
        for (final record in monthlySourceRecords)
          if (record.categoryId == categoryId)
            (monthStart: record.monthStart, amount: record.amount),
      ],
      locale: appLocalizations.localeName,
    );

    final uncategorizedAccount = Account(
      name: appLocalizations.other,
      colorValue: CustomColors.clearGreyText.toARGB32(),
      isOtherAccount: true,
    );
    final accounts = await ref.read(accountsRepositoryProvider).getAccounts();
    final accountSourceRecords = summary.isExpense
        ? await transactionsRepository.getExpensesByAccountForCategoryInPeriod(
            start: period.startDate,
            end: period.endDate,
            category: category,
          )
        : await transactionsRepository.getIncomeByAccountForCategoryInPeriod(
            start: period.startDate,
            end: period.endDate,
            category: category,
          );
    final accountBreakdown = CategoryAccountBreakdownCalculator.build(
      records: accountSourceRecords,
      accounts: accounts,
      uncategorizedAccount: uncategorizedAccount,
    );

    final transactions = await transactionsRepository.getTransactions(
      startDate: period.startDate,
      endDate: period.endDate,
      forCategory: category,
    );

    final reportableTransactions = transactions
        .where((transaction) => transaction.includeInReports)
        .toList();

    return CategoryStatisticsDetail(
      summary: summary,
      monthlyTrend: monthlyTrend,
      accountBreakdown: accountBreakdown,
      transactions: reportableTransactions,
    );
  }

  int? _categoryIdForQuery(Category category) {
    if (category.isOtherCategory) {
      return null;
    }

    return category.id;
  }

  CategoryStatisticsEntry? _findSummary(
    List<CategoryStatisticsEntry> entries,
    Category category,
  ) {
    for (final entry in entries) {
      if (_isSameCategory(entry.category, category)) {
        return entry;
      }
    }

    return null;
  }

  bool _isSameCategory(Category left, Category right) {
    if (left.isOtherCategory && right.isOtherCategory) {
      return true;
    }

    return left.id != null && left.id == right.id;
  }
}

final categoryStatisticsDetailProvider = AsyncNotifierProvider.family<
    CategoryStatisticsDetailNotifier,
    CategoryStatisticsDetail,
    Category>(
  CategoryStatisticsDetailNotifier.new,
);
