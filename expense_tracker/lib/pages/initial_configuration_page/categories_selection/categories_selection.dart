import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/pages/initial_configuration_page/categories_selection/category_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoriesSelection extends ConsumerStatefulWidget {
  final Function(List<Category>) onSelectedCategoryListChanged;

  const CategoriesSelection({
    Key? key,
    required this.onSelectedCategoryListChanged,
  }) : super(key: key);

  @override
  ConsumerState<CategoriesSelection> createState() =>
      _CategoriesSelectionState();
}

class _CategoriesSelectionState extends ConsumerState<CategoriesSelection> {
  List<Category> selectedCategoryList = [];

  List<Category> categoryList = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    categoryList = [
      Category(
        name: AppLocalizations.of(context)!.foodAndDining,
        colorValue: 4294944000,
        iconPath: 'assets/icons/food.svg',
      ),
      Category(
        name: AppLocalizations.of(context)!.transportation,
        colorValue: 4278223103,
        iconPath: 'assets/icons/bus.svg',
      ),
      Category(
        name: AppLocalizations.of(context)!.entertainment,
        colorValue: 4286578816,
        iconPath: 'assets/icons/popcorn.svg',
      ),
      Category(
        name: AppLocalizations.of(context)!.billsAndUtilities,
        colorValue: 4286611584,
        iconPath: 'assets/icons/bill.svg',
      ),
      Category(
        name: AppLocalizations.of(context)!.petExpenses,
        colorValue: 4294928820,
        iconPath: 'assets/icons/paw.svg',
      ),
      Category(
        name: AppLocalizations.of(context)!.subscriptions,
        colorValue: 4278222976,
        iconPath: 'assets/icons/calendar.svg',
      ),
    ];

    selectedCategoryList = categoryList;

    widget.onSelectedCategoryListChanged(selectedCategoryList);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.selectCategoryMsg1,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            AppLocalizations.of(context)!.selectCategoryMsg2,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 10),
              shrinkWrap: true,
              children: categoryList
                  .map(
                    (category) => CategoryListTile(
                      category: category,
                      selected: selectedCategoryList.contains(category),
                      onTap: (selected) {
                        if (selected) {
                          selectedCategoryList.add(category);
                        } else {
                          selectedCategoryList.remove(category);
                        }

                        widget.onSelectedCategoryListChanged(
                            selectedCategoryList);

                        setState(() {});
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
