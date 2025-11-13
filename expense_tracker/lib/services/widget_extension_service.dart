import 'dart:io';

import 'package:expense_tracker/Helper/double_helper.dart';
import 'package:expense_tracker/application/transactions/models/currency.dart';
import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/notifiers/currency_provider.dart';
import 'package:expense_tracker/presentation/pages/new_edit_transaction_flow/new_edit_transaction_page.dart';
import 'package:flutter/widgets.dart';
import 'package:home_widget/home_widget.dart';

class WidgetExtensionService {
  static final WidgetExtensionService _singleton =
      WidgetExtensionService._internal();

  static const String appGroupId = 'group.moneyewidget';
  static const String shortcutsButtonsWidgetName = 'ShortcutsButtonsWidget';
  static const String monthlySummaryWidgetName = 'MonthlySummaryWidget';
  static const String monthlyExpensesSummaryWidgetName =
      'MonthlyExpensesSummaryWidget';

  factory WidgetExtensionService() {
    return _singleton;
  }

  WidgetExtensionService._internal() {
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
      final incomePreset = uri.queryParameters["income"] == "1";

      navigatorKey.currentState?.pushNamed(
        NewEditTransactionPage.routeName,
        arguments:
            NewEditTransactionPageScreenArguments(incomePreset: incomePreset),
      );
    }
  }

  static void updateMonthlySummaryWidgetData(
      BuildContext context,
      double newIncomeValue,
      double newExpenseValue,
      Currency? currency,
      CurrencySymbolPosition currencySymbolPosition) {
    HomeWidget.saveWidgetData<String>(
        'incomeValue',
        newIncomeValue.toStringAsFixedRoundedWithCurrency(
            2, currency, currencySymbolPosition));
    HomeWidget.saveWidgetData<String>(
        'expenseValue',
        newExpenseValue.toStringAsFixedRoundedWithCurrency(
            2, currency, currencySymbolPosition));

    if (Platform.isIOS) {
      HomeWidget.updateWidget(iOSName: monthlySummaryWidgetName);
      HomeWidget.updateWidget(iOSName: monthlyExpensesSummaryWidgetName);
    }
  }
}
