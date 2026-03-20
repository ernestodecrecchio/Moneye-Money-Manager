import 'package:expense_tracker/application/common/notifiers/app_localizations_provider.dart';
import 'package:expense_tracker/domain/models/account.dart';
import 'package:expense_tracker/domain/models/transaction.dart';
import 'package:expense_tracker/application/accounts/notifiers/mutations/account_mutation_notifier.dart';
import 'package:expense_tracker/application/transactions/notifiers/mutations/transaction_mutation_notifier.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/presentation/pages/common/custom_elevated_button.dart';
import 'package:expense_tracker/presentation/pages/common/custom_text_field.dart';
import 'package:expense_tracker/presentation/pages/common/dialogs.dart';
import 'package:expense_tracker/presentation/pages/common/inline_color_picker.dart';
import 'package:expense_tracker/presentation/pages/common/inline_icon_picker.dart';
import 'package:expense_tracker/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewEditAccountPage extends ConsumerStatefulWidget {
  static const routeName = '/newEditAccountPage';

  final Account? initialAccountSettings;

  const NewEditAccountPage({
    super.key,
    this.initialAccountSettings,
  });

  @override
  ConsumerState<NewEditAccountPage> createState() => _NewAccountPageState();
}

class _NewAccountPageState extends ConsumerState<NewEditAccountPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController titleInput = TextEditingController();
  TextEditingController descriptionInput = TextEditingController();
  TextEditingController initialBalanceInput = TextEditingController();

  late Color selectedColor;
  String? selectedIconPath;

  bool get editMode {
    return widget.initialAccountSettings != null;
  }

  @override
  void initState() {
    super.initState();

    if (editMode) {
      titleInput.text = widget.initialAccountSettings!.name;
      descriptionInput.text = widget.initialAccountSettings!.description ?? '';
      selectedColor = widget.initialAccountSettings!.color;
      selectedIconPath = widget.initialAccountSettings!.iconPath;
    } else {
      selectedColor = CustomColors.defaultPickerColor;
    }
  }

  @override
  void dispose() {
    titleInput.dispose();
    descriptionInput.dispose();
    initialBalanceInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final isLoading = ref.watch(accountMutationProvider).isLoading;

    final List<Widget> actions = [];

    if (widget.initialAccountSettings != null) {
      final account = widget.initialAccountSettings!;
      actions.add(_buildDeleteAction(
        context,
        appLocalizations,
        account,
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          editMode ? appLocalizations.editAccount : appLocalizations.newAccount,
        ),
        actions: actions,
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 17),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _buildForm(appLocalizations, isLoading),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildForm(AppLocalizations appLocalizations, bool isLoading) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          spacing: 14,
          children: [
            CustomTextField(
              controller: titleInput,
              label: '${appLocalizations.title}*',
              hintText: appLocalizations.insertTheAccountName,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return appLocalizations.titleIsMandatory;
                }
                return null;
              },
            ),
            CustomTextField(
              controller: descriptionInput,
              label: appLocalizations.description,
              hintText: appLocalizations.insertTheDescription,
            ),
            if (!editMode)
              CustomTextField(
                controller: initialBalanceInput,
                label: appLocalizations.initialBalance,
                hintText: appLocalizations.initialBalancePlaceholder,
                textInputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))
                ],
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
              ),
            _buildColorPicker(appLocalizations),
            _buildIconPicker(appLocalizations),
            const Spacer(),
            _buildSaveButton(appLocalizations, isLoading),
          ],
        ),
      ),
    );
  }

  Widget _buildColorPicker(AppLocalizations appLocalizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        Text(
          appLocalizations.color,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        InlineColorPicker(
          itemShape: BoxShape.rectangle,
          selectedColor: selectedColor,
          onSelectedColor: (newSelectedColor) {
            selectedColor = newSelectedColor;

            setState(() {});
          },
        ),
      ],
    );
  }

  Widget _buildIconPicker(AppLocalizations appLocalizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        Text(
          appLocalizations.icon,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        InlineIconPicker(
          selectedIconPath: selectedIconPath,
          backgroundColor: selectedColor,
          itemShape: BoxShape.rectangle,
          onSelectedIcon: (newSelectedIconPath) {
            selectedIconPath = newSelectedIconPath;

            setState(() {});
          },
        ),
      ],
    );
  }

  Widget _buildSaveButton(AppLocalizations appLocalizations, bool isLoading) {
    return CustomElevatedButton(
      text: editMode ? appLocalizations.applyChanges : appLocalizations.save,
      isLoading: isLoading,
      onPressed: () async {
        if (!_formKey.currentState!.validate()) return;

        if (editMode) {
          await _editAccount();
        } else {
          await _saveNewAccount(appLocalizations);
        }

        if (!mounted) return;
        Navigator.of(context).pop();
      },
    );
  }

  Future<void> _saveNewAccount(AppLocalizations appLocalizations) async {
    final double? initialAmountValue =
        double.tryParse(initialBalanceInput.text);

    final newAccount = Account(
      name: titleInput.text,
      description: descriptionInput.text,
      colorValue: selectedColor.toARGB32(),
      iconPath: selectedIconPath,
    );

    final Account addedAccount =
        await ref.read(accountMutationProvider.notifier).addAccount(newAccount);

    if (initialAmountValue != null) {
      String initialBalanceTitle = appLocalizations.initialBalance;

      final newTransaction = Transaction(
        accountId: addedAccount.id,
        title: initialBalanceTitle,
        amount: initialAmountValue,
        date: DateTime.now(),
        includeInReports: false,
        isHidden: false,
      );

      await ref
          .read(transactionMutationProvider.notifier)
          .addTransaction(newTransaction);
    }
  }

  Future<void> _editAccount() async {
    final modifiedAccount = Account(
      id: widget.initialAccountSettings!.id,
      name: titleInput.text,
      description: descriptionInput.text,
      colorValue: selectedColor.toARGB32(),
      iconPath: selectedIconPath,
    );

    await ref
        .read(accountMutationProvider.notifier)
        .updateAccount(widget.initialAccountSettings!, modifiedAccount);
  }

  Widget _buildDeleteAction(BuildContext context,
      AppLocalizations appLocalizations, Account account) {
    return TextButton(
      child: Text(
        appLocalizations.delete,
        style: TextStyle(
          color: Theme.of(context).appBarTheme.foregroundColor,
        ),
      ),
      onPressed: () async {
        final navigator = Navigator.of(context);

        final confirmed =
            await showDeleteAccountAlert(context, appLocalizations);

        if (!mounted || !confirmed) return;

        await ref.read(accountMutationProvider.notifier).deleteAccount(account);

        if (!mounted) return;

        navigator.pop('deleted');
      },
    );
  }
}
