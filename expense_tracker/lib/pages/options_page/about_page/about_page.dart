import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutPage extends StatelessWidget {
  static const routeName = '/aboutPage';

  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: CustomColors.blue,
        elevation: 0,
      ),
      body: SafeArea(
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 30),
      child: Column(
        children: [
          SvgPicture.asset('assets/logo/Moneye_typologo.svg'),
          const SizedBox(
            height: 20,
          ),
          Text(
            AppLocalizations.of(context)!.aboutDescription,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
