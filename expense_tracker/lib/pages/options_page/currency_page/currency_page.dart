import 'package:expense_tracker/notifiers/currency_provider.dart';
import 'package:expense_tracker/pages/common/custom_modal_bottom_sheet.dart';
import 'package:expense_tracker/pages/common/custom_text_field.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CurrencyPage extends ConsumerStatefulWidget {
  static const routeName = '/currencyPage';

  const CurrencyPage({super.key});

  @override
  ConsumerState<CurrencyPage> createState() => _CurrencyPageState();
}

class _CurrencyPageState extends ConsumerState<CurrencyPage> {
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

    final currentCurrency = ref.read(currentCurrencyProvider);
    final currencySymbolPositionProvider =
        ref.read(currentCurrencySymbolPositionProvider);

    if (currentCurrency != null) {
      _currencySymbolInput.text =
          '${currentCurrency.name} - ${currentCurrency.symbolNative}';
    }

    _currencySymbolPositionInput.text =
        getCurrencySymbolPositionDescription(currencySymbolPositionProvider);
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
    return Column(
      children: [
        _buildCurrencyPreview(),
        const SizedBox(
          height: 14,
        ),
        _buildCurrenctCurrencyTextField(),
        const SizedBox(
          height: 4,
        ),
        Text(
          AppLocalizations.of(context)!.currencyConversionDisclaimer,
          style:
              const TextStyle(color: CustomColors.clearGreyText, fontSize: 12),
        ),
        const SizedBox(
          height: 14,
        ),
        _buildCurrencySymbolPositionTextField(),
      ],
    );
  }

  Widget _buildCurrencyPreview() {
    final currentCurrency = ref.watch(currentCurrencyProvider);
    final currentCurrencyPosition =
        ref.watch(currentCurrencySymbolPositionProvider);

    String symbol = currentCurrency?.symbolNative ?? '';

    TextSpan currencySymbolTextSpan = TextSpan(
      text: symbol,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );

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
              if (currentCurrencyPosition == CurrencySymbolPosition.leading)
                currencySymbolTextSpan,
              exampleValueTextSpan,
              if (currentCurrencyPosition == CurrencySymbolPosition.trailing)
                currencySymbolTextSpan,
            ])));
  }

  Widget _buildCurrenctCurrencyTextField() {
    return CustomTextField(
      controller: _currencySymbolInput,
      label: AppLocalizations.of(context)!.currency,
      readOnly: true,
      icon: Icons.chevron_right_rounded,
      onTap: () async {
        await showCustomModalBottomSheet(
          context: context,
          builder: ((context) {
            return Consumer(
              builder: (context, ref, child) {
                final currencyList = ref.watch(currencyListProvider);

                return currencyList.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) =>
                      const Text('Error loading currency list'),
                  data: (currencyList) => Padding(
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
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
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
                          child: Scrollbar(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: currencyList.length,
                                itemBuilder: (context, index) {
                                  final currency = currencyList[index];

                                  return ListTile(
                                    title: Text(
                                        '${currency.name} - ${currency.symbolNative}'),
                                    trailing:
                                        ref.watch(currentCurrencyProvider) ==
                                                currency
                                            ? SvgPicture.asset(
                                                'assets/icons/checkmark.svg')
                                            : null,
                                    onTap: () {
                                      ref
                                          .read(
                                              currentCurrencyProvider.notifier)
                                          .updateCurrency(currency);

                                      _currencySymbolInput.text =
                                          '${currency.name} - ${currency.symbolNative}';

                                      Navigator.of(context).pop();
                                    },
                                  );
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        );
      },
    );
  }

  Widget _buildCurrencySymbolPositionTextField() {
    final currentCurrencyPosition =
        ref.watch(currentCurrencySymbolPositionProvider);

    final currentCurrencyPositionProviderNotifier =
        ref.watch(currentCurrencySymbolPositionProvider.notifier);

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
                          trailing: currentCurrencyPosition ==
                                  CurrencySymbolPosition.none
                              ? SvgPicture.asset('assets/icons/checkmark.svg')
                              : null,
                          onTap: () {
                            currentCurrencyPositionProviderNotifier
                                .updateCurrencyPosition(
                                    CurrencySymbolPosition.none);

                            _currencySymbolPositionInput.text =
                                AppLocalizations.of(context)!.none;

                            setState(() {});

                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          title: Text(AppLocalizations.of(context)!.atTheStart),
                          trailing: currentCurrencyPosition ==
                                  CurrencySymbolPosition.leading
                              ? SvgPicture.asset('assets/icons/checkmark.svg')
                              : null,
                          onTap: () {
                            currentCurrencyPositionProviderNotifier
                                .updateCurrencyPosition(
                                    CurrencySymbolPosition.leading);

                            _currencySymbolPositionInput.text =
                                AppLocalizations.of(context)!.atTheStart;
                            setState(() {});

                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          title: Text(AppLocalizations.of(context)!.atTheEnd),
                          trailing: currentCurrencyPosition ==
                                  CurrencySymbolPosition.trailing
                              ? SvgPicture.asset('assets/icons/checkmark.svg')
                              : null,
                          onTap: () {
                            currentCurrencyPositionProviderNotifier
                                .updateCurrencyPosition(
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
