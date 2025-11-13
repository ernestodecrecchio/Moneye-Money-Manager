import 'dart:io';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/notifiers/account_provider.dart';
import 'package:expense_tracker/presentation/pages/options_page/accounts_page/new_edit_account_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:vector_graphics/vector_graphics.dart';

class AccountListCell extends ConsumerWidget {
  final Account account;

  const AccountListCell({super.key, required this.account});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Slidable(
      key: Key(account.id.toString()),
      startActionPane: _buildDeleteActionPane(context, ref),
      endActionPane: _buildDeleteActionPane(context, ref),
      child: ListTile(
        onTap: () => Navigator.of(context)
            .pushNamed(NewAccountPage.routeName, arguments: account),
        title: Text(
          account.name,
          style: const TextStyle(fontSize: 16),
        ),
        leading: _buildAccountIcon(account),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }

  ActionPane _buildDeleteActionPane(BuildContext context, WidgetRef ref) {
    return ActionPane(
      motion: const ScrollMotion(),
      dismissible: DismissiblePane(
        confirmDismiss: () => showDeleteAlert(context),
        closeOnCancel: true,
        onDismissed: () async => await ref
            .read(accountProvider.notifier)
            .deleteAccountCentral(account),
      ),
      children: [
        _buildDeleteSlidableAction(context, ref),
      ],
    );
  }

  SlidableAction _buildDeleteSlidableAction(
      BuildContext context, WidgetRef ref) {
    return SlidableAction(
      backgroundColor: const Color(0xFFFE4A49),
      foregroundColor: Colors.white,
      icon: Icons.delete,
      label: AppLocalizations.of(context)!.delete,
      onPressed: (_) async {
        final isDeleteConfirmed = await showDeleteAlert(context);

        if (context.mounted && isDeleteConfirmed) {
          await ref.read(accountProvider.notifier).deleteAccount(account);
        }
      },
    );
  }

  Future<bool> showDeleteAlert(BuildContext context) async {
    bool isDeleteConfirmed = false;

    if (Platform.isAndroid) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.areYouSure,
            ),
            content: Text(
              AppLocalizations.of(context)!.deleteAccountAlertBody,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  isDeleteConfirmed = false;
                  Navigator.of(context).pop();
                },
                child: Text(
                  AppLocalizations.of(context)!.cancel,
                ),
              ),
              TextButton(
                onPressed: () {
                  isDeleteConfirmed = true;
                  Navigator.of(context).pop();
                },
                child: Text(
                  AppLocalizations.of(context)!.delete,
                ),
              )
            ],
          );
        },
      );
    } else {
      await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(
            AppLocalizations.of(context)!.areYouSure,
          ),
          content: Text(
            AppLocalizations.of(context)!.deleteAccountAlertBody,
          ),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                isDeleteConfirmed = false;
                Navigator.pop(context);
              },
              child: Text(
                AppLocalizations.of(context)!.cancel,
              ),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                isDeleteConfirmed = true;
                Navigator.pop(context);
              },
              child: Text(
                AppLocalizations.of(context)!.delete,
              ),
            ),
          ],
        ),
      );
    }

    return isDeleteConfirmed;
  }

  Container _buildAccountIcon(Account account) {
    VectorGraphic? accountIcon;
    if (account.iconPath != null) {
      accountIcon = VectorGraphic(
        loader: AssetBytesLoader(account.iconPath!),
        colorFilter: const ColorFilter.mode(
          Colors.white,
          BlendMode.srcIn,
        ),
      );
    }

    return Container(
      width: 32,
      height: 32,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(shape: BoxShape.circle, color: account.color),
      child: accountIcon,
    );
  }
}
