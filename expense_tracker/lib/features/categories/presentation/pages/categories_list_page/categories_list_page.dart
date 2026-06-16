import 'package:expense_tracker/core/presentation/common/widgets/list_empty_state.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/features/categories/presentation/pages/categories_list_page/category_list_cell.dart';
import 'package:expense_tracker/features/categories/presentation/pages/categories_list_page/new_edit_category_page.dart';
import 'package:expense_tracker/features/categories/presentation/providers/queries/categories_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesListPage extends ConsumerWidget {
  static const routeName = '/categoriesListPage';

  const CategoriesListPage({super.key});

  void _openCreateCategory(BuildContext context) {
    Navigator.pushNamed(context, NewEditCategoryPage.routeName);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final categoriesAsync = ref.watch(categoriesListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.yourCategories),
      ),
      body: SafeArea(
        child: categoriesAsync.when(
          data: (categoriesList) {
            if (categoriesList.isEmpty) {
              return ListEmptyState(
                icon: Icons.grid_view_rounded,
                message: appLocalizations.noCategoriesListMessage,
                actionLabel: appLocalizations.newCategory,
                onAction: () => _openCreateCategory(context),
              );
            }

            return ListView.builder(
              itemCount: categoriesList.length,
              itemBuilder: (context, index) {
                return CategoryListCell(category: categoriesList[index]);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              const Center(child: Text('Error loading categories')),
        ),
      ),
      floatingActionButton: categoriesAsync.asData?.value.isNotEmpty == true
          ? FloatingActionButton(
              onPressed: () => _openCreateCategory(context),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
