import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/features/statistics/presentation/pages/spending_statistics_page/spending_monthly_trend_section.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/queries/monthly_income_trend_notifier.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_surface_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IncomeMonthlyTrendSection extends ConsumerWidget {
  const IncomeMonthlyTrendSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final colors = context.appColors;
    final seriesAsync = ref.watch(monthlyIncomeTrendProvider);

    return seriesAsync.when(
      data: (series) {
        if (series.hasInsufficientData) {
          return _MonthlyTrendCard(
            title: appLocalizations.statisticsIncomeMonthlyTrend,
            child: _EmptyChartMessage(
              message:
                  appLocalizations.statisticsIncomeMonthlyTrendInsufficientData,
            ),
          );
        }

        if (series.isEmpty) {
          return _MonthlyTrendCard(
            title: appLocalizations.statisticsIncomeMonthlyTrend,
            child: _EmptyChartMessage(
              message: appLocalizations.statisticsNoTransactionsInPeriod,
            ),
          );
        }

        return _MonthlyTrendCard(
          title: appLocalizations.statisticsIncomeMonthlyTrend,
          child: MonthlySpendingTrendLineChart(
            series: series,
            lineColor: colors.income,
          ),
        );
      },
      loading: () => _MonthlyTrendCard(
        title: appLocalizations.statisticsIncomeMonthlyTrend,
        child: const SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (_, __) => _MonthlyTrendCard(
        title: appLocalizations.statisticsIncomeMonthlyTrend,
        child: _EmptyChartMessage(
          message: appLocalizations.statisticsIncomeMonthlyTrendError,
        ),
      ),
    );
  }
}

class _MonthlyTrendCard extends StatelessWidget {
  const _MonthlyTrendCard({
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
      height: 200,
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
