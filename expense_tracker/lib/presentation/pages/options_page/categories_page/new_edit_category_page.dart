import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/domain/models/category.dart';
import 'package:expense_tracker/notifiers/category_provider.dart';
import 'package:expense_tracker/presentation/pages/common/custom_elevated_button.dart';
import 'package:expense_tracker/presentation/pages/common/custom_text_field.dart';
import 'package:expense_tracker/presentation/pages/common/inline_color_picker.dart';
import 'package:expense_tracker/presentation/pages/common/inline_icon_picker.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewEditCategoryPage extends ConsumerStatefulWidget {
  static const routeName = '/newEditCategoryPage';

  final Category? initialCategorySettings;

  const NewEditCategoryPage({
    super.key,
    this.initialCategorySettings,
  });

  @override
  ConsumerState<NewEditCategoryPage> createState() =>
      _NewEditCategoryPageState();
}

class _NewEditCategoryPageState extends ConsumerState<NewEditCategoryPage> {
  late final AppLocalizations appLocalizations;

  final _formKey = GlobalKey<FormState>();

  TextEditingController titleInput = TextEditingController();
  TextEditingController descriptionInput = TextEditingController();

  Color selectedColor = CustomColors.darkBlue;
  String? selectedIconPath;

  bool get editMode {
    return widget.initialCategorySettings != null;
  }

  @override
  void initState() {
    super.initState();

    if (editMode) {
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
      ),
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
              //   maxLines: null,
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
    return CustomElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          if (editMode) {
            _editCategory();
          } else {
            _saveNewCategory();
          }
        }
      },
      text: editMode ? appLocalizations.applyChanges : appLocalizations.save,
    );
  }

  void _saveNewCategory() {
    ref
        .read(categoryProvider.notifier)
        .addNewCategoryByParameters(
            name: titleInput.text,
            description: descriptionInput.text,
            colorValue: selectedColor.toARGB32(),
            iconPath: selectedIconPath)
        .then((value) => {if (mounted) Navigator.of(context).pop()});
  }

  void _editCategory() {
    ref
        .read(categoryProvider.notifier)
        .updateCategory(
          categoryToEdit: widget.initialCategorySettings!,
          name: titleInput.text,
          description: descriptionInput.text,
          colorValue: selectedColor.toARGB32(),
          iconPath: selectedIconPath,
        )
        .then((value) => {if (mounted) Navigator.of(context).pop()});
  }
}
