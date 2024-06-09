import 'package:expense_tracker/Helper/double_helper.dart';
import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/models/currency.dart';
import 'package:expense_tracker/notifiers/currency_provider.dart';
import 'package:expense_tracker/pages/new_edit_transaction_flow/new_edit_transaction_page.dart';
import 'package:flutter/widgets.dart';
import 'package:home_widget/home_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WidgetExtensionService {
  static final WidgetExtensionService _singleton =
      WidgetExtensionService._internal();

  static const String appGroupId = 'group.moneyewidget';
  static const String iOSWidgetName = 'MonthlySummaryWidget';
  static const String androidWidgetName = 'MonthlySummaryWidget';

  factory WidgetExtensionService() {
    return _singleton;
  }

  WidgetExtensionService._internal() {
    print("INIT SINGLETON WIDGET");
    HomeWidget.setAppGroupId(appGroupId);
  }

  // App launched from background state
  void listenWidgetClick() {
    HomeWidget.widgetClicked.listen(_launchedFromWidget);
  }

  // App launched from terminated state
  void checkForWidgetLaunch() {
    HomeWidget.initiallyLaunchedFromHomeWidget().then(_launchedFromWidget);
  }

  void _launchedFromWidget(Uri? uri) {
    if (uri != null) {
      navigatorKey.currentState?.pushNamed(NewEditTransactionPage.routeName);
    }
  }

  static updateWidgetData(
      BuildContext context,
      double newIncomeValue,
      double newOutcomeValue,
      Currency? currency,
      CurrencySymbolPosition currencySymbolPosition) {
    var appLocalizations = AppLocalizations.of(context)!;

    HomeWidget.saveWidgetData<String>('title', appLocalizations.thisMonth);
    HomeWidget.saveWidgetData<String>(
        'incomeValue',
        newIncomeValue.toStringAsFixedRoundedWithCurrency(
            2, currency, currencySymbolPosition));
    HomeWidget.saveWidgetData<String>(
        'outcomeValue',
        newOutcomeValue.toStringAsFixedRoundedWithCurrency(
            2, currency, currencySymbolPosition));
    HomeWidget.updateWidget(
        iOSName: iOSWidgetName, androidName: androidWidgetName);
  }
}
