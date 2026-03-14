import 'package:expense_tracker/application/common/notifiers/app_localizations_provider.dart';
import 'package:expense_tracker/configuration/constants.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/domain/models/account.dart';
import 'package:expense_tracker/application/accounts/notifiers/queries/accounts_list_notifier.dart';
import 'package:expense_tracker/presentation/pages/common/custom_modal_bottom_sheet.dart';
import 'package:expense_tracker/presentation/pages/common/widgets/icon_item.dart';
import 'package:expense_tracker/presentation/pages/common/widgets/safe_vector_graphic.dart';
import 'package:expense_tracker/presentation/pages/options_page/accounts_page/new_edit_account_page.dart';
import 'package:expense_tracker/style/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<Account?> showAccountBottomSheet(
    BuildContext context, Account? initialSelection) async {
  return await showCustomModalBottomSheet(
    context: context,
    builder: ((context) {
      return AccountSelectorContent(currentSelection: initialSelection);
    }),
  );
}

class AccountSelectorContent extends ConsumerStatefulWidget {
  final Account? currentSelection;

  const AccountSelectorContent({
    super.key,
    this.currentSelection,
  });

  @override
  ConsumerState<AccountSelectorContent> createState() =>
      _AccountSelectorContentState();
}

class _AccountSelectorContentState
    extends ConsumerState<AccountSelectorContent> {
  Account? _selectedAccount;

  @override
  void initState() {
    super.initState();

    _selectedAccount = widget.currentSelection;
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  appLocalizations.selectAccount,
                  style: textTheme.titleMedium?.copyWith(fontSize: 18),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                )
              ],
            ),
          ),
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                return ref.watch(accountsListProvider).when(
                      data: (accountsList) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: accountsList.length + 1,
                            itemBuilder: (BuildContext context, int index) {
                              if (index == accountsList.length) {
                                return _buildAddAccountTile(appLocalizations);
                              }
                              return _buildAccountTile(accountsList[index]);
                            });
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, stackTrace) =>
                          const Text('Error loading accounts'),
                    );
              },
            ),
          ),
        ],
      ),
    );
  }

  ListTile _buildAddAccountTile(AppLocalizations appLocalizations) {
    final textTheme = Theme.of(context).textTheme;
    return ListTile(
      leading: Container(
        height: iconItemHeight,
        width: iconItemWidth,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border.all(width: 2, color: context.appColors.accent),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.add,
          size: 20,
        ),
      ),
      title: Text(
        appLocalizations.newAccount,
        style: textTheme.bodyLarge?.copyWith(fontSize: 18),
      ),
      onTap: () {
        Navigator.of(context).pushNamed(NewEditAccountPage.routeName);
      },
    );
  }

  ListTile _buildAccountTile(Account account) {
    final textTheme = Theme.of(context).textTheme;
    final colors = context.appColors;
    return ListTile(
      leading: IconItem(
        backgroundColor: account.color,
        shape: BoxShape.rectangle,
        iconPath: account.iconPath,
      ),
      trailing: _selectedAccount == account
          ? SafeVectorGraphic(
              iconPath: 'assets/icons/checkmark.svg',
              color: colors.primary,
            )
          : null,
      title: Text(
        account.name,
        style: textTheme.bodyLarge?.copyWith(fontSize: 18),
      ),
      onTap: () {
        _selectedAccount = account;

        Navigator.of(context).pop(_selectedAccount);
      },
    );
  }
}
