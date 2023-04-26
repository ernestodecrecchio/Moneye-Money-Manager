import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/notifiers/category_provider.dart';
import 'package:expense_tracker/pages/common/custom_text_field.dart';
import 'package:expense_tracker/pages/common/inline_color_picker.dart';
import 'package:expense_tracker/pages/common/inline_icon_picker.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewCategoryPage extends StatefulWidget {
  static const routeName = '/newCategoryPage';

  final Category? initialCategorySettings;

  const NewCategoryPage({
    Key? key,
    this.initialCategorySettings,
  }) : super(key: key);

  @override
  State<NewCategoryPage> createState() => _NewCategoryPageState();
}

class _NewCategoryPageState extends State<NewCategoryPage> {
  late final AppLocalizations appLocalizations;

  final _formKey = GlobalKey<FormState>();

  TextEditingController titleInput = TextEditingController();
  TextEditingController descriptionInput = TextEditingController();

  Color selectedColor = CustomColors.darkBlue;
  String? selectedIconPath;

  bool editMode = false;

  @override
  void initState() {
    super.initState();

    if (widget.initialCategorySettings != null) {
      editMode = true;

      titleInput.text = widget.initialCategorySettings!.name;
      descriptionInput.text = widget.initialCategorySettings!.description ?? '';
      selectedColor = widget.initialCategorySettings!.color;
      selectedIconPath = widget.initialCategorySettings!.iconPath;
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
            ? appLocalizations.editCategory
            : appLocalizations.newCategory),
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
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildForm()),
            ),
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
              hintText: appLocalizations.insertTheTitleOfTheCategory,
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
            }),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Container(
      height: 50,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            if (editMode) {
              _editCategory();
            } else {
              _saveNewCategory();
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
          editMode ? appLocalizations.applyChanges : appLocalizations.save,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  _saveNewCategory() {
    Provider.of<CategoryProvider>(context, listen: false)
        .addNewCategory(
            name: titleInput.text,
            description: descriptionInput.text,
            colorValue: selectedColor.value,
            iconPath: selectedIconPath)
        .then((value) => Navigator.of(context).pop());
  }

  _editCategory() {
    Provider.of<CategoryProvider>(context, listen: false)
        .updateCategory(
          categoryToEdit: widget.initialCategorySettings!,
          name: titleInput.text,
          description: descriptionInput.text,
          colorValue: selectedColor.value,
          iconPath: selectedIconPath,
        )
        .then((value) => Navigator.of(context).pop());
  }
}
