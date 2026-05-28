import 'package:expense_tracker/core/configuration/constants.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/presentation/providers/currency_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/core/utils/double_helper.dart';
import 'package:expense_tracker/features/budgeting/domain/models/budget.dart';
import 'package:expense_tracker/features/budgeting/domain/models/budget_progress.dart';
import 'package:expense_tracker/features/budgeting/presentation/pages/budget_form_page/budget_form_page.dart';
import 'package:expense_tracker/features/budgeting/presentation/providers/queries/budgets_list_notifier.dart';
import 'package:expense_tracker/features/budgeting/presentation/providers/queries/budget_progress_notifier.dart';
import 'package:expense_tracker/features/budgeting/presentation/extensions/budget_ui_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Fixed width for each compact budget tile in the horizontal list.
/// Horizontal [ListView] children are unbounded on the main axis; this
/// prevents intrinsic content (e.g. long titles) from stretching tiles.
const double _kCompactBudgetTileWidth = 96.0;

Widget _buildBudgetCardWrapper({
  required BuildContext context,
  required VoidCallback onTap,
  required Widget child,
  EdgeInsetsGeometry padding = const EdgeInsets.all(10),
  BorderRadius borderRadius = const BorderRadius.all(Radius.circular(10)),
}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: borderRadius,
      boxShadow: const [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.08),
          blurRadius: 8,
          spreadRadius: 0,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Material(
      color: context.appColors.surface,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    ),
  );
}

class HomeBudgetSection extends ConsumerWidget {
  const HomeBudgetSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final budgetsAsync = ref.watch(budgetsListProvider);

    return budgetsAsync.when(
      data: (budgets) {
        if (budgets.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Constants.horizontalPadding, vertical: 8),
              child: Text(
                appLocalizations.budgeting,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (budgets.length == 1)
              Padding(
                padding: EdgeInsets.only(
                    left: Constants.horizontalPadding,
                    right: Constants.horizontalPadding,
                    bottom: 8),
                child: ExpandedBudgetCard(budget: budgets.first),
              )
            else
              SizedBox(
                height: 120,
                child: ListView.separated(
                  clipBehavior: Clip.none,
                  padding: EdgeInsets.symmetric(
                      horizontal: Constants.horizontalPadding),
                  scrollDirection: Axis.horizontal,
                  itemCount: budgets.length,
                  itemBuilder: (context, index) {
                    return CompactBudgetCard(budget: budgets[index]);
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                    width: 12,
                  ),
                ),
              ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }
}

/// Full-width tile used when there is exactly one budget.
/// Uses a horizontal layout with a linear progress bar.
class ExpandedBudgetCard extends ConsumerWidget {
  final Budget budget;

  const ExpandedBudgetCard({
    super.key,
    required this.budget,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(budgetProgressProvider(budget));

    return progressAsync.when(
      data: (progress) => _buildContent(context, ref, progress),
      loading: () => _buildContent(
        context,
        ref,
        budgetProgressPlaceholder(budget),
      ),
      error: (_, __) => _buildContent(
        context,
        ref,
        budgetProgressPlaceholder(budget),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    BudgetProgress progress,
  ) {
    final currentCurrency = ref.watch(currentCurrencyProvider);
    final currentCurrencyPosition =
        ref.watch(currentCurrencySymbolPositionProvider);

    final stateColor = progress.getStateColor(context);
    final percentText = '${(progress.percentage * 100).toStringAsFixed(0)}%';

    return _buildBudgetCardWrapper(
      context: context,
      onTap: () => Navigator.pushNamed(
        context,
        BudgetFormPage.routeName,
        arguments: budget,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 6,
        children: [
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: Text(
                  budget.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: context.appColors.textPrimary,
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 12,
                    color: context.appColors.textSecondary,
                  ),
                  children: [
                    TextSpan(
                      text: progress.spent.toStringAsFixedRoundedWithCurrency(
                        2,
                        currentCurrency,
                        currentCurrencyPosition,
                      ),
                      style: TextStyle(
                        color: context.appColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(text: ' / '),
                    TextSpan(
                      text: progress.totalAllowed
                          .toStringAsFixedRoundedWithCurrency(
                        2,
                        currentCurrency,
                        currentCurrencyPosition,
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress.percentage.clamp(0.0, 1.0),
                    minHeight: 8,
                    backgroundColor: context.budgetProgressTrackColor,
                    valueColor: AlwaysStoppedAnimation<Color>(stateColor),
                  ),
                ),
              ),
              Text(
                percentText,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: stateColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Compact card used when there are multiple budgets.
/// Vertically stacked: circular progress, amount/total, name.
class CompactBudgetCard extends ConsumerWidget {
  final Budget budget;

  const CompactBudgetCard({
    super.key,
    required this.budget,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(budgetProgressProvider(budget));

    return progressAsync.when(
      data: (progress) => _buildContent(context, ref, progress),
      loading: () => _buildContent(
        context,
        ref,
        budgetProgressPlaceholder(budget),
      ),
      error: (_, __) => _buildContent(
        context,
        ref,
        budgetProgressPlaceholder(budget),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    BudgetProgress progress,
  ) {
    final currentCurrency = ref.watch(currentCurrencyProvider);
    final currentCurrencyPosition =
        ref.watch(currentCurrencySymbolPositionProvider);

    final stateColor = progress.getStateColor(context);

    return SizedBox(
      width: _kCompactBudgetTileWidth,
      child: _buildBudgetCardWrapper(
        context: context,
        onTap: () => Navigator.pushNamed(
          context,
          BudgetFormPage.routeName,
          arguments: budget,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 46,
                    height: 46,
                    child: CircularProgressIndicator(
                      value: progress.percentage.clamp(0.0, 1.0),
                      strokeWidth: 4,
                      strokeCap: StrokeCap.round,
                      backgroundColor: context.budgetProgressTrackColor,
                      valueColor: AlwaysStoppedAnimation<Color>(stateColor),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '${(progress.percentage * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: stateColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 11,
                    color: context.appColors.textSecondary,
                  ),
                  children: [
                    TextSpan(
                      text: progress.spent.toStringAsFixedRoundedWithCurrency(
                        2,
                        currentCurrency,
                        currentCurrencyPosition,
                      ),
                      style: TextStyle(
                        color: context.appColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(text: ' / '),
                    TextSpan(
                      text: progress.totalAllowed
                          .toStringAsFixedRoundedWithCurrency(
                        2,
                        currentCurrency,
                        currentCurrencyPosition,
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              budget.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: context.appColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
