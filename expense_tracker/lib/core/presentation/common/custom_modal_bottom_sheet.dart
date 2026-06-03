import 'package:expense_tracker/core/presentation/common/amount_keyboard/amount_keyboard_host.dart';
import 'package:flutter/material.dart';

const double _modalBottomSpacing = 16;

/// Bottom spacing for modal sheet content: [_modalBottomSpacing] + device safe area.
double modalSheetBottomSpacing(BuildContext context) =>
    _modalBottomSpacing + MediaQuery.paddingOf(context).bottom;

/// Use as [ListView.padding] / [GridView.padding] so the last items can scroll
/// above the home indicator. Do not wrap the whole sheet in bottom padding.
EdgeInsets modalSheetScrollPadding(BuildContext context) =>
    EdgeInsets.only(bottom: modalSheetBottomSpacing(context));

Future<T?> showCustomModalBottomSheet<T>({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
  bool isScrollControlled = false,
}) async {
  return await showModalBottomSheet<T>(
    isScrollControlled: isScrollControlled,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(34),
        topRight: Radius.circular(34),
      ),
    ),
    clipBehavior: Clip.antiAlias,
    context: context,
    builder: (context) => AmountKeyboardModalInset(
      child: builder(context),
    ),
  );
}
