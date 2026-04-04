import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/features/categories/domain/models/category.dart';
import 'package:expense_tracker/features/onboarding/presentation/pages/categories_selection/category_list_tile.dart';
import 'package:expense_tracker/core/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesSelection extends ConsumerStatefulWidget {
  final Function(List<Category>) onSelectedCategoryListChanged;

  const CategoriesSelection({
    super.key,
    required this.onSelectedCategoryListChanged,
  });

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

    final appLocalizations = ref.read(appLocalizationsProvider);

    categoryList = [
      Category(
        name: appLocalizations.foodAndDining,
        colorValue: CustomColors.pickerColorList[9].toARGB32(),
        iconPath: 'assets/icons/food.svg',
      ),
      Category(
        name: appLocalizations.transportation,
        colorValue: CustomColors.pickerColorList[11].toARGB32(),
        iconPath: 'assets/icons/bus.svg',
      ),
      Category(
        name: appLocalizations.entertainment,
        colorValue: CustomColors.pickerColorList[6].toARGB32(),
        iconPath: 'assets/icons/popcorn.svg',
      ),
      Category(
        name: appLocalizations.billsAndUtilities,
        colorValue: CustomColors.pickerColorList[8].toARGB32(),
        iconPath: 'assets/icons/bill.svg',
      ),
      Category(
        name: appLocalizations.petExpenses,
        colorValue: CustomColors.pickerColorList[10].toARGB32(),
        iconPath: 'assets/icons/paw.svg',
      ),
      Category(
        name: appLocalizations.subscriptions,
        colorValue: CustomColors.pickerColorList[0].toARGB32(),
        iconPath: 'assets/icons/calendar.svg',
      ),
    ];

    selectedCategoryList = List.from(categoryList);

    widget.onSelectedCategoryListChanged(selectedCategoryList);
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = ref.watch(appLocalizationsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          Text(
            appLocalizations.selectCategoryMsg1,
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
            appLocalizations.selectCategoryMsg2,
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
