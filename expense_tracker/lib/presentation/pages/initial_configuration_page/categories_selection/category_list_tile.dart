import 'package:expense_tracker/domain/models/category.dart';
import 'package:flutter/material.dart';
import 'package:vector_graphics/vector_graphics.dart';
import 'package:expense_tracker/style/app_theme.dart';

class CategoryListTile extends StatefulWidget {
  final Category category;
  final bool selected;
  final Function(bool)? onTap;

  const CategoryListTile({
    super.key,
    required this.category,
    required this.selected,
    this.onTap,
  });

  @override
  State<CategoryListTile> createState() => _CategoryListTileState();
}

class _CategoryListTileState extends State<CategoryListTile> {
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.selected ? 1 : 0.3,
      child: ListTile(
        onTap: () {
          setState(() {});
          if (widget.onTap != null) {
            widget.onTap!(!widget.selected);
          }
        },
        title: Text(
          widget.category.name,
          style: TextStyle(
              fontSize: 20,
              color: context.appColors.textPrimary,
              fontWeight: FontWeight.w500),
        ),
        leading: _buildCategoryIcon(widget.category),
        trailing: widget.selected
            ? Icon(
                Icons.check_circle,
                color: context.appColors.primary,
              )
            : null,
      ),
    );
  }

  Container _buildCategoryIcon(Category category) {
    VectorGraphic? categoryIcon;
    if (category.iconPath != null) {
      categoryIcon = VectorGraphic(
        loader: AssetBytesLoader(category.iconPath!),
        colorFilter: ColorFilter.mode(
          context.appColors.onPrimary,
          BlendMode.srcIn,
        ),
      );
    }

    return Container(
      width: 40,
      height: 40,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: category.color,
      ),
      child: categoryIcon,
    );
  }
}
