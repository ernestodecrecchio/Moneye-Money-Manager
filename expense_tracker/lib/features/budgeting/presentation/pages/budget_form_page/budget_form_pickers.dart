import 'package:expense_tracker/core/presentation/common/custom_modal_bottom_sheet.dart';
import 'package:expense_tracker/core/presentation/common/widgets/safe_vector_graphic.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatWeekdayLabel(
  int weekday, {
  String? localeName,
}) {
  final date = DateTime(2024, 1, weekday.clamp(1, 7));
  final name = localeName != null
      ? DateFormat.EEEE(localeName).format(date)
      : DateFormat.EEEE().format(date);
  return name[0].toUpperCase() + name.substring(1);
}

Future<int?> showDayOfMonthPicker(
  BuildContext context, {
  required int initialDay,
  required AppLocalizations appLocalizations,
}) async {
  return showCustomModalBottomSheet<int>(
    context: context,
    builder: (sheetContext) {
      return _DayOfMonthPickerSheet(
        initialDay: initialDay,
        appLocalizations: appLocalizations,
      );
    },
  );
}

Future<int?> showWeekdayPicker(
  BuildContext context, {
  required int initialWeekday,
  required AppLocalizations appLocalizations,
}) async {
  return showCustomModalBottomSheet<int>(
    context: context,
    builder: (sheetContext) {
      return _WeekdayPickerSheet(
        initialWeekday: initialWeekday,
        appLocalizations: appLocalizations,
      );
    },
  );
}

class _DayOfMonthPickerSheet extends StatelessWidget {
  final int initialDay;
  final AppLocalizations appLocalizations;

  const _DayOfMonthPickerSheet({
    required this.initialDay,
    required this.appLocalizations,
  });

  @override
  Widget build(BuildContext context) {
    final selectedDay = initialDay.clamp(1, 31);
    final textTheme = Theme.of(context).textTheme;
    final colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  appLocalizations.startsOnDayOfMonth,
                  style: textTheme.titleMedium?.copyWith(fontSize: 18),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: modalSheetScrollPadding(context),
              itemCount: 31,
              itemBuilder: (context, index) {
                final day = index + 1;
                final isSelected = day == selectedDay;
                return ListTile(
                  title: Text(
                    day.toString(),
                    style: textTheme.bodyLarge?.copyWith(fontSize: 18),
                  ),
                  trailing: isSelected
                      ? SafeVectorGraphic(
                          iconPath: 'assets/icons/checkmark.svg',
                          color: colors.primary,
                        )
                      : null,
                  onTap: () => Navigator.of(context).pop(day),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekdayPickerSheet extends StatelessWidget {
  final int initialWeekday;
  final AppLocalizations appLocalizations;

  const _WeekdayPickerSheet({
    required this.initialWeekday,
    required this.appLocalizations,
  });

  @override
  Widget build(BuildContext context) {
    final selectedWeekday = initialWeekday.clamp(1, 7);
    final textTheme = Theme.of(context).textTheme;
    final colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  appLocalizations.startsOnWeekday,
                  style: textTheme.titleMedium?.copyWith(fontSize: 18),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: modalSheetScrollPadding(context),
              itemCount: 7,
              itemBuilder: (context, index) {
                final weekday = index + 1;
                final isSelected = weekday == selectedWeekday;
                return ListTile(
                  title: Text(
                    formatWeekdayLabel(
                      weekday,
                      localeName: appLocalizations.localeName,
                    ),
                    style: textTheme.bodyLarge?.copyWith(fontSize: 18),
                  ),
                  trailing: isSelected
                      ? SafeVectorGraphic(
                          iconPath: 'assets/icons/checkmark.svg',
                          color: colors.primary,
                        )
                      : null,
                  onTap: () => Navigator.of(context).pop(weekday),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
