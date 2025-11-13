import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/application/transactions/models/account.dart';
import 'package:expense_tracker/notifiers/account_provider.dart';
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
  late final AppLocalizations appLocalizations;
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
  void didChangeDependencies() {
    super.didChangeDependencies();

    appLocalizations = AppLocalizations.of(context)!;
  }

  @override
  void dispose() {
    titleInput.dispose();
    descriptionInput.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                child: _buildForm(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
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
            _buildColorPicker(),
            const SizedBox(
              height: 14,
            ),
            _buildIconPicker(),
            const Spacer(),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildColorPicker() {
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

  Widget _buildIconPicker() {
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

  Widget _buildSaveButton() {
    return CustomElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          if (editMode) {
            _editAccount();
          } else {
            _saveNewAccount();
          }
        }
      },
      text: editMode ? appLocalizations.applyChanges : appLocalizations.save,
    );
  }

  void _saveNewAccount() {
    final double? initialAmountValue =
        double.tryParse(initialBalanceInput.text);

    ref
        .read(accountProvider.notifier)
        .addNewAccountByParameters(
            name: titleInput.text,
            description: descriptionInput.text,
            colorValue: selectedColor.toARGB32(),
            iconPath: selectedIconPath,
            initialAmount: initialAmountValue)
        .then((value) => {if (mounted) Navigator.of(context).pop()});
  }

  void _editAccount() {
    ref
        .read(accountProvider.notifier)
        .updateAccount(
            accountToEdit: widget.initialAccountSettings!,
            name: titleInput.text,
            description: descriptionInput.text,
            colorValue: selectedColor.toARGB32(),
            iconPath: selectedIconPath)
        .then((value) => {if (mounted) Navigator.of(context).pop()});
  }
}
