import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/presentation/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeSelectionPage extends ConsumerWidget {
  static const routeName = '/themeSelectionPage';

  const ThemeSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final currentThemeMode = ref.watch(themeProvider);

    final activeThemes =
        AppThemeMode.values.where((mode) => mode.isEnabled).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.theme),
      ),
      body: ListView.separated(
        itemCount: activeThemes.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final mode = activeThemes[index];
          return ListTile(
            title: Text(mode.getName(appLocalizations)),
            leading: Icon(mode.icon),
            trailing: currentThemeMode == mode
                ? const Icon(Icons.check_rounded)
                : null,
            onTap: () => ref.read(themeProvider.notifier).updateThemeMode(mode),
          );
        },
      ),
    );
  }
}
