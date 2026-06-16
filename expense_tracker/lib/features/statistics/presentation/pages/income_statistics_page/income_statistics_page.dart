import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_subpage_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IncomeStatisticsPage extends ConsumerWidget {
  static const routeName = '/statisticsIncomePage';

  const IncomeStatisticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);

    return StatisticsSubpageScaffold(
      title: appLocalizations.statisticsIncomeTitle,
      message: appLocalizations.statisticsIncomeComingSoon,
      icon: Icons.trending_up_rounded,
    );
  }
}
