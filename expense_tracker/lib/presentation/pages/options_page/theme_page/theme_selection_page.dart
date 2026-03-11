import 'package:expense_tracker/application/common/notifiers/app_localizations_provider.dart';
import 'package:expense_tracker/application/common/notifiers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeSelectionPage extends ConsumerWidget {
  static const routeName = '/themeSelectionPage';

  const ThemeSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final currentThemeMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.theme),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(appLocalizations.systemTheme),
            leading: const Icon(Icons.brightness_auto_rounded),
            trailing: currentThemeMode == ThemeMode.system
                ? const Icon(Icons.check)
                : null,
            onTap: () => ref
                .read(themeProvider.notifier)
                .updateThemeMode(ThemeMode.system),
          ),
          const Divider(),
          ListTile(
            title: Text(appLocalizations.lightTheme),
            leading: const Icon(Icons.light_mode_rounded),
            trailing: currentThemeMode == ThemeMode.light
                ? const Icon(Icons.check)
                : null,
            onTap: () => ref
                .read(themeProvider.notifier)
                .updateThemeMode(ThemeMode.light),
          ),
          const Divider(),
          ListTile(
            title: Text(appLocalizations.darkTheme),
            leading: const Icon(Icons.dark_mode_rounded),
            trailing: currentThemeMode == ThemeMode.dark
                ? const Icon(Icons.check)
                : null,
            onTap: () => ref
                .read(themeProvider.notifier)
                .updateThemeMode(ThemeMode.dark),
          ),
        ],
      ),
    );
  }
}
