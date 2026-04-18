import 'package:expense_tracker/features/categories/presentation/providers/mutations/category_mutation_notifier.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/features/categories/domain/models/category.dart';
import 'package:expense_tracker/core/presentation/common/custom_elevated_button.dart';
import 'package:expense_tracker/core/presentation/common/custom_text_field.dart';
import 'package:expense_tracker/core/presentation/common/dialogs.dart';
import 'package:expense_tracker/core/presentation/common/inline_color_picker.dart';
import 'package:expense_tracker/core/presentation/common/inline_icon_picker.dart';
import 'package:expense_tracker/features/categories/presentation/pages/categories_list_page/transfer_transactions_bottom_sheet.dart';
import 'package:expense_tracker/features/transactions/presentation/providers/transactions_repository_provider.dart';
import 'package:expense_tracker/core/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/core/presentation/common/extensions/category_extensions.dart';
import 'package:expense_tracker/core/configuration/constants.dart';

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

  late Color selectedColor;
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
    } else {
      selectedColor = CustomColors.defaultPickerColor;
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
        bottom: false,
        child: Scrollbar(
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Constants.horizontalPadding),
                sliver: SliverFillRemaining(
                  hasScrollBody: false,
                  child: _buildForm(appLocalizations, isLoading),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              Constants.horizontalPadding, 8, Constants.horizontalPadding, 8),
          child: _buildSaveButton(appLocalizations, isLoading),
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
            itemShape: BoxShape.circle,
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
          itemShape: BoxShape.circle,
          onSelectedIcon: (newSelectedIconPath) =>
              selectedIconPath = newSelectedIconPath,
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

  Widget _buildDeleteAction(
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
        final transactionsRepo = ref.read(transactionsRepositoryProvider);

        final count = await transactionsRepo.getTransactionsCount(
          forCategory: category,
        );

        if (!mounted) return;

        final result = await showDeleteCategoryAlert(
          context: context,
          appLocalizations: appLocalizations,
          transactionCount: count,
        );

        if (!mounted) return;

        switch (result) {
          case CategoryDeletionResult.cancel:
            return;
          case CategoryDeletionResult.deleteCategoryAndTransactions:
            await ref
                .read(categoryMutationProvider.notifier)
                .deleteCategoryAndTransactions(category);
            break;
          case CategoryDeletionResult.transferTransactions:
            final targetCategory = await showTransferTransactionsBottomSheet(
              context: context,
              categoryToDelete: category,
              transactionCount: count,
            );

            if (targetCategory != null && mounted) {
              await ref
                  .read(categoryMutationProvider.notifier)
                  .reassignTransactionsAndDelete(
                    source: category,
                    target: targetCategory,
                  );
            } else {
              return;
            }
            break;
        }

        if (!mounted) return;
        navigator.pop();
      },
    );
  }
}
