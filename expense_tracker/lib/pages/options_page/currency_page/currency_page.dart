import 'package:expense_tracker/pages/common/custom_text_field.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum CurrencySymbolPosition {
  none,
  leading,
  trailing,
}

enum CurrencyEnum {
  EUR,
  USD,
  GBP,
  JPY,
}

String getSymbolForCurrency(CurrencyEnum currency) {
  switch (currency) {
    case CurrencyEnum.EUR:
      return '€';
    case CurrencyEnum.USD:
      return '\$';
    case CurrencyEnum.JPY:
      return '¥';
    case CurrencyEnum.GBP:
      return '£';
  }
}

class CurrencyPage extends StatefulWidget {
  static const routeName = '/currencyPage';

  const CurrencyPage({super.key});

  @override
  State<CurrencyPage> createState() => _CurrencyPageState();
}

class _CurrencyPageState extends State<CurrencyPage> {
  var currentCurrencySymbolPosition = CurrencySymbolPosition.trailing;
  var currentCurrencySymbol = CurrencyEnum.EUR;

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
    return Column(
      children: [
        Container(
          height: 300,
          color: CustomColors.clearGrey,
          child: Center(
              child: Text(
                  '${currentCurrencySymbolPosition == CurrencySymbolPosition.leading ? getSymbolForCurrency(currentCurrencySymbol) : ''}${exampleValue.toString()}${currentCurrencySymbolPosition == CurrencySymbolPosition.trailing ? getSymbolForCurrency(currentCurrencySymbol) : ''}')),
        ),
        const SizedBox(
          height: 14,
        ),
        CustomTextField(
          controller: _currencySymbolPositionInput,
          label: 'Posizione del simbolo della valuta',
          readOnly: true,
          icon: Icons.chevron_right_rounded,
          onTap: () async {
            await showModalBottomSheet(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(34),
                  topRight: Radius.circular(34),
                ),
              ),
              backgroundColor: Colors.white,
              clipBehavior: Clip.antiAlias,
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
                                title: const Text('Leading'),
                                trailing: currentCurrencySymbolPosition ==
                                        CurrencySymbolPosition.leading
                                    ? SvgPicture.asset(
                                        'assets/icons/checkmark.svg')
                                    : null,
                                onTap: () {
                                  currentCurrencySymbolPosition =
                                      CurrencySymbolPosition.leading;

                                  _currencySymbolPositionInput.text = 'Leading';
                                  setState(() {});

                                  Navigator.of(context).pop();
                                }),
                            ListTile(
                                title: const Text('Trailing'),
                                trailing: currentCurrencySymbolPosition ==
                                        CurrencySymbolPosition.trailing
                                    ? SvgPicture.asset(
                                        'assets/icons/checkmark.svg')
                                    : null,
                                onTap: () {
                                  currentCurrencySymbolPosition =
                                      CurrencySymbolPosition.trailing;

                                  _currencySymbolPositionInput.text =
                                      'Trailing';

                                  setState(() {});

                                  Navigator.of(context).pop();
                                }),
                            ListTile(
                                title: const Text('None'),
                                trailing: currentCurrencySymbolPosition ==
                                        CurrencySymbolPosition.none
                                    ? SvgPicture.asset(
                                        'assets/icons/checkmark.svg')
                                    : null,
                                onTap: () {
                                  currentCurrencySymbolPosition =
                                      CurrencySymbolPosition.none;

                                  _currencySymbolPositionInput.text = 'None';

                                  setState(() {});

                                  Navigator.of(context).pop();
                                }),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            );
          },
        ),
        const SizedBox(
          height: 14,
        ),
        CustomTextField(
          controller: _currencySymbolInput,
          label: 'Valuta',
          readOnly: true,
          icon: Icons.chevron_right_rounded,
          onTap: () async {
            await showModalBottomSheet(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(34),
                  topRight: Radius.circular(34),
                ),
              ),
              backgroundColor: Colors.white,
              clipBehavior: Clip.antiAlias,
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
                              trailing:
                                  currentCurrencySymbol == CurrencyEnum.EUR
                                      ? SvgPicture.asset(
                                          'assets/icons/checkmark.svg')
                                      : null,
                              onTap: () {
                                currentCurrencySymbol = CurrencyEnum.EUR;

                                _currencySymbolInput.text = 'EUR - €';
                                setState(() {});

                                Navigator.of(context).pop();
                              },
                            ),
                            ListTile(
                              title: const Text('GBP - £'),
                              trailing:
                                  currentCurrencySymbol == CurrencyEnum.GBP
                                      ? SvgPicture.asset(
                                          'assets/icons/checkmark.svg')
                                      : null,
                              onTap: () {
                                currentCurrencySymbol = CurrencyEnum.GBP;

                                _currencySymbolInput.text = 'GBP - £';
                                setState(() {});

                                Navigator.of(context).pop();
                              },
                            ),
                            ListTile(
                              title: const Text('JPY - ¥'),
                              trailing:
                                  currentCurrencySymbol == CurrencyEnum.JPY
                                      ? SvgPicture.asset(
                                          'assets/icons/checkmark.svg')
                                      : null,
                              onTap: () {
                                currentCurrencySymbol = CurrencyEnum.JPY;

                                _currencySymbolInput.text = 'JPY - ¥';
                                setState(() {});

                                Navigator.of(context).pop();
                              },
                            ),
                            ListTile(
                              title: const Text('USD - \$'),
                              trailing:
                                  currentCurrencySymbol == CurrencyEnum.USD
                                      ? SvgPicture.asset(
                                          'assets/icons/checkmark.svg')
                                      : null,
                              onTap: () {
                                currentCurrencySymbol = CurrencyEnum.USD;

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
        ),
      ],
    );
  }
}
