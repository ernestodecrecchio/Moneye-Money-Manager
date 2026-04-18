import 'package:expense_tracker/features/categories/domain/models/category.dart';
import 'package:expense_tracker/core/presentation/common/widgets/icon_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:expense_tracker/core/presentation/common/extensions/category_extensions.dart';

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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: widget.selected
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.selected
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.transparent,
          width: 1,
        ),
      ),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: widget.selected ? 1.0 : 0.4,
        child: ListTile(
          onTap: () {
            HapticFeedback.lightImpact();
            if (widget.onTap != null) {
              widget.onTap!(!widget.selected);
            }
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          title: Text(
            widget.category.name,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          leading: _buildCategoryIcon(widget.category),
          trailing: AnimatedScale(
            duration: const Duration(milliseconds: 300),
            scale: widget.selected ? 1.0 : 0.0,
            child: const Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
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
