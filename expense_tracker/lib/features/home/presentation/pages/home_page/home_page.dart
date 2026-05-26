import 'package:expense_tracker/core/services/widget_extension_service.dart';
import 'package:expense_tracker/features/home/presentation/pages/home_page/home_account_section.dart';
import 'package:expense_tracker/features/home/presentation/pages/home_page/home_last_transactions_list.dart';
import 'package:expense_tracker/features/home/presentation/pages/home_page/home_flexible_app_bar.dart';
import 'package:expense_tracker/features/home/presentation/pages/home_page/home_app_bar.dart';
import 'package:expense_tracker/features/home/presentation/pages/home_page/home_budget_section.dart';
import 'package:expense_tracker/features/home/presentation/widgets/revolut_style_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Opens new transaction page when app is in background
    WidgetExtensionService().listenWidgetClick();

    // Opens new transaction page when app is closed
    WidgetExtensionService().checkForWidgetLaunch();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          automaticallyImplyLeading: false,
          expandedHeight: 190,
          flexibleSpace: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return FlexibleSpaceBar(
                title: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: constraints.biggest.height ==
                          MediaQuery.of(context).padding.top + kToolbarHeight
                      ? 1.0
                      : 0.0,
                  child: const HomeAppBar(),
                ),
                background: const HomeFlexibleSpaceBar(),
              );
            },
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            <Widget>[
              AccountSection(),
              const SizedBox(height: 8),
              HomeBudgetSection(),
              const SizedBox(height: 8),
              LastTransactionsList(),
            ],
          ),
        ),
        const TabBarScrollBottomSliver(),
      ],
    );
  }
}
