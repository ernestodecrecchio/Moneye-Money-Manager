import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/core/presentation/providers/locale_provider.dart';
import 'package:expense_tracker/core/presentation/common/widgets/safe_vector_graphic.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguagesListPage extends ConsumerStatefulWidget {
  static const routeName = '/languagesListPage';

  const LanguagesListPage({super.key});

  @override
  ConsumerState<LanguagesListPage> createState() => _LanguagesListPageState();
}

class _LanguagesListPageState extends ConsumerState<LanguagesListPage> {
  @override
  Widget build(BuildContext context) {
    final appLocalizations = ref.watch(appLocalizationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.language),
      ),
      body: _buildList(context, appLocalizations),
    );
  }

  Widget _buildList(BuildContext context, AppLocalizations appLocalizations) {
    final currentLocale = ref.watch(localeProvider);

    return ListView(
      children: [
        _buildLanguageTile(
          context: context,
          title: appLocalizations.systemLanguageOption,
          iconPath: 'assets/flags/World.svg',
          locale: null,
          currentLocale: currentLocale,
          iconColor: context.appColors.secondary,
          fit: BoxFit.fill,
        ),
        const Divider(height: 1),
        _buildLanguageTile(
          context: context,
          title: 'English (UK)',
          iconPath: 'assets/flags/United_Kingdom.svg',
          locale: const Locale('en', 'GB'),
          currentLocale: currentLocale,
        ),
        _buildLanguageTile(
          context: context,
          title: 'English (US)',
          iconPath: 'assets/flags/United_States.svg',
          locale: const Locale('en', 'US'),
          currentLocale: currentLocale,
        ),
        _buildLanguageTile(
          context: context,
          title: 'Italiano',
          iconPath: 'assets/flags/Italy.svg',
          locale: const Locale('it'),
          currentLocale: currentLocale,
        ),
        _buildLanguageTile(
          context: context,
          title: 'Español',
          iconPath: 'assets/flags/Spain.svg',
          locale: const Locale('es'),
          currentLocale: currentLocale,
        ),
        _buildLanguageTile(
          context: context,
          title: 'Deutsch',
          iconPath: 'assets/flags/Germany.svg',
          locale: const Locale('de'),
          currentLocale: currentLocale,
        ),
        _buildLanguageTile(
          context: context,
          title: 'Français',
          iconPath: 'assets/flags/France.svg',
          locale: const Locale('fr'),
          currentLocale: currentLocale,
        ),
        _buildLanguageTile(
          context: context,
          title: 'Türkçe',
          iconPath: 'assets/flags/Turkey.svg',
          locale: const Locale('tr'),
          currentLocale: currentLocale,
        ),
        _buildLanguageTile(
          context: context,
          title: 'Português (Brasil)',
          iconPath: 'assets/flags/Brazil.svg',
          locale: const Locale('pt', 'BR'),
          currentLocale: currentLocale,
        ),
        _buildLanguageTile(
          context: context,
          title: 'Português (Portugal)',
          iconPath: 'assets/flags/Portugal.svg',
          locale: const Locale('pt', 'PT'),
          currentLocale: currentLocale,
        ),
      ],
    );
  }

  Widget _buildLanguageTile({
    required BuildContext context,
    required String title,
    required String iconPath,
    required Locale? locale,
    required Locale? currentLocale,
    Color? iconColor,
    BoxFit fit = BoxFit.cover,
  }) {
    final isSelected = locale == null
        ? currentLocale == null
        : currentLocale?.languageCode == locale.languageCode &&
            currentLocale?.countryCode == locale.countryCode;

    return ListTile(
      title: Text(title),
      onTap: () {
        if (locale == null) {
          ref.read(localeProvider.notifier).resetLocale();
        } else {
          ref.read(localeProvider.notifier).updateLocale(locale);
        }
      },
      leading: Container(
        clipBehavior: Clip.antiAlias,
        height: 30,
        width: 30,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: SafeVectorGraphic(
          iconPath: iconPath,
          colorFilterEnabled: iconColor != null,
          color: iconColor,
          fit: fit,
        ),
      ),
      trailing: isSelected ? const Icon(Icons.check) : null,
    );
  }
}
