import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/features/statistics/presentation/pages/spending_statistics_page/spending_expenses_by_category_section.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/queries/income_by_category_notifier.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_surface_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IncomeByCategorySection extends ConsumerWidget {
  const IncomeByCategorySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final seriesAsync = ref.watch(incomeByCategoryProvider);

    return seriesAsync.when(
      data: (series) {
        if (series.isEmpty) {
          return _IncomeByCategoryCard(
            title: appLocalizations.statisticsIncomeByCategory,
            child: _EmptyChartMessage(
              message: appLocalizations.statisticsNoTransactionsInPeriod,
            ),
          );
        }

        return _IncomeByCategoryCard(
          title: appLocalizations.statisticsIncomeByCategory,
          child: ExpensesByCategoryBarChart(series: series),
        );
      },
      loading: () => _IncomeByCategoryCard(
        title: appLocalizations.statisticsIncomeByCategory,
        child: const SizedBox(
          height: 180,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (_, __) => _IncomeByCategoryCard(
        title: appLocalizations.statisticsIncomeByCategory,
        child: _EmptyChartMessage(
          message: appLocalizations.statisticsIncomeByCategoryError,
        ),
      ),
    );
  }
}

class _IncomeByCategoryCard extends StatelessWidget {
  const _IncomeByCategoryCard({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return StatisticsSurfaceCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _EmptyChartMessage extends StatelessWidget {
  const _EmptyChartMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.divider.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          color: colors.textSecondary,
        ),
      ),
    );
  }
}
