import 'package:expense_tracker/notifiers/currency_provider.dart';
import 'package:expense_tracker/pages/initial_configuration_page/floating_element.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrencySelection extends ConsumerStatefulWidget {
  const CurrencySelection({Key? key}) : super(key: key);

  @override
  ConsumerState<CurrencySelection> createState() => _CurrencySelectionState();
}

class _CurrencySelectionState extends ConsumerState<CurrencySelection> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Select your preferred currency',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Don't worry, you can always change it later to match your needs.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: CupertinoPicker(
                  diameterRatio: 2,
                  itemExtent: 40,
                  looping: true,
                  magnification: 1.2,
                  onSelectedItemChanged: (item) {
                    print('tap');
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
