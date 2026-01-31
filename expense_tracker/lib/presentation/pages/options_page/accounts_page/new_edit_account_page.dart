import 'package:expense_tracker/application/common/notifiers/app_localizations_provider.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/domain/models/account.dart';
import 'package:expense_tracker/domain/models/transaction.dart';
import 'package:expense_tracker/application/accounts/notifiers/mutations/account_mutation_notifier.dart';
import 'package:expense_tracker/application/transactions/notifiers/mutations/transaction_mutation_notifier.dart';
import 'package:expense_tracker/presentation/pages/common/custom_elevated_button.dart';
import 'package:expense_tracker/presentation/pages/common/custom_text_field.dart';
import 'package:expense_tracker/presentation/pages/common/inline_color_picker.dart';
import 'package:expense_tracker/presentation/pages/common/inline_icon_picker.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewAccountPage extends ConsumerStatefulWidget {
  static const routeName = '/newEditAccountPage';

  final Account? initialAccountSettings;

  const NewAccountPage({
    super.key,
    this.initialAccountSettings,
  });

  @override
  ConsumerState<NewAccountPage> createState() => _NewAccountPageState();
}

class _NewAccountPageState extends ConsumerState<NewAccountPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController titleInput = TextEditingController();
  TextEditingController descriptionInput = TextEditingController();
  TextEditingController initialBalanceInput = TextEditingController();

  Color selectedColor = CustomColors.darkBlue;
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

    return Scaffold(
      appBar: AppBar(
        title: Text(editMode
            ? appLocalizations.editAccount
            : appLocalizations.newAccount),
        backgroundColor: CustomColors.blue,
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
            const SizedBox(
              height: 14,
            ),
            CustomTextField(
              controller: descriptionInput,
              label: appLocalizations.description,
              hintText: appLocalizations.insertTheDescription,
            ),
            const SizedBox(
              height: 14,
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
            const SizedBox(
              height: 14,
            ),
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
      children: [
        Text(
          appLocalizations.color,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: CustomColors.lightBlack,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        InlineColorPicker(
            selectedColor: selectedColor,
            onSelectedColor: (newSelectedColor) {
              selectedColor = newSelectedColor;

              setState(() {});
            }),
      ],
    );
  }

  Widget _buildIconPicker(AppLocalizations appLocalizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          appLocalizations.icon,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: CustomColors.lightBlack,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        InlineIconPicker(
          selectedIconPath: selectedIconPath,
          backgorundColor: selectedColor,
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
          await _saveNewAccount();
        }

        if (!mounted) return;
        Navigator.of(context).pop();
      },
    );
  }

  Future<void> _saveNewAccount() async {
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
      final currentContext = context;
      String initialBalanceTitle = "Inital balance"; // TODO: Localize

      if (currentContext.mounted) {
        initialBalanceTitle =
            AppLocalizations.of(currentContext)!.initialBalance;
      }

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

    if (!mounted) return;
    Navigator.of(context).pop();
  }
}
