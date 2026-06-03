import 'package:expense_tracker/core/configuration/constants.dart';
import 'package:expense_tracker/core/presentation/common/custom_modal_bottom_sheet.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> showColorBottomSheet({
  required BuildContext context,
  required BoxShape itemShape,
  required Function(Color selectedColor) onSelectedColor,
  Color? initialSelectedColor,
}) async {
  await showCustomModalBottomSheet(
    context: context,
    builder: (context) {
      return ColorSelectorContent(
        itemShape: itemShape,
        currentSelectedColor: initialSelectedColor,
        onSelectedColor: onSelectedColor,
      );
    },
  );
}

class ColorSelectorContent extends ConsumerStatefulWidget {
  final BoxShape itemShape;
  final Color? currentSelectedColor;
  final Function(Color selectedColor) onSelectedColor;

  const ColorSelectorContent({
    super.key,
    required this.itemShape,
    required this.onSelectedColor,
    this.currentSelectedColor,
  });

  @override
  ConsumerState<ColorSelectorContent> createState() =>
      _ColorSelectorContentState();
}

class _ColorSelectorContentState extends ConsumerState<ColorSelectorContent> {
  Color? _selectedColor;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _selectedColor = widget.currentSelectedColor;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final textTheme = Theme.of(context).textTheme;
    final colors = CustomColors.pickerColorList;

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
                Text(appLocalizations.selectColor,
                    style: textTheme.titleMedium),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                )
              ],
            ),
            Flexible(
              child: Scrollbar(
                controller: _scrollController,
                child: GridView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  padding: modalSheetScrollPadding(context).copyWith(top: 10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: colors.length,
                  itemBuilder: (context, index) {
                    final color = colors[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        widget.onSelectedColor(color);
                      },
                      child: Center(
                        child: Container(
                          height: Constants.defaultIconItemHeight,
                          width: Constants.defaultIconItemWidth,
                          decoration: BoxDecoration(
                            color: color,
                            shape: widget.itemShape,
                            borderRadius: widget.itemShape == BoxShape.rectangle
                                ? BorderRadius.circular(8)
                                : null,
                          ),
                          child: color == _selectedColor
                              ? const Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
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
