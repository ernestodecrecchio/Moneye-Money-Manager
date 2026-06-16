import 'package:expense_tracker/core/presentation/providers/currency_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/core/utils/double_helper.dart';
import 'package:expense_tracker/features/statistics/domain/models/average_monthly_amount.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_surface_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AverageMonthlyAmountCard extends StatelessWidget {
  const AverageMonthlyAmountCard({
    super.key,
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

class AverageMonthlyAmountContent extends ConsumerWidget {
  const AverageMonthlyAmountContent({
    super.key,
    required this.average,
    required this.valueColor,
    required this.monthsLabel,
    required this.description,
  });

  final AverageMonthlyAmount average;
  final Color valueColor;
  final String monthsLabel;
  final String description;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final currency = ref.watch(currentCurrencyProvider);
    final currencyPosition = ref.watch(currentCurrencySymbolPositionProvider);

    final amountLabel = average.averageAmount.toStringAsFixedRoundedWithCurrency(
      2,
      currency,
      currencyPosition,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          amountLabel,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: valueColor,
            letterSpacing: -0.5,
          ),
        ),
        Text(
          monthsLabel,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: colors.textSecondary,
          ),
        ),
        Text(
          description,
          style: TextStyle(
            fontSize: 13,
            height: 1.4,
            color: colors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class AverageMonthlyAmountEmptyMessage extends StatelessWidget {
  const AverageMonthlyAmountEmptyMessage({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Text(
      message,
      style: TextStyle(
        fontSize: 14,
        height: 1.5,
        color: colors.textSecondary,
      ),
    );
  }
}
