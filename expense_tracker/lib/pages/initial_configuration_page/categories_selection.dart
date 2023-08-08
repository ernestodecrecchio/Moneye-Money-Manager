import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/pages/initial_configuration_page/categories_selection/category_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesSelection extends ConsumerStatefulWidget {
  const CategoriesSelection({Key? key}) : super(key: key);

  @override
  ConsumerState<CategoriesSelection> createState() =>
      _CategoriesSelectionState();
}

class _CategoriesSelectionState extends ConsumerState<CategoriesSelection> {
  List<Category> selectedCategoryList = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Make the most of Moneye by categorizing your transactions',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          const Text(
            "Select from our preconfigured list or create your custom categories later",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          ListView(
            padding: const EdgeInsets.only(top: 10),
            shrinkWrap: true,
            children: [
              CategoryListTile(
                category: Category(
                  name: 'Food & Dining',
                  id: 0,
                  colorValue: 4294944000,
                  iconPath: 'assets/icons/food.svg',
                ),
                onTap: (selected) {
                  if (selected) {
                    selectedCategoryList.add(
                      Category(
                        name: 'Transportation',
                        id: 0,
                        colorValue: 4278214515,
                        iconPath: 'assets/icons/cash.svg',
                      ),
                    );
                  } else {
                    selectedCategoryList
                        .removeWhere((element) => element.id == 0);
                  }
                },
              ),
              CategoryListTile(
                category: Category(
                  name: 'Transportation',
                  id: 0,
                  colorValue: 4278223103,
                  iconPath: 'assets/icons/bus.svg',
                ),
                onTap: (selected) {
                  if (selected) {
                    selectedCategoryList.add(
                      Category(
                        name: 'Transportation',
                        id: 0,
                        colorValue: 4278214515,
                        iconPath: 'assets/icons/bus.svg',
                      ),
                    );
                  } else {
                    selectedCategoryList
                        .removeWhere((element) => element.id == 0);
                  }
                },
              ),
              CategoryListTile(
                category: Category(
                  name: 'Entertainment',
                  id: 1,
                  colorValue: 4286578816,
                  iconPath: 'assets/icons/popcorn.svg',
                ),
                onTap: (selected) {
                  if (selected) {
                    selectedCategoryList.add(
                      Category(
                        name: 'Credit Card',
                        id: 1,
                        colorValue: 4291454722,
                        iconPath: 'assets/icons/credit_card.svg',
                      ),
                    );
                  } else {
                    selectedCategoryList
                        .removeWhere((element) => element.id == 1);
                  }
                },
              ),
              CategoryListTile(
                category: Category(
                  name: 'Bills and Utilities',
                  id: 2,
                  colorValue: 4286611584,
                  iconPath: 'assets/icons/bill.svg',
                ),
                onTap: (selected) {
                  if (selected) {
                    selectedCategoryList.add(
                      Category(
                        name: 'Debit Card',
                        id: 2,
                        colorValue: 4289472825,
                        iconPath: 'assets/icons/credit_card.svg',
                      ),
                    );
                  } else {
                    selectedCategoryList
                        .removeWhere((element) => element.id == 2);
                  }
                },
              ),
              CategoryListTile(
                category: Category(
                  name: 'Pet Expenses',
                  id: 3,
                  colorValue: 4294928820,
                  iconPath: 'assets/icons/paw.svg',
                ),
                onTap: (selected) {
                  if (selected) {
                    selectedCategoryList.add(
                      Category(
                        name: 'Savings',
                        id: 3,
                        colorValue: 4283990359,
                        iconPath: 'assets/icons/savings.svg',
                      ),
                    );
                  } else {
                    selectedCategoryList
                        .removeWhere((element) => element.id == 3);
                  }
                },
              ),
              CategoryListTile(
                category: Category(
                  name: 'Subscriptions',
                  id: 3,
                  colorValue: 4278222976,
                  iconPath: 'assets/icons/calendar.svg',
                ),
                onTap: (selected) {
                  if (selected) {
                    selectedCategoryList.add(
                      Category(
                        name: 'Savings',
                        id: 3,
                        colorValue: 4283990359,
                        iconPath: 'assets/icons/savings.svg',
                      ),
                    );
                  } else {
                    selectedCategoryList
                        .removeWhere((element) => element.id == 3);
                  }
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
