import 'package:expense_tracker/application/categories/notifiers/mutations/category_mutation_notifier.dart';
import 'package:expense_tracker/application/common/notifiers/app_localizations_provider.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/domain/models/category.dart';
import 'package:expense_tracker/presentation/pages/common/custom_elevated_button.dart';
import 'package:expense_tracker/presentation/pages/common/custom_text_field.dart';
import 'package:expense_tracker/presentation/pages/common/dialogs.dart';
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
  void dispose() {
    titleInput.dispose();
    descriptionInput.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final isLoading = ref.watch(categoryMutationProvider).isLoading;

    final List<Widget> actions = [];

    if (widget.initialCategorySettings != null) {
      final cateogry = widget.initialCategorySettings!;
      actions.add(_buildDeleteAction(
        context,
        appLocalizations,
        cateogry,
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          editMode
              ? appLocalizations.editCategory
              : appLocalizations.newCategory,
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
                  child: _buildForm(appLocalizations, isLoading)),
            ),
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
              hintText: appLocalizations.insertTheTitleOfTheCategory,
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
      children: [
        Text(
          appLocalizations.color,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
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
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(
          height: 5,
        ),
        InlineIconPicker(
            selectedIconPath: selectedIconPath,
            backgroundColor: selectedColor,
            onSelectedIcon: (newSelectedIconPath) {
              selectedIconPath = newSelectedIconPath;

              setState(() {});
            }),
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
          await _editCategory();
        } else {
          await _saveNewCategory();
        }

        if (!mounted) return;
        Navigator.of(context).pop();
      },
    );
  }

  Future<void> _saveNewCategory() async {
    final newCategory = Category(
      name: titleInput.text,
      description: descriptionInput.text,
      colorValue: selectedColor.toARGB32(),
      iconPath: selectedIconPath,
    );

    await ref.read(categoryMutationProvider.notifier).addCategory(newCategory);
  }

  Future<void> _editCategory() async {
    final modifiedCategory = Category(
      id: widget.initialCategorySettings!.id,
      name: titleInput.text,
      description: descriptionInput.text,
      colorValue: selectedColor.toARGB32(),
      iconPath: selectedIconPath,
    );

    await ref.read(categoryMutationProvider.notifier).updateCategory(
          widget.initialCategorySettings!,
          modifiedCategory,
        );
  }

  Widget _buildDeleteAction(BuildContext context,
      AppLocalizations appLocalizations, Category category) {
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
            await showDeleteCategoryAlert(context, appLocalizations);

        if (!mounted || !confirmed) return;

        await ref
            .read(categoryMutationProvider.notifier)
            .deleteCategory(category);

        if (!mounted) return;

        navigator.pop();
      },
    );
  }
}
