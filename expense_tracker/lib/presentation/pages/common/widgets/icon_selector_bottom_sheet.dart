import 'package:expense_tracker/application/common/app_icons.dart';
import 'package:expense_tracker/application/common/notifiers/app_localizations_provider.dart';
import 'package:expense_tracker/presentation/pages/common/custom_modal_bottom_sheet.dart';
import 'package:expense_tracker/presentation/pages/common/widgets/icon_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> showIconBottomSheet({
  required BuildContext context,
  required Color backgroundColor,
  required BoxShape itemShape,
  required Function(String selectedIconPath) onSelectedIcon,
  String? initialSelectionIconPath,
}) async {
  await showCustomModalBottomSheet(
    context: context,
    builder: (context) {
      return IconSelectorContent(
        backgroundColor: backgroundColor,
        itemShape: itemShape,
        currentSelectionIconPath: initialSelectionIconPath,
        onSelectedIcon: onSelectedIcon,
      );
    },
  );
}

class IconSelectorContent extends ConsumerStatefulWidget {
  final Color backgroundColor;
  final BoxShape itemShape;
  final String? currentSelectionIconPath;
  final Function(String selectedIconPath) onSelectedIcon;

  const IconSelectorContent({
    super.key,
    required this.backgroundColor,
    required this.itemShape,
    required this.onSelectedIcon,
    this.currentSelectionIconPath,
  });

  @override
  ConsumerState<IconSelectorContent> createState() =>
      _IconSelectorContentState();
}

class _IconSelectorContentState extends ConsumerState<IconSelectorContent> {
  String? _selectedIconPath;
  final Map<String, GlobalKey> _categoryKeys = {};
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _selectedIconPath = widget.currentSelectionIconPath;

    if (_selectedIconPath != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSelectedCategory();
      });
    }
  }

  void _scrollToSelectedCategory() {
    final categorizedIcons = AppIcons.categorizedIcons;
    String? targetCategory;

    for (final entry in categorizedIcons.entries) {
      if (entry.value.contains(_selectedIconPath)) {
        targetCategory = entry.key;
        break;
      }
    }

    if (targetCategory != null && _categoryKeys.containsKey(targetCategory)) {
      final context = _categoryKeys[targetCategory]!.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _getCategoryName(String key, dynamic appLocalizations) {
    // Dynamic mapping of category keys to localized strings
    // We use dynamic to avoid strict type checking if the generated class is not yet updated in the environment
    try {
      switch (key) {
        case 'bills':
          return appLocalizations.bills;
        case 'billsAndUtilities':
          return appLocalizations.billsAndUtilities;
        case 'transportation':
          return appLocalizations.transportation;
        case 'foodAndDining':
          return appLocalizations.foodAndDining;
        case 'entertainment':
          return appLocalizations.entertainment;
        case 'petExpenses':
          return appLocalizations.petExpenses;
        case 'health':
          return appLocalizations.health;
        case 'sports':
          return appLocalizations.sports;
        case 'finance':
          return appLocalizations.finance;
        case 'shopping':
          return appLocalizations.shopping;
        case 'work':
          return appLocalizations.work;
        case 'education':
          return appLocalizations.education;
        case 'other':
          return appLocalizations.other;
        default:
          return key;
      }
    } catch (_) {
      return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final textTheme = Theme.of(context).textTheme;
    final categorizedIcons = AppIcons.categorizedIcons;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 17, right: 17),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(appLocalizations.selectIcon, style: textTheme.titleMedium),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                )
              ],
            ),
            Flexible(
              child: Scrollbar(
                controller: _scrollController,
                child: ListView.separated(
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemCount: categorizedIcons.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, categoryIndex) {
                    final categoryKey =
                        categorizedIcons.keys.elementAt(categoryIndex);
                    final icons = categorizedIcons[categoryKey]!;

                    if (icons.isEmpty) return const SizedBox.shrink();

                    return Column(
                      key: _categoryKeys.putIfAbsent(
                          categoryKey, () => GlobalKey()),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            _getCategoryName(categoryKey, appLocalizations),
                            style: textTheme.labelLarge,
                          ),
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: icons.length,
                          itemBuilder: (context, index) {
                            final path = icons[index];

                            return Center(
                              child: IconItem(
                                iconPath: path,
                                shape: widget.itemShape,
                                isSelected: path == _selectedIconPath,
                                backgroundColor: widget.backgroundColor,
                                onTap: () {
                                  Navigator.of(context).pop();
                                  widget.onSelectedIcon(path);
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
