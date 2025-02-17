import 'package:flutter/material.dart';

showCustomModalBottomSheet({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
}) async {
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
      builder: builder);
}
