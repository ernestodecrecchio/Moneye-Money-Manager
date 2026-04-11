import 'package:flutter/material.dart';

Future showCustomModalBottomSheet({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
}) async {
  return await showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(34),
          topRight: Radius.circular(34),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      context: context,
      builder: builder);
}
