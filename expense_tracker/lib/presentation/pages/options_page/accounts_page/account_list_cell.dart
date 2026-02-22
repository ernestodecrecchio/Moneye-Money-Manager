import 'package:expense_tracker/application/accounts/notifiers/mutations/account_mutation_notifier.dart';
import 'package:expense_tracker/application/common/notifiers/app_localizations_provider.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/domain/models/account.dart';
import 'package:expense_tracker/presentation/pages/common/dialogs.dart';
import 'package:expense_tracker/presentation/pages/options_page/accounts_page/new_edit_account_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:vector_graphics/vector_graphics.dart';

class AccountListCell extends ConsumerWidget {
  final Account account;

  const AccountListCell({super.key, required this.account});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);

    return Slidable(
      key: Key(account.id.toString()),
      startActionPane: _buildDeleteActionPane(context, ref, appLocalizations),
      endActionPane: _buildDeleteActionPane(context, ref, appLocalizations),
      child: ListTile(
        onTap: () => Navigator.of(context)
            .pushNamed(NewEditAccountPage.routeName, arguments: account),
        title: Text(
          account.name,
          style: const TextStyle(fontSize: 16),
        ),
        leading: _buildAccountIcon(account),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }

  ActionPane _buildDeleteActionPane(
      BuildContext context, WidgetRef ref, AppLocalizations appLocalizations) {
    return ActionPane(
      motion: const ScrollMotion(),
      dismissible: DismissiblePane(
        confirmDismiss: () => showDeleteAccountAlert(context, appLocalizations),
        closeOnCancel: true,
        onDismissed: () async => await ref
            .read(accountMutationProvider.notifier)
            .deleteAccount(account),
      ),
      children: [
        _buildDeleteSlidableAction(context, ref, appLocalizations),
      ],
    );
  }

  SlidableAction _buildDeleteSlidableAction(
      BuildContext context, WidgetRef ref, AppLocalizations appLocalizations) {
    return SlidableAction(
      backgroundColor: const Color(0xFFFE4A49),
      foregroundColor: Colors.white,
      icon: Icons.delete,
      label: appLocalizations.delete,
      onPressed: (_) async {
        final isDeleteConfirmed =
            await showDeleteAccountAlert(context, appLocalizations);

        if (context.mounted && isDeleteConfirmed) {
          await ref
              .read(accountMutationProvider.notifier)
              .deleteAccount(account);
        }
      },
    );
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
