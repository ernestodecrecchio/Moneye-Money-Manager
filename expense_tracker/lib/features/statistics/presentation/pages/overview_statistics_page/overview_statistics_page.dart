import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_subpage_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OverviewStatisticsPage extends ConsumerWidget {
  static const routeName = '/statisticsOverviewPage';

  const OverviewStatisticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);

    return StatisticsSubpageScaffold(
      title: appLocalizations.statisticsOverviewTitle,
      message: appLocalizations.statisticsOverviewComingSoon,
      icon: Icons.pie_chart_outline_rounded,
    );
  }
}
