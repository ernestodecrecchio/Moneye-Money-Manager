import 'package:expense_tracker/configuration/analytics_manager.dart';
import 'package:expense_tracker/application/common/notifiers/analytics_consent_provider.dart';
import 'package:expense_tracker/application/common/notifiers/app_localizations_provider.dart';
import 'package:expense_tracker/presentation/pages/home_page/home_page.dart';
import 'package:expense_tracker/presentation/pages/options_page/options_page.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/style/app_theme.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:vector_graphics/vector_graphics.dart';

class TabBarPage extends ConsumerStatefulWidget {
  static const routeName = '/TabBarPage';

  const TabBarPage({super.key});

  @override
  ConsumerState<TabBarPage> createState() => _TabBarPageState();
}

class _TabBarPageState extends ConsumerState<TabBarPage> {
  int index = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAnalyticsConsent();
    });
  }

  void _checkAnalyticsConsent() {
    final consent = ref.read(analyticsConsentProvider);
    if (consent == null) {
      AnalyticsManager.showConsentDialog(context: context, ref: ref);
    }
  }

  final screen = [
    const HomePage(),
    const OptionsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final appLocalizations = ref.watch(appLocalizationsProvider);

    return Scaffold(
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: index,
          selectedItemColor: context.appColors.primary,
          unselectedItemColor: context.appColors.textSecondary,
          onTap: (newIndex) {
            setState(() => index = newIndex);
          },
          items: [
            SalomonBottomBarItem(
              icon: VectorGraphic(
                loader: AssetBytesLoader('assets/icons/transactions.svg'),
                colorFilter: ColorFilter.mode(
                    index == 0
                        ? context.appColors.primary
                        : context.appColors.textSecondary,
                    BlendMode.srcIn),
              ),
              title: const Text(
                'Dashboard',
                style: TextStyle(fontFamily: 'Ubuntu'),
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
        body: screen[index]);
  }
}
