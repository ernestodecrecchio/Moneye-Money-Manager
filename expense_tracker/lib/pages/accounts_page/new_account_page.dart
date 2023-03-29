import 'package:expense_tracker/notifiers/account_provider.dart';
import 'package:expense_tracker/pages/common/custom_text_field.dart';
import 'package:expense_tracker/pages/common/inline_color_picker.dart';
import 'package:expense_tracker/pages/common/inline_icon_picker.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewAccountPage extends StatefulWidget {
  static const routeName = '/newAccountPage';

  const NewAccountPage({Key? key}) : super(key: key);

  @override
  State<NewAccountPage> createState() => _NewAccountPageState();
}

class _NewAccountPageState extends State<NewAccountPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController titleInput = TextEditingController();
  TextEditingController descriptionInput = TextEditingController();

  Color selectedColor = CustomColors.darkBlue;
  IconData? selectedIcon;

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
        title: const Text('Nuovo conto'),
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
            selectedIconData: selectedIcon,
            backgorundColor: selectedColor,
            onSelectedIconData: (newSelectedIcon) {
              selectedIcon = newSelectedIcon;

              setState(() {});
            }),
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
            _saveNewAccount();
          }
        },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: CustomColors.darkBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: const Text(
          'Salva',
          style: TextStyle(
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
            iconData: selectedIcon!)
        .then((value) => Navigator.of(context).pop());
  }
}
