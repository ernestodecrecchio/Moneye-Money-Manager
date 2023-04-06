import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/notifiers/account_provider.dart';
import 'package:expense_tracker/pages/common/custom_text_field.dart';
import 'package:expense_tracker/pages/common/inline_color_picker.dart';
import 'package:expense_tracker/pages/common/inline_icon_picker.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewAccountPage extends StatefulWidget {
  static const routeName = '/newAccountPage';

  final Account? initialAccountSettings;

  const NewAccountPage({
    Key? key,
    this.initialAccountSettings,
  }) : super(key: key);

  @override
  State<NewAccountPage> createState() => _NewAccountPageState();
}

class _NewAccountPageState extends State<NewAccountPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController titleInput = TextEditingController();
  TextEditingController descriptionInput = TextEditingController();

  Color selectedColor = CustomColors.darkBlue;
  String? selectedIconPath;

  bool editMode = false;

  @override
  void initState() {
    super.initState();

    if (widget.initialAccountSettings != null) {
      editMode = true;

      titleInput.text = widget.initialAccountSettings!.name;
      //descriptionInput.text = widget.initialAccountSettings!.description;
      selectedColor = widget.initialAccountSettings!.color;
      selectedIconPath = widget.initialAccountSettings!.iconPath;
    }
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
        title: Text(editMode ? 'Modifica conto' : 'Nuovo conto'),
        backgroundColor: CustomColors.blue,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 17),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: _buildForm(),
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
              label: 'Titolo*',
              hintText: 'Iserisci il titolo della categoria',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Il titolo è obbligatorio';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 14,
            ),
            CustomTextField(
              controller: descriptionInput,
              label: 'Descrizione',
              hintText: 'Inserisci una descrizione',
              maxLines: null,
            ),
            const SizedBox(
              height: 14,
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
        const Text(
          'Colore',
          style: TextStyle(
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
        const Text(
          'Icona',
          style: TextStyle(
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

  _buildSaveButton() {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            if (editMode) {
              _editAccount();
            } else {
              _saveNewAccount();
            }
          }
        },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: CustomColors.darkBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          editMode ? 'Modifica' : 'Salva',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  _saveNewAccount() {
    Provider.of<AccountProvider>(context, listen: false)
        .addNewAccount(
            name: titleInput.text,
            colorValue: selectedColor.value,
            iconPath: selectedIconPath!)
        .then((value) => Navigator.of(context).pop());
  }

  _editAccount() {
    Provider.of<AccountProvider>(context, listen: false)
        .updateAccount(
            accountToEdit: widget.initialAccountSettings!,
            name: titleInput.text,
            colorValue: selectedColor.value,
            iconPath: selectedIconPath!)
        .then((value) => Navigator.of(context).pop());
  }
}
