import 'package:expense_tracker/application/categories/notifiers/queries/categories_list_notifier.dart';
import 'package:expense_tracker/application/common/notifiers/app_localizations_provider.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/application/categories/notifiers/category_provider.dart';
import 'package:expense_tracker/presentation/pages/options_page/categories_page/category_list_cell.dart';
import 'package:expense_tracker/presentation/pages/options_page/categories_page/new_edit_category_page.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        backgroundColor: CustomColors.blue,
      ),
      floatingActionButton: _buildFloatingActionButton(context),
      body: _buildList(appLocalizations),
    );
  }

  Widget _buildList(AppLocalizations appLocalizations) {
    return ref.watch(categoriesListProvider).when(
          data: (categoriesList) {
            return categoriesList.isNotEmpty
                ? ListView.builder(
                    itemCount: ref.watch(categoryProvider).length,
                    itemBuilder: (context, index) {
                      return CategoryListCell(
                          category: ref.read(categoryProvider)[index]);
                    },
                  )
                : Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        appLocalizations.noCategories,
                        style: const TextStyle(color: Colors.grey),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              const Text('Error loading currency list'),
        );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: CustomColors.darkBlue,
      shape: const CircleBorder(),
      child: const Icon(Icons.add),
      onPressed: () =>
          Navigator.pushNamed(context, NewEditCategoryPage.routeName),
    );
  }
}
