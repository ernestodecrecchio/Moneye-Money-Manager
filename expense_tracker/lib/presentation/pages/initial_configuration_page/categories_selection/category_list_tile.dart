import 'package:expense_tracker/domain/models/category.dart';
import 'package:expense_tracker/presentation/pages/common/widgets/icon_item.dart';
import 'package:flutter/material.dart';

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
          style: const TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
        ),
        leading: _buildCategoryIcon(widget.category),
        trailing: widget.selected
            ? const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 20,
              )
            : null,
      ),
    );
  }

  Widget _buildCategoryIcon(Category category) {
    return IconItem(
      backgroundColor: category.color,
      iconPath: category.iconPath,
      shape: BoxShape.circle,
      isSelected: widget.selected,
    );
  }
}
