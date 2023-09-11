import 'package:expense_tracker/notifiers/category_provider.dart';
import 'package:expense_tracker/pages/options_page/categories_page/category_list_cell.dart';
import 'package:expense_tracker/pages/options_page/categories_page/new_edit_category_page.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoriesListPage extends ConsumerStatefulWidget {
  static const routeName = '/categoriesListPage';

  const CategoriesListPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CategoriesListPage> createState() => _CategoriesListPageState();
}

class _CategoriesListPageState extends ConsumerState<CategoriesListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.yourCategories),
        backgroundColor: CustomColors.blue,
        elevation: 0,
      ),
      floatingActionButton: _buildFloatingActionButton(context),
      body: _buildList(),
    );
  }

  Widget _buildList() {
    return RefreshIndicator(
      onRefresh: () =>
          ref.read(categoryProvider.notifier).getCategoriesFromDb(),
      child: Consumer(
        builder: ((context, ref, child) {
          return ref.watch(categoryProvider).isNotEmpty
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
                      AppLocalizations.of(context)!.noCategories,
                      style: const TextStyle(color: Colors.grey),
                      textAlign: TextAlign.start,
                    ),
                  ),
                );
        }),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: CustomColors.darkBlue,
      child: const Icon(Icons.add),
      onPressed: () =>
          Navigator.pushNamed(context, NewEditCategoryPage.routeName),
    );
  }
}
