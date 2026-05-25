import 'package:collection/collection.dart';
import 'package:expense_tracker/core/configuration/constants.dart';
import 'package:expense_tracker/core/feature_discovery/feature_discovery_id.dart';
import 'package:expense_tracker/core/feature_discovery/feature_discovery_target.dart';
import 'package:expense_tracker/core/presentation/common/widgets/icon_item.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/presentation/providers/currency_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/core/utils/double_helper.dart';
import 'package:expense_tracker/features/budgeting/domain/models/budget.dart';
import 'package:expense_tracker/features/budgeting/domain/models/budget_progress.dart';
import 'package:expense_tracker/features/budgeting/presentation/pages/budget_form_page/budget_form_page.dart';
import 'package:expense_tracker/features/budgeting/presentation/providers/queries/budgets_list_notifier.dart';
import 'package:expense_tracker/features/budgeting/presentation/providers/queries/budget_progress_notifier.dart';
import 'package:expense_tracker/features/categories/domain/models/category.dart';
import 'package:expense_tracker/features/categories/presentation/providers/queries/categories_list_notifier.dart';
import 'package:expense_tracker/core/presentation/common/extensions/category_extensions.dart';
import 'package:expense_tracker/features/budgeting/presentation/extensions/budget_ui_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class BudgetListPage extends ConsumerWidget {
  const BudgetListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final budgetsAsync = ref.watch(budgetsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appLocalizations.budgeting,
        ),
      ),
      floatingActionButton: FeatureDiscoveryTarget(
        id: FeatureDiscoveryId.budgetListFab,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, BudgetFormPage.routeName);
          },
          child: const Icon(Icons.add),
        ),
      ),
      body: SafeArea(
        child: budgetsAsync.when(
          data: (budgets) {
            if (budgets.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 16,
                  children: [
                    Icon(Icons.savings_rounded,
                        size: 64,
                        color: context.appColors.textSecondary
                            .withValues(alpha: 0.5)),
                    Text(
                      appLocalizations.noBudgetsYet,
                      style: TextStyle(
                          color: context.appColors.textSecondary, fontSize: 16),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: Constants.horizontalPadding,
                vertical: Constants.horizontalPadding,
              ),
              itemCount: budgets.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return BudgetCard(budget: budgets[index]);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('Error: $e')),
        ),
      ),
    );
  }
}

class BudgetCard extends ConsumerWidget {
  final Budget budget;
  const BudgetCard({super.key, required this.budget});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(budgetProgressProvider(budget));

    return progressAsync.when(
      data: (progress) => _buildCard(context, ref, progress),
      loading: () => _buildCard(
        context,
        ref,
        budgetProgressPlaceholder(budget),
      ),
      error: (_, __) => _buildCard(
        context,
        ref,
        budgetProgressPlaceholder(budget),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    WidgetRef ref,
    BudgetProgress progress,
  ) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final currentCurrency = ref.watch(currentCurrencyProvider);
    final currentCurrencyPosition =
        ref.watch(currentCurrencySymbolPositionProvider);
    final categories = ref.watch(categoriesListProvider).asData?.value ?? [];
    final stateColor = progress.getStateColor(context);

    final selectedCategories = budget.categoryIds
        .map((id) => categories.firstWhereOrNull((c) => c.id == id))
        .nonNulls
        .toList();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.15),
            blurRadius: 15,
            spreadRadius: 0,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: Material(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BudgetFormPage(initialBudget: budget),
            ),
          ),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4,
                        children: [
                          Text(
                            budget.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            _getPeriodText(budget, progress, appLocalizations),
                            style: TextStyle(
                              fontSize: 12,
                              color: context.appColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          progress.remaining.toStringAsFixedRoundedWithCurrency(
                            2,
                            currentCurrency,
                            currentCurrencyPosition,
                          ),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: stateColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          progress.isOverBudget
                              ? appLocalizations.overBudget
                              : appLocalizations.amountRemaining,
                          style: TextStyle(
                            fontSize: 11,
                            color: context.appColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Stack(
                  children: [
                    Container(
                      height: 10,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: context.appColors.divider,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: progress.percentage.clamp(0.0, 1.0),
                      child: Container(
                        height: 10,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              stateColor.withValues(alpha: 0.7),
                              stateColor,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: stateColor.withValues(alpha: 0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 16,
                  children: [
                    _buildCategoriesRow(context, selectedCategories),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RichText(
                            textAlign: TextAlign.end,
                            text: TextSpan(
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    fontSize: 13,
                                    color: context.appColors.textSecondary,
                                  ),
                              children: [
                                TextSpan(
                                  text: progress.spent
                                      .toStringAsFixedRoundedWithCurrency(
                                    2,
                                    currentCurrency,
                                    currentCurrencyPosition,
                                  ),
                                  style: TextStyle(
                                    color: context.appColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                    text:
                                        ' ${appLocalizations.amountSpentOf} '),
                                TextSpan(
                                  text: progress.totalAllowed
                                      .toStringAsFixedRoundedWithCurrency(
                                    2,
                                    currentCurrency,
                                    currentCurrencyPosition,
                                  ),
                                  style: TextStyle(
                                    color: context.appColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      ' (${(progress.percentage * 100).toStringAsFixed(0)}%)',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: stateColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (progress.carriedOver != 0)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                '${progress.carriedOver > 0 ? "+" : ""}${progress.carriedOver.toStringAsFixedRoundedWithCurrency(2, currentCurrency, currentCurrencyPosition)} ${appLocalizations.rollover}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: progress.carriedOver > 0
                                      ? context.appColors.income
                                      : context.appColors.expense,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesRow(
      BuildContext context, List<Category> selectedCategories) {
    final displayedCategories = selectedCategories.take(4).toList();
    final showEllipsis = selectedCategories.length > 4;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ...displayedCategories.map((category) {
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: IconItem(
              backgroundColor: category.color,
              shape: BoxShape.circle,
              iconPath: category.iconPath,
              size: 24,
            ),
          );
        }),
        if (showEllipsis)
          Container(
            decoration: BoxDecoration(
              color: context.appColors.divider.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '...',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: context.appColors.textSecondary,
              ),
            ),
          ),
      ],
    );
  }

  String _getPeriodText(
      Budget budget, BudgetProgress progress, dynamic appLocalizations) {
    final DateFormat formatter = DateFormat.yMMMd(appLocalizations.localeName);
    return '${formatter.format(progress.startDate)} - ${formatter.format(progress.endDate)}';
  }
}
