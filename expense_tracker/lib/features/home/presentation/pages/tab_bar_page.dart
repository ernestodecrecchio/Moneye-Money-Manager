import 'package:expense_tracker/core/configuration/analytics_manager.dart';
import 'package:expense_tracker/core/presentation/providers/analytics_consent_provider.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/presentation/common/widgets/safe_vector_graphic.dart';
import 'package:expense_tracker/features/budgeting/presentation/pages/budget_form_page/budget_form_page.dart';
import 'package:expense_tracker/features/home/presentation/pages/home_page/home_page.dart';
import 'package:expense_tracker/features/budgeting/presentation/pages/budget_list_page/budget_list_page.dart';
import 'package:expense_tracker/features/settings/presentation/pages/options_page/options_page.dart';
import 'package:expense_tracker/features/home/presentation/widgets/tab_bar/revolut_bottom_bar_item.dart';
import 'package:expense_tracker/features/home/presentation/widgets/tab_bar/revolut_style_bottom_bar.dart';
import 'package:expense_tracker/features/home/presentation/widgets/tab_bar/tab_bar_theme.dart';
import 'package:expense_tracker/features/home/presentation/widgets/tab_bar/tab_bar_shell.dart';
import 'package:expense_tracker/features/transactions/presentation/pages/new_edit_transaction_flow/new_edit_transaction_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  Widget? _buildFloatingActionButton() {
    return switch (index) {
      0 => FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () =>
              Navigator.pushNamed(context, NewEditTransactionPage.routeName),
          child: const Icon(Icons.add),
        ),
      1 => FloatingActionButton(
          onPressed: () =>
              Navigator.pushNamed(context, BudgetFormPage.routeName),
          child: const Icon(Icons.add),
        ),
      _ => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = ref.watch(appLocalizationsProvider);

    return Scaffold(
      extendBody: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          TabBarBody(
            child: IndexedStack(
              index: index,
              children: [
                TabBarScrollScope(
                  bottomScrollPadding: context.tabBarScrollBottomInset(
                    includeFab: true,
                  ),
                  child: const HomePage(),
                ),
                TabBarScrollScope(
                  bottomScrollPadding: context.tabBarScrollBottomInset(
                    includeFab: true,
                  ),
                  child: const BudgetListPage(),
                ),
                TabBarScrollScope(
                  bottomScrollPadding: context.tabBarScrollBottomInset(
                    includeFab: false,
                  ),
                  child: const OptionsPage(),
                ),
              ],
            ),
          ),
          const BottomBarBodyFade(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: const FabAboveTabBarLocation(),
      bottomNavigationBar: Material(
        type: MaterialType.transparency,
        child: RevolutStyleBottomBar(
          currentIndex: index,
          onTap: (newIndex) => setState(() => index = newIndex),
          items: [
            RevolutBottomBarItem(
              label: 'Dashboard',
              iconBuilder: (_, color) => SafeVectorGraphic(
                iconPath: 'assets/icons/transactions.svg',
                color: color,
                height: 22,
                width: 22,
              ),
            ),
            RevolutBottomBarItem(
              label: appLocalizations.budgeting,
              icon: Icons.savings_rounded,
            ),
            RevolutBottomBarItem(
              label: appLocalizations.settings,
              icon: CupertinoIcons.gear_solid,
            ),
          ],
        ),
      ),
    );
  }
}
