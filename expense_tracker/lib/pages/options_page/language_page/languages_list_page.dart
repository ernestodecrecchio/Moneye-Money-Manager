import 'package:expense_tracker/notifiers/locale_provider.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguagesListPage extends ConsumerStatefulWidget {
  static const routeName = '/languagesListPage';

  const LanguagesListPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LanguagesListPage> createState() => _LanguagesListPageState();
}

class _LanguagesListPageState extends ConsumerState<LanguagesListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.language),
        backgroundColor: CustomColors.blue,
        elevation: 0,
      ),
      body: _buildList(context),
    );
  }

  Widget _buildList(BuildContext context) {
    final currentLocale = ref.watch(localeProvider);

    return ListView(
      children: [
        ListTile(
          title: Text(AppLocalizations.of(context)!.systemLanguageOption),
          onTap: () => ref.read(localeProvider.notifier).resetLocale(),
          leading: Container(
            clipBehavior: Clip.antiAlias,
            height: 30,
            width: 30,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: SvgPicture.asset(
              'assets/flags/World.svg',
              fit: BoxFit.fill,
              colorFilter: const ColorFilter.mode(
                  CustomColors.darkBlue, BlendMode.srcIn),
            ),
          ),
          trailing: currentLocale == null ? const Icon(Icons.check) : null,
        ),
        const Divider(
          height: 1,
        ),
        ListTile(
          title: const Text('English (UK)'),
          onTap: () => ref
              .read(localeProvider.notifier)
              .updateLocale(const Locale('en')),
          leading: Container(
            clipBehavior: Clip.antiAlias,
            height: 30,
            width: 30,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: SvgPicture.asset(
              'assets/flags/United-Kingdom.svg',
              fit: BoxFit.cover,
            ),
          ),
          trailing: currentLocale?.languageCode == 'en'
              ? const Icon(Icons.check)
              : null,
        ),
        ListTile(
          title: const Text('Italiano'),
          onTap: () => ref
              .read(localeProvider.notifier)
              .updateLocale(const Locale('it')),
          leading: Container(
            clipBehavior: Clip.antiAlias,
            height: 30,
            width: 30,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: SvgPicture.asset(
              'assets/flags/Italy.svg',
              fit: BoxFit.cover,
            ),
          ),
          trailing: currentLocale?.languageCode == 'it'
              ? const Icon(Icons.check)
              : null,
        ),
        ListTile(
          title: const Text('Español'),
          onTap: () => ref
              .read(localeProvider.notifier)
              .updateLocale(const Locale('es')),
          leading: Container(
            clipBehavior: Clip.antiAlias,
            height: 30,
            width: 30,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: SvgPicture.asset(
              'assets/flags/Spain.svg',
              fit: BoxFit.cover,
            ),
          ),
          trailing: currentLocale?.languageCode == 'es'
              ? const Icon(Icons.check)
              : null,
        ),
        ListTile(
          title: const Text('Deutsch'),
          onTap: () => ref
              .read(localeProvider.notifier)
              .updateLocale(const Locale('de')),
          leading: Container(
            clipBehavior: Clip.antiAlias,
            height: 30,
            width: 30,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: SvgPicture.asset(
              'assets/flags/Germany.svg',
              fit: BoxFit.cover,
            ),
          ),
          trailing: currentLocale?.languageCode == 'de'
              ? const Icon(Icons.check)
              : null,
        ),
      ],
    );
  }
}
