import 'package:expense_tracker/application/common/notifiers/app_localizations_provider.dart';
import 'package:expense_tracker/presentation/pages/home_page/home_page.dart';
import 'package:expense_tracker/presentation/pages/options_page/options_page.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
          selectedItemColor: CustomColors.blue,
          unselectedItemColor: Colors.grey,
          onTap: (newIndex) {
            setState(() => index = newIndex);
          },
          items: [
            SalomonBottomBarItem(
              icon: VectorGraphic(
                loader: AssetBytesLoader('assets/icons/transactions.svg'),
                colorFilter: ColorFilter.mode(
                    index == 0 ? CustomColors.blue : Colors.grey,
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
