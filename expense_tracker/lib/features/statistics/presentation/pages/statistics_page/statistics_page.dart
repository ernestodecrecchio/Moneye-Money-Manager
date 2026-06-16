import 'package:expense_tracker/core/configuration/constants.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/features/home/presentation/widgets/tab_bar/tab_bar_shell.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class StatisticsPage extends ConsumerWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text(appLocalizations.statistics),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              Constants.horizontalPadding,
              Constants.horizontalPadding,
              Constants.horizontalPadding,
              0,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _StatisticsPeriodSelector(
                  appLocalizations: appLocalizations,
                ),
                const SizedBox(height: 16),
                _StatisticsOverviewPreviewCard(
                  appLocalizations: appLocalizations,
                ),
                const SizedBox(height: 16),
                _StatisticsNavigationSection(
                  appLocalizations: appLocalizations,
                ),
              ]),
            ),
          ),
          const TabBarScrollBottomSliver(),
        ],
      ),
    );
  }
}

class _StatisticsPeriodSelector extends StatelessWidget {
  const _StatisticsPeriodSelector({required this.appLocalizations});

  final AppLocalizations appLocalizations;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;
    final periodLabel =
        DateFormat.yMMMM(appLocalizations.localeName).format(DateTime.now());

    return _StatisticsSurfaceCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          FilledButton(
            onPressed: () {},
            style: FilledButton.styleFrom(
              backgroundColor: colors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              minimumSize: const Size(0, 36),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  appLocalizations.month,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down_rounded,
                  color: colors.onPrimary,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              periodLabel,
              textAlign: TextAlign.end,
              style: textTheme.bodySmall?.copyWith(
                fontSize: 14,
                color: colors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 10),
          _PeriodChevronButton(
            icon: Icons.chevron_left_rounded,
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          _PeriodChevronButton(
            icon: Icons.chevron_right_rounded,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _PeriodChevronButton extends StatelessWidget {
  const _PeriodChevronButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        minimumSize: const Size(35, 35),
        elevation: 0,
        backgroundColor: colors.primary,
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Icon(icon),
    );
  }
}

class _StatisticsOverviewPreviewCard extends StatelessWidget {
  const _StatisticsOverviewPreviewCard({required this.appLocalizations});

  final AppLocalizations appLocalizations;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final placeholder = appLocalizations.statisticsPlaceholderValue;

    return _StatisticsSurfaceCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Text(
                appLocalizations.statisticsOverviewTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                appLocalizations.statisticsOverviewPreviewSubtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _OverviewMetric(
                  label: appLocalizations.income,
                  value: placeholder,
                  valueColor: colors.income,
                ),
              ),
              Expanded(
                child: _OverviewMetric(
                  label: appLocalizations.expense,
                  value: placeholder,
                  valueColor: colors.expense,
                ),
              ),
              Expanded(
                child: _OverviewMetric(
                  label: appLocalizations.statisticsNetBalance,
                  value: placeholder,
                  valueColor: colors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OverviewMetric extends StatelessWidget {
  const _OverviewMetric({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: colors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: valueColor,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}

class _StatisticsNavigationSection extends StatelessWidget {
  const _StatisticsNavigationSection({required this.appLocalizations});

  final AppLocalizations appLocalizations;

  @override
  Widget build(BuildContext context) {
    final items = [
      _StatisticsNavItem(
        title: appLocalizations.statisticsOverviewTitle,
        description: appLocalizations.statisticsOverviewDescription,
        icon: Icons.pie_chart_outline_rounded,
      ),
      _StatisticsNavItem(
        title: appLocalizations.statisticsSpendingTitle,
        description: appLocalizations.statisticsSpendingDescription,
        icon: Icons.trending_down_rounded,
      ),
      _StatisticsNavItem(
        title: appLocalizations.statisticsIncomeTitle,
        description: appLocalizations.statisticsIncomeDescription,
        icon: Icons.trending_up_rounded,
      ),
      _StatisticsNavItem(
        title: appLocalizations.statisticsCashflowTitle,
        description: appLocalizations.statisticsCashflowDescription,
        icon: Icons.swap_horiz_rounded,
      ),
      _StatisticsNavItem(
        title: appLocalizations.statisticsCategoriesTitle,
        description: appLocalizations.statisticsCategoriesDescription,
        icon: Icons.grid_view_rounded,
      ),
      _StatisticsNavItem(
        title: appLocalizations.statisticsInsightsTitle,
        description: appLocalizations.statisticsInsightsDescription,
        icon: Icons.lightbulb_outline_rounded,
      ),
    ];

    return _StatisticsSurfaceCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            _StatisticsNavCard(item: items[i]),
            if (i < items.length - 1)
              Divider(
                height: 1,
                indent: 68,
                color: context.appColors.divider.withValues(alpha: 0.5),
              ),
          ],
        ],
      ),
    );
  }
}

class _StatisticsNavItem {
  const _StatisticsNavItem({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;
}

class _StatisticsNavCard extends StatelessWidget {
  const _StatisticsNavCard({required this.item});

  final _StatisticsNavItem item;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 14,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                item.icon,
                color: colors.primary,
                size: 22,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    item.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: colors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatisticsSurfaceCard extends StatelessWidget {
  const _StatisticsSurfaceCard({
    required this.child,
    this.padding,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
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
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: padding != null ? Padding(padding: padding!, child: child) : child,
      ),
    );
  }
}
