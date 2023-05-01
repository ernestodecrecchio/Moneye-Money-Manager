import 'package:expense_tracker/notifiers/currency_provider.dart';
import 'package:expense_tracker/pages/common/custom_modal_bottom_sheet.dart';
import 'package:expense_tracker/pages/common/custom_text_field.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

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
  void initState() {
    super.initState();

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
  void dispose() {
    super.dispose();

    _currencySymbolPositionInput.dispose();
    _currencySymbolInput.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Valuta'),
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
      label: 'Valuta',
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
                        const Flexible(
                          child: Text(
                            'Seleziona la valuta',
                            style: TextStyle(
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
      label: 'Posizione del simbolo della valuta',
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
                        const Flexible(
                          child: Text(
                            'Seleziona la posizione del simbolo della valuta',
                            style: TextStyle(
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
                          title: const Text('Nessuno'),
                          trailing: currencyProvider
                                      .currentCurrencySymbolPosition ==
                                  CurrencySymbolPosition.none
                              ? SvgPicture.asset('assets/icons/checkmark.svg')
                              : null,
                          onTap: () {
                            currencyProvider.setCurrencySymbolPosition(
                                CurrencySymbolPosition.none);

                            _currencySymbolPositionInput.text = 'Nessuno';

                            setState(() {});

                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          title: const Text("All'inizio"),
                          trailing: currencyProvider
                                      .currentCurrencySymbolPosition ==
                                  CurrencySymbolPosition.leading
                              ? SvgPicture.asset('assets/icons/checkmark.svg')
                              : null,
                          onTap: () {
                            currencyProvider.setCurrencySymbolPosition(
                                CurrencySymbolPosition.leading);

                            _currencySymbolPositionInput.text = "All'inizio";
                            setState(() {});

                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          title: const Text('Alla fine'),
                          trailing: currencyProvider
                                      .currentCurrencySymbolPosition ==
                                  CurrencySymbolPosition.trailing
                              ? SvgPicture.asset('assets/icons/checkmark.svg')
                              : null,
                          onTap: () {
                            currencyProvider.setCurrencySymbolPosition(
                                CurrencySymbolPosition.trailing);

                            _currencySymbolPositionInput.text = 'Alla fine';

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
    }
  }

  String getCurrencySymbolPositionDescription(CurrencySymbolPosition position) {
    switch (position) {
      case CurrencySymbolPosition.none:
        return 'Nessuno';
      case CurrencySymbolPosition.leading:
        return "All'inizio";
      case CurrencySymbolPosition.trailing:
        return 'Alla fine';
    }
  }
}
