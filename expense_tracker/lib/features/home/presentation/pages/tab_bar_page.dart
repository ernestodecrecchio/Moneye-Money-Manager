import 'package:expense_tracker/core/configuration/analytics_manager.dart';
import 'package:expense_tracker/core/feature_discovery/feature_discovery.dart';
import 'package:expense_tracker/core/feature_discovery/feature_discovery_id.dart';
import 'package:expense_tracker/core/feature_discovery/feature_discovery_target.dart';
import 'package:expense_tracker/core/presentation/providers/analytics_consent_provider.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/presentation/common/widgets/safe_vector_graphic.dart';
import 'package:expense_tracker/features/home/presentation/pages/home_page/home_page.dart';
import 'package:expense_tracker/features/budgeting/presentation/pages/budget_list_page/budget_list_page.dart';
import 'package:expense_tracker/features/settings/presentation/pages/options_page/options_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class TabBarPage extends ConsumerStatefulWidget {
  static const routeName = '/TabBarPage';

  const TabBarPage({super.key});

  @override
  ConsumerState<TabBarPage> createState() => _TabBarPageState();
}

class _TabBarPageState extends ConsumerState<TabBarPage> {
  int index = 0;
  bool _homeDiscoveryTriggered = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAnalyticsConsent();
      _tryShowHomeDiscovery();
    });
  }

  void _tryShowHomeDiscovery() {
    if (_homeDiscoveryTriggered || !mounted) return;
    if (ref.read(analyticsConsentProvider) == null) return;
    _homeDiscoveryTriggered = true;
    FeatureDiscovery.scheduleShowSequence(
      context: context,
      ref: ref,
      ids: const [
        FeatureDiscoveryId.homeFab,
        FeatureDiscoveryId.budgetTab,
      ],
      delay: const Duration(milliseconds: 500),
    );
  }

  void _checkAnalyticsConsent() {
    final consent = ref.read(analyticsConsentProvider);
    if (consent == null) {
      AnalyticsManager.showConsentDialog(context: context, ref: ref);
    }
  }

  final screen = [
    const HomePage(),
    const BudgetListPage(),
    const OptionsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final appLocalizations = ref.watch(appLocalizationsProvider);

    ref.listen(analyticsConsentProvider, (previous, next) {
      if (next != null) _tryShowHomeDiscovery();
    });

    return Scaffold(
        bottomNavigationBar: Stack(
          clipBehavior: Clip.none,
          children: [
            SalomonBottomBar(
              currentIndex: index,
              selectedItemColor: context.appColors.primary,
              unselectedItemColor: context.appColors.textSecondary,
              onTap: (newIndex) {
                setState(() => index = newIndex);
                if (newIndex == 1) {
                  FeatureDiscovery.scheduleShowSequence(
                    context: context,
                    ref: ref,
                    ids: const [FeatureDiscoveryId.budgetListFab],
                  );
                } else if (newIndex == 2) {
                  FeatureDiscovery.scheduleShowSequence(
                    context: context,
                    ref: ref,
                    ids: const [
                      FeatureDiscoveryId.recurringTransactionsSettings,
                      FeatureDiscoveryId.backupRestore,
                    ],
                  );
                }
              },
              items: [
                SalomonBottomBarItem(
                  icon: SafeVectorGraphic(
                    iconPath: 'assets/icons/transactions.svg',
                    color: index == 0
                        ? context.appColors.primary
                        : context.appColors.textSecondary,
                  ),
                  title: const Text(
                    'Dashboard',
                    style: TextStyle(fontFamily: 'Ubuntu'),
                  ),
                ),
                SalomonBottomBarItem(
                  icon: Icon(
                    Icons.savings_rounded,
                    color: index == 1
                        ? context.appColors.primary
                        : context.appColors.textSecondary,
                  ),
                  title: Text(
                    appLocalizations.budgeting,
                    style: const TextStyle(fontFamily: 'Ubuntu'),
                  ),
                ),
                SalomonBottomBarItem(
                  icon: const Icon(CupertinoIcons.gear_solid),
                  title: Text(
                    appLocalizations.settings,
                    style: const TextStyle(fontFamily: 'Ubuntu'),
                  ),
                ),
              ],
            ),
            // Anchor outside SalomonBottomBar animations (avoids duplicate GlobalKey).
            Positioned.fill(
              child: IgnorePointer(
                child: Row(
                  children: [
                    const Expanded(child: SizedBox.shrink()),
                    Expanded(
                      child: Center(
                        child: FeatureDiscoveryTarget(
                          id: FeatureDiscoveryId.budgetTab,
                          child: const SizedBox(width: 72, height: 48),
                        ),
                      ),
                    ),
                    const Expanded(child: SizedBox.shrink()),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: screen[index]);
  }
}
