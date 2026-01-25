import 'dart:io';
import 'package:expense_tracker/application/categories/notifiers/mutations/category_mutation_notifier.dart';
import 'package:expense_tracker/application/common/notifiers/app_localizations_provider.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/domain/models/category.dart';
import 'package:expense_tracker/presentation/pages/options_page/categories_page/new_edit_category_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:vector_graphics/vector_graphics.dart';

class CategoryListCell extends ConsumerWidget {
  final Category category;

  const CategoryListCell({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);

    return Slidable(
      key: Key(category.id.toString()),
      startActionPane: _buildDeleteActionPane(context, ref, appLocalizations),
      endActionPane: _buildDeleteActionPane(context, ref, appLocalizations),
      child: ListTile(
        onTap: () => Navigator.of(context)
            .pushNamed(NewEditCategoryPage.routeName, arguments: category),
        title: Text(
          category.name,
          style: const TextStyle(fontSize: 16),
        ),
        leading: _buildCategoryIcon(category),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }

  ActionPane _buildDeleteActionPane(
      BuildContext context, WidgetRef ref, AppLocalizations appLocalizations) {
    return ActionPane(
      motion: const ScrollMotion(),
      dismissible: DismissiblePane(
        confirmDismiss: () => showDeleteAlert(context, appLocalizations),
        closeOnCancel: true,
        onDismissed: () async =>
            await ref.read(categoryMutationProvider.notifier).delete(category),
      ),
      children: [
        _buildDeleteSlidableAction(context, ref, appLocalizations),
      ],
    );
  }

  SlidableAction _buildDeleteSlidableAction(
      BuildContext context, WidgetRef ref, AppLocalizations appLocalizations) {
    return SlidableAction(
        backgroundColor: const Color(0xFFFE4A49),
        foregroundColor: Colors.white,
        icon: Icons.delete,
        label: appLocalizations.delete,
        onPressed: (_) async {
          final isDeleteConfirmed =
              await showDeleteAlert(context, appLocalizations);

          if (context.mounted && isDeleteConfirmed) {
            await ref.read(categoryMutationProvider.notifier).delete(category);
          }
        });
  }

  Future<bool> showDeleteAlert(
      BuildContext context, AppLocalizations appLocalizations) async {
    bool isDeleteConfirmed = false;

    if (Platform.isAndroid) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              appLocalizations.areYouSure,
            ),
            content: Text(
              appLocalizations.deleteCategoryAlertBody,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  isDeleteConfirmed = false;
                  Navigator.pop(context);
                },
                child: Text(
                  appLocalizations.cancel,
                ),
              ),
              TextButton(
                onPressed: () {
                  isDeleteConfirmed = true;
                  Navigator.pop(context);
                },
                child: Text(
                  appLocalizations.delete,
                ),
              )
            ],
          );
        },
      );
    } else {
      await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(
            appLocalizations.areYouSure,
          ),
          content: Text(
            appLocalizations.deleteCategoryAlertBody,
          ),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                isDeleteConfirmed = false;
                Navigator.pop(context);
              },
              child: Text(
                appLocalizations.cancel,
              ),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                isDeleteConfirmed = true;
                Navigator.pop(context);
              },
              child: Text(
                appLocalizations.delete,
              ),
            ),
          ],
        ),
      );
    }

    return isDeleteConfirmed;
  }

  Container _buildCategoryIcon(Category category) {
    VectorGraphic? categoryIcon;
    if (category.iconPath != null) {
      categoryIcon = VectorGraphic(
        loader: AssetBytesLoader(category.iconPath!),
        colorFilter: const ColorFilter.mode(
          Colors.white,
          BlendMode.srcIn,
        ),
      );
    }

    return Container(
      width: 32,
      height: 32,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(shape: BoxShape.circle, color: category.color),
      child: categoryIcon,
    );
  }
}
