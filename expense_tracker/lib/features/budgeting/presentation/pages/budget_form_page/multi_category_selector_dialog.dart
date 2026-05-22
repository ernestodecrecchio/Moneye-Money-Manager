import 'package:expense_tracker/features/categories/presentation/providers/queries/categories_list_notifier.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/features/categories/domain/models/category.dart';
import 'package:expense_tracker/core/presentation/common/custom_modal_bottom_sheet.dart';
import 'package:expense_tracker/core/presentation/common/widgets/icon_item.dart';
import 'package:expense_tracker/core/presentation/common/extensions/category_extensions.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/core/presentation/common/widgets/safe_vector_graphic.dart';

Future<List<int>?> showMultiCategoryBottomSheet(
    BuildContext context, List<int> initialSelection) async {
  return await showCustomModalBottomSheet(
    context: context,
    builder: ((context) {
      return MultiCategorySelectorContent(initialSelection: initialSelection);
    }),
  );
}

class MultiCategorySelectorContent extends ConsumerStatefulWidget {
  final List<int> initialSelection;

  const MultiCategorySelectorContent({
    super.key,
    required this.initialSelection,
  });

  @override
  ConsumerState<MultiCategorySelectorContent> createState() =>
      _MultiCategorySelectorContentState();
}

class _MultiCategorySelectorContentState
    extends ConsumerState<MultiCategorySelectorContent> {
  late List<int> _selectedIds;

  @override
  void initState() {
    super.initState();
    _selectedIds = List.from(widget.initialSelection);
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
                  appLocalizations.selectCategories,
                  style: textTheme.titleMedium?.copyWith(fontSize: 18),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(_selectedIds),
                  child: Text(appLocalizations.confirm),
                )
              ],
            ),
          ),
          Expanded(
            child: ref.watch(categoriesListProvider).when(
                  data: (categoriesList) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: categoriesList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _buildCategoryTile(categoriesList[index]);
                        });
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) =>
                      const Center(child: Text('Error loading categories')),
                ),
          ),
        ],
      ),
    );
  }

  ListTile _buildCategoryTile(Category category) {
    final textTheme = Theme.of(context).textTheme;
    final colors = context.appColors;
    final isSelected = _selectedIds.contains(category.id);

    return ListTile(
      leading: IconItem(
        backgroundColor: category.color,
        shape: BoxShape.circle,
        iconPath: category.iconPath,
      ),
      trailing: _buildCircularSelectionIndicator(
        isSelected: isSelected,
        colors: colors,
      ),
      title: Text(
        category.name,
        style: textTheme.bodyLarge?.copyWith(fontSize: 18),
      ),
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedIds.remove(category.id);
          } else {
            if (category.id != null) _selectedIds.add(category.id!);
          }
        });
      },
    );
  }

  Widget _buildCircularSelectionIndicator({
    required bool isSelected,
    required AppColors colors,
  }) {
    const double size = 22;

    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? colors.primary : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? colors.primary
                : colors.textSecondary.withValues(alpha: 0.4),
            width: 2,
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(4),
          child: isSelected
              ? SafeVectorGraphic(
                  iconPath: 'assets/icons/checkmark.svg',
                  color: colors.onPrimary,
                )
              : null,
        ),
      ),
    );
  }
}
