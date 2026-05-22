import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/features/budgeting/domain/models/budget.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Selectable radio-style cards for budget rollover mode.
class BudgetRolloverModeSelector extends StatelessWidget {
  final RolloverMode value;
  final ValueChanged<RolloverMode> onChanged;
  final AppLocalizations localizations;

  const BudgetRolloverModeSelector({
    super.key,
    required this.value,
    required this.onChanged,
    required this.localizations,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      children: [
        _RolloverModeOptionCard(
          mode: RolloverMode.none,
          groupValue: value,
          title: localizations.none,
          description: localizations.rolloverModeNoneDescription,
          onSelected: onChanged,
        ),
        _RolloverModeOptionCard(
          mode: RolloverMode.carryRemaining,
          groupValue: value,
          title: localizations.carryRemaining,
          description: localizations.rolloverModeCarryRemainingDescription,
          onSelected: onChanged,
        ),
        _RolloverModeOptionCard(
          mode: RolloverMode.carryOverspending,
          groupValue: value,
          title: localizations.carryOverspending,
          description: localizations.rolloverModeCarryOverspendingDescription,
          onSelected: onChanged,
        ),
      ],
    );
  }
}

class _RolloverModeOptionCard extends StatelessWidget {
  final RolloverMode mode;
  final RolloverMode groupValue;
  final String title;
  final String description;
  final ValueChanged<RolloverMode> onSelected;

  const _RolloverModeOptionCard({
    required this.mode,
    required this.groupValue,
    required this.title,
    required this.description,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = groupValue == mode;
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      button: true,
      selected: isSelected,
      label: '$title. $description',
      child: Material(
        color: isSelected
            ? colors.primary.withValues(alpha: 0.08)
            : colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected
                ? colors.primary
                : colors.textSecondary.withValues(alpha: 0.25),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: InkWell(
          onTap: () => onSelected(mode),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: isSelected ? colors.primary : colors.textSecondary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4,
                    children: [
                      Text(
                        title,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? colors.primary
                              : colors.textPrimary,
                        ),
                      ),
                      Text(
                        description,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
