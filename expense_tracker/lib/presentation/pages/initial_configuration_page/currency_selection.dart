import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/models/currency.dart';
import 'package:expense_tracker/notifiers/currency_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrencySelectionPage extends ConsumerStatefulWidget {
  final Function(Currency) onCurrencySelected;
  const CurrencySelectionPage({
    super.key,
    required this.onCurrencySelected,
  });

  @override
  ConsumerState<CurrencySelectionPage> createState() =>
      _CurrencySelectionState();
}

class _CurrencySelectionState extends ConsumerState<CurrencySelectionPage> {
  List<Currency> currencyList = [];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.selectCurrencyMsg1,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                AppLocalizations.of(context)!.selectCurrencyMsg2,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: CupertinoPicker(
                  diameterRatio: 2,
                  itemExtent: 40,
                  looping: true,
                  magnification: 1.2,
                  onSelectedItemChanged: (index) {
                    widget.onCurrencySelected(currencyList[index]);
                  },
                  children: getCurrencyList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> getCurrencyList() {
    List<Widget> widgetList = [];
    ref.watch(currencyListProvider).when(
          data: (data) {
            currencyList = data;
            widget.onCurrencySelected(currencyList[0]);

            for (var element in data) {
              widgetList.add(Align(
                alignment: Alignment.center,
                child: Text(
                  '${element.code} - ${element.symbolNative}',
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ));
            }
          },
          loading: () => const CircularProgressIndicator(),
          error: (error, stackTrace) {},
        );

    return widgetList;
  }
}
