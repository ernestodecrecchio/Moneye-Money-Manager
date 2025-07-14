import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AboutPage extends StatelessWidget {
  static const routeName = '/aboutPage';

  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.info),
        backgroundColor: CustomColors.blue,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(child: _buildBody(context)),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 20,
      ),
      child: Column(
        children: [
          SvgPicture.asset('assets/logo/Moneye_typologo.svg'),
          const SizedBox(
            height: 20,
          ),
          Text(
            AppLocalizations.of(context)!.infoDescription,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
