import 'package:expense_tracker/features/categories/presentation/providers/queries/categories_list_notifier.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/features/categories/presentation/pages/categories_list_page/category_list_cell.dart';
import 'package:expense_tracker/features/categories/presentation/pages/categories_list_page/new_edit_category_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/core/style/app_theme.dart';

class CategoriesListPage extends ConsumerStatefulWidget {
  static const routeName = '/categoriesListPage';

  const CategoriesListPage({super.key});

  @override
  ConsumerState<CategoriesListPage> createState() => _CategoriesListPageState();
}

class _CategoriesListPageState extends ConsumerState<CategoriesListPage> {
  @override
  Widget build(BuildContext context) {
    final appLocalizations = ref.watch(appLocalizationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.yourCategories),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
      body: SafeArea(child: _buildList(appLocalizations)),
    );
  }

  Widget _buildList(AppLocalizations appLocalizations) {
    return ref.watch(categoriesListProvider).when(
          data: (categoriesList) {
            return categoriesList.isNotEmpty
                ? ListView.builder(
                    itemCount: categoriesList.length,
                    itemBuilder: (context, index) {
                      return CategoryListCell(category: categoriesList[index]);
                    },
                  )
                : Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        appLocalizations.noCategories,
                        style:
                            TextStyle(color: context.appColors.textSecondary),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              const Center(child: Text('Error loading categories')),
        );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () =>
          Navigator.pushNamed(context, NewEditCategoryPage.routeName),
    );
  }
}
