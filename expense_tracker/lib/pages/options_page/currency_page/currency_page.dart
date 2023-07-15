import 'package:expense_tracker/notifiers/currency_provider.dart';
import 'package:expense_tracker/pages/common/custom_modal_bottom_sheet.dart';
import 'package:expense_tracker/pages/common/custom_text_field.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CurrencyPage extends StatefulWidget {
  static const routeName = '/currencyPage';

  const CurrencyPage({super.key});

  @override
  State<CurrencyPage> createState() => _CurrencyPageState();
}

class _CurrencyPageState extends State<CurrencyPage> {
  final _currencySymbolPositionInput = TextEditingController();
  final _currencySymbolInput = TextEditingController();

  final double exampleValue = 1234.567;

  @override
  void dispose() {
    super.dispose();

    _currencySymbolPositionInput.dispose();
    _currencySymbolInput.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final currencyProvider =
        Provider.of<CurrencyProvider>(context, listen: false);

    if (currencyProvider.currentCurrencySymbol != null) {
      _currencySymbolInput.text =
          getCurrencyDescription(currencyProvider.currentCurrencySymbol!);
    }

    if (currencyProvider.currentCurrencySymbolPosition != null) {
      _currencySymbolPositionInput.text = getCurrencySymbolPositionDescription(
          currencyProvider.currentCurrencySymbolPosition!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.currency),
        backgroundColor: CustomColors.blue,
        elevation: 0,
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 17),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0, top: 30),
                  child: _buildBody()),
            ),
          ],
        ),
      ),
    );
  }

  _buildBody() {
    return Consumer<CurrencyProvider>(
      builder: (context, currencyProvider, child) {
        return Column(
          children: [
            _buildCurrencyPreview(currencyProvider),
            const SizedBox(
              height: 14,
            ),
            _buildCurrencySymbolTextField(currencyProvider),
            const SizedBox(
              height: 4,
            ),
            Text(
              AppLocalizations.of(context)!.currencyConversionDisclaimer,
              style: const TextStyle(
                  color: CustomColors.clearGreyText, fontSize: 12),
            ),
            const SizedBox(
              height: 14,
            ),
            _buildCurrencySymbolPositionTextField(currencyProvider),
          ],
        );
      },
    );
  }

  Widget _buildCurrencyPreview(CurrencyProvider currencyProvider) {
    TextSpan currencySymbolTextSpan = TextSpan(
        text: getSymbolForCurrency(currencyProvider.currentCurrencySymbol!),
        style: const TextStyle(fontWeight: FontWeight.bold));

    TextSpan exampleValueTextSpan = TextSpan(
      text: exampleValue.toStringAsFixed(2),
      style: const TextStyle(color: CustomColors.clearGreyText),
    );

    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: RichText(
            text: TextSpan(
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 40,
                ),
                children: [
              if (currencyProvider.currentCurrencySymbolPosition ==
                  CurrencySymbolPosition.leading)
                currencySymbolTextSpan,
              exampleValueTextSpan,
              if (currencyProvider.currentCurrencySymbolPosition ==
                  CurrencySymbolPosition.trailing)
                currencySymbolTextSpan,
            ])));
  }

  Widget _buildCurrencySymbolTextField(CurrencyProvider currencyProvider) {
    return CustomTextField(
      controller: _currencySymbolInput,
      label: AppLocalizations.of(context)!.currency,
      readOnly: true,
      icon: Icons.chevron_right_rounded,
      onTap: () async {
        await showCustomModalBottomSheet(
          context: context,
          builder: ((context) {
            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 17),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            AppLocalizations.of(context)!.selectCurrency,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        ListTile(
                          title: const Text('EUR - €'),
                          trailing: currencyProvider.currentCurrencySymbol ==
                                  CurrencyEnum.eur
                              ? SvgPicture.asset('assets/icons/checkmark.svg')
                              : null,
                          onTap: () {
                            currencyProvider
                                .setCurrencySymbol(CurrencyEnum.eur);

                            _currencySymbolInput.text = 'EUR - €';
                            setState(() {});

                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          title: const Text('GBP - £'),
                          trailing: currencyProvider.currentCurrencySymbol ==
                                  CurrencyEnum.gbp
                              ? SvgPicture.asset('assets/icons/checkmark.svg')
                              : null,
                          onTap: () {
                            currencyProvider
                                .setCurrencySymbol(CurrencyEnum.gbp);

                            _currencySymbolInput.text = 'GBP - £';
                            setState(() {});

                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          title: const Text('JPY - ¥'),
                          trailing: currencyProvider.currentCurrencySymbol ==
                                  CurrencyEnum.jpy
                              ? SvgPicture.asset('assets/icons/checkmark.svg')
                              : null,
                          onTap: () {
                            currencyProvider
                                .setCurrencySymbol(CurrencyEnum.jpy);

                            _currencySymbolInput.text = 'JPY - ¥';
                            setState(() {});

                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          title: const Text('USD - \$'),
                          trailing: currencyProvider.currentCurrencySymbol ==
                                  CurrencyEnum.usd
                              ? SvgPicture.asset('assets/icons/checkmark.svg')
                              : null,
                          onTap: () {
                            currencyProvider
                                .setCurrencySymbol(CurrencyEnum.usd);

                            _currencySymbolInput.text = 'USD - \$';
                            setState(() {});

                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          title: const Text('CHF - CHF'),
                          trailing: currencyProvider.currentCurrencySymbol ==
                                  CurrencyEnum.chf
                              ? SvgPicture.asset('assets/icons/checkmark.svg')
                              : null,
                          onTap: () {
                            currencyProvider
                                .setCurrencySymbol(CurrencyEnum.chf);

                            _currencySymbolInput.text = 'CHF - CHF';
                            setState(() {});

                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildCurrencySymbolPositionTextField(
      CurrencyProvider currencyProvider) {
    return CustomTextField(
      controller: _currencySymbolPositionInput,
      label: AppLocalizations.of(context)!.currencyPosition,
      readOnly: true,
      icon: Icons.chevron_right_rounded,
      onTap: () async {
        await showCustomModalBottomSheet(
          context: context,
          builder: ((context) {
            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 17),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            AppLocalizations.of(context)!
                                .selectCurrencyPosition,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        ListTile(
                          title: Text(AppLocalizations.of(context)!.none),
                          trailing: currencyProvider
                                      .currentCurrencySymbolPosition ==
                                  CurrencySymbolPosition.none
                              ? SvgPicture.asset('assets/icons/checkmark.svg')
                              : null,
                          onTap: () {
                            currencyProvider.setCurrencySymbolPosition(
                                CurrencySymbolPosition.none);

                            _currencySymbolPositionInput.text =
                                AppLocalizations.of(context)!.none;

                            setState(() {});

                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          title: Text(AppLocalizations.of(context)!.atTheStart),
                          trailing: currencyProvider
                                      .currentCurrencySymbolPosition ==
                                  CurrencySymbolPosition.leading
                              ? SvgPicture.asset('assets/icons/checkmark.svg')
                              : null,
                          onTap: () {
                            currencyProvider.setCurrencySymbolPosition(
                                CurrencySymbolPosition.leading);

                            _currencySymbolPositionInput.text =
                                AppLocalizations.of(context)!.atTheStart;
                            setState(() {});

                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          title: Text(AppLocalizations.of(context)!.atTheEnd),
                          trailing: currencyProvider
                                      .currentCurrencySymbolPosition ==
                                  CurrencySymbolPosition.trailing
                              ? SvgPicture.asset('assets/icons/checkmark.svg')
                              : null,
                          onTap: () {
                            currencyProvider.setCurrencySymbolPosition(
                                CurrencySymbolPosition.trailing);

                            _currencySymbolPositionInput.text =
                                AppLocalizations.of(context)!.atTheEnd;

                            setState(() {});

                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  String getCurrencyDescription(CurrencyEnum currency) {
    switch (currency) {
      case CurrencyEnum.eur:
        return 'EUR - €';
      case CurrencyEnum.usd:
        return 'USD - \$';
      case CurrencyEnum.jpy:
        return 'JPY - ¥';
      case CurrencyEnum.gbp:
        return 'GBP - £';
      case CurrencyEnum.chf:
        return 'CHF - CHF';
    }
  }

  String getCurrencySymbolPositionDescription(CurrencySymbolPosition position) {
    switch (position) {
      case CurrencySymbolPosition.none:
        return AppLocalizations.of(context)!.none;
      case CurrencySymbolPosition.leading:
        return AppLocalizations.of(context)!.atTheStart;
      case CurrencySymbolPosition.trailing:
        return AppLocalizations.of(context)!.atTheEnd;
    }
  }
}
