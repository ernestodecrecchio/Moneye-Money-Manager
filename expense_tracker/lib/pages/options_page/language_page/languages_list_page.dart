import 'package:expense_tracker/l10n/l10n.dart';
import 'package:expense_tracker/notifiers/locale_provider.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
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
          title: const Text('English'),
          onTap: () => Provider.of<LocaleProvider>(context, listen: false)
              .setLocale(const Locale('en')),
        ),
        ListTile(
          title: const Text('Italiano'),
          onTap: () => Provider.of<LocaleProvider>(context, listen: false)
              .setLocale(const Locale('it')),
        ),
      ],
    );
  }
}
