import 'package:expense_tracker/notifiers/locale_provider.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguagesListPage extends StatefulWidget {
  static const routeName = '/languagesListPage';

  const LanguagesListPage({Key? key}) : super(key: key);

  @override
  State<LanguagesListPage> createState() => _LanguagesListPageState();
}

class _LanguagesListPageState extends State<LanguagesListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.language),
        backgroundColor: CustomColors.blue,
        elevation: 0,
      ),
      body: _buildList(),
    );
  }

  Widget _buildList() {
    return ListView(
      children: [
        ListTile(
          title: const Text('English (UK)'),
          onTap: () => Provider.of<LocaleProvider>(context, listen: false)
              .setLocale(const Locale('en')),
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
          trailing: Provider.of<LocaleProvider>(context, listen: true)
                      .locale
                      ?.languageCode ==
                  'en'
              ? const Icon(Icons.check)
              : null,
        ),
        ListTile(
          title: const Text('Italiano'),
          onTap: () => Provider.of<LocaleProvider>(context, listen: false)
              .setLocale(const Locale('it')),
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
          trailing: Provider.of<LocaleProvider>(context, listen: true)
                      .locale
                      ?.languageCode ==
                  'it'
              ? const Icon(Icons.check)
              : null,
        ),
      ],
    );
  }
}
