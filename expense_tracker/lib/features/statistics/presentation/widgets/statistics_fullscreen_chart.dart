import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef StatisticsFullscreenChartBuilder = Widget Function({
  required bool expanded,
});

Future<void> openStatisticsFullscreenChart({
  required BuildContext context,
  required String title,
  required StatisticsFullscreenChartBuilder chartBuilder,
}) {
  return Navigator.of(context).push<void>(
    MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (context) => StatisticsFullscreenChartPage(
        title: title,
        chartBuilder: chartBuilder,
      ),
    ),
  );
}

class StatisticsFullscreenChartPage extends ConsumerStatefulWidget {
  const StatisticsFullscreenChartPage({
    super.key,
    required this.title,
    required this.chartBuilder,
  });

  final String title;
  final StatisticsFullscreenChartBuilder chartBuilder;

  @override
  ConsumerState<StatisticsFullscreenChartPage> createState() =>
      _StatisticsFullscreenChartPageState();
}

class _StatisticsFullscreenChartPageState
    extends ConsumerState<StatisticsFullscreenChartPage> {
  @override
  void initState() {
    super.initState();
    _enterFullscreenLandscape();
  }

  Future<void> _enterFullscreenLandscape() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  Future<void> _exitFullscreenLandscape() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Future<void> _close() async {
    await _exitFullscreenLandscape();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final appLocalizations = ref.watch(appLocalizationsProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) {
          return;
        }
        await _close();
      },
      child: Scaffold(
        backgroundColor: colors.surface,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: StatisticsLayout.sectionSpacing,
              children: [
                Row(
                  spacing: 12,
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: StatisticsLayout.cardTitleStyle(context),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      onPressed: _close,
                      tooltip: appLocalizations.statisticsChartExitFullscreen,
                      icon: const Icon(Icons.fullscreen_exit),
                    ),
                  ],
                ),
                Expanded(
                  child: widget.chartBuilder(expanded: true),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
