import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/features/accounts/presentation/pages/accounts_list_page/new_edit_account_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddAccountListTile extends ConsumerWidget {
  const AddAccountListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () =>
          Navigator.of(context).pushNamed(NewEditAccountPage.routeName),
      icon: Icon(
        Icons.add_rounded,
        color: context.appColors.textSecondary,
        size: 32,
      ),
    );
  }
}
