import 'package:expense_tracker/core/configuration/constants.dart';
import 'package:expense_tracker/core/presentation/common/custom_elevated_button.dart';
import 'package:expense_tracker/core/presentation/common/widgets/icon_item.dart';
import 'package:expense_tracker/features/budgeting/domain/logic/budget_calculator.dart';
import 'package:expense_tracker/features/budgeting/domain/models/budget.dart';
import 'package:expense_tracker/core/presentation/common/custom_text_field.dart';
import 'package:expense_tracker/core/presentation/common/amount_keyboard/amount_keyboard_scope.dart';
import 'package:expense_tracker/core/presentation/common/amount_keyboard/amount_text_field.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/features/budgeting/presentation/providers/mutations/budget_mutation_notifier.dart';
import 'package:expense_tracker/features/budgeting/presentation/pages/budget_form_page/budget_form_pickers.dart';
import 'package:expense_tracker/features/budgeting/presentation/pages/budget_form_page/budget_rollover_mode_selector.dart';
import 'package:expense_tracker/features/budgeting/presentation/pages/budget_form_page/multi_category_selector_dialog.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/features/categories/domain/models/category.dart';
import 'package:expense_tracker/core/presentation/common/extensions/category_extensions.dart';
import 'package:expense_tracker/features/categories/presentation/providers/queries/categories_list_notifier.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class BudgetFormPage extends ConsumerStatefulWidget {
  static const routeName = '/budgetFormPage';
  final Budget? initialBudget;

  const BudgetFormPage({super.key, this.initialBudget});

  @override
  ConsumerState<BudgetFormPage> createState() => _BudgetFormPageState();
}

class _BudgetFormPageState extends ConsumerState<BudgetFormPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _amountController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late TextEditingController _startDayController;
  late TextEditingController _startWeekdayController;

  PeriodType _selectedPeriodType = PeriodType.monthly;
  int? _startDay = 1;
  int? _startWeekday = 1;
  DateTime? _customStartDate;
  DateTime? _customEndDate;
  List<int> _selectedCategoryIds = [];
  bool _allCategories = false;
  RolloverMode _rolloverMode = RolloverMode.none;

  @override
  void initState() {
    super.initState();
    final budget = widget.initialBudget;

    _nameController = TextEditingController(text: budget?.name ?? '');
    _amountController =
        TextEditingController(text: budget?.amount.toString() ?? '');
    _startDateController = TextEditingController();
    _endDateController = TextEditingController();
    _startDayController = TextEditingController(text: '${_startDay ?? 1}');
    _startWeekdayController = TextEditingController(
      text: formatWeekdayLabel(_startWeekday ?? 1),
    );

    if (budget == null) {
      final today = DateTime.now();
      _startDay = today.day;
      _startWeekday = today.weekday;
      _startDayController.text = '$_startDay';
      _startWeekdayController.text = formatWeekdayLabel(_startWeekday!);
    }

    if (budget != null) {
      _selectedPeriodType = budget.periodType;
      _startDay = budget.startDay;
      _startWeekday = budget.startWeekday;
      _customStartDate = budget.customStartDate;
      _customEndDate = budget.customEndDate;
      _selectedCategoryIds = List.from(budget.categoryIds);
      _allCategories = budget.allCategories;
      _rolloverMode = budget.rolloverMode;
      _startDayController.text = '${_startDay ?? 1}';
      _startWeekdayController.text = formatWeekdayLabel(_startWeekday ?? 1);

      if (_customStartDate != null) {
        _startDateController.text =
            DateFormat.yMd(Platform.localeName).format(_customStartDate!);
      }
      if (_customEndDate != null) {
        _endDateController.text =
            DateFormat.yMd(Platform.localeName).format(_customEndDate!);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _startDayController.dispose();
    _startWeekdayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final isLoading = ref.watch(budgetMutationProvider).isLoading;
    final categories = ref.watch(categoriesListProvider).asData?.value ?? [];

    return AmountKeyboardScope(
      doneLabel: appLocalizations.done,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.initialBudget == null
              ? appLocalizations.newBudget
              : appLocalizations.editBudget),
          actions: widget.initialBudget != null
              ? [_buildDeleteAction(appLocalizations)]
              : null,
        ),
        body: Form(
          key: _formKey,
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Constants.horizontalPadding, vertical: 20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    CustomTextField(
                      controller: _nameController,
                      label: appLocalizations.title,
                      hintText: appLocalizations.budgetTitleHint,
                      validator: (val) => val == null || val.isEmpty
                          ? appLocalizations.titleIsMandatory
                          : null,
                    ),
                    const SizedBox(height: 14),
                    AmountTextField(
                      controller: _amountController,
                      label: appLocalizations.amount,
                      hintText: '0.00',
                      validator: (val) => val == null || val.isEmpty
                          ? appLocalizations.amountIsMandatory
                          : null,
                    ),
                    const SizedBox(height: 14),
                    _buildCategorySelectionSection(
                        appLocalizations, categories),
                    const SizedBox(height: 24),
                    Text(appLocalizations.budgetDuration,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                    _buildPeriodSelector(appLocalizations),
                    const SizedBox(height: 14),
                    _buildPeriodConfig(appLocalizations),
                    if (_selectedPeriodType != PeriodType.custom) ...[
                      const SizedBox(height: 24),
                      Text(appLocalizations.rolloverMode,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 12),
                      BudgetRolloverModeSelector(
                        value: _rolloverMode,
                        localizations: appLocalizations,
                        onChanged: (mode) =>
                            setState(() => _rolloverMode = mode),
                      ),
                    ],
                    const SizedBox(height: 40),
                  ]),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(Constants.horizontalPadding),
            child: CustomElevatedButton(
              text: appLocalizations.save,
              isLoading: isLoading,
              onPressed: () => _saveBudget(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySelectionSection(
      dynamic appLocalizations, List<Category> allCategories) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;
    final selectedCategories = allCategories
        .where((c) => _selectedCategoryIds.contains(c.id))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        Text(
          appLocalizations.categories,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        CheckboxListTile(
          value: _allCategories,
          onChanged: (value) {
            setState(() {
              _allCategories = value ?? false;
              if (_allCategories) {
                _selectedCategoryIds = [];
              }
            });
          },
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(
            appLocalizations.allCategories,
            style: textTheme.bodyLarge,
          ),
          subtitle: Text(
            appLocalizations.allCategoriesDescription,
            style: textTheme.bodySmall?.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ),
        GestureDetector(
          onTap: _allCategories
              ? null
              : () async {
                  final selected = await showMultiCategoryBottomSheet(
                      context, _selectedCategoryIds);
                  if (selected != null) {
                    setState(() {
                      _selectedCategoryIds = selected;
                    });
                  }
                },
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 48),
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: selectedCategories.isEmpty ? 0 : 16,
            ),
            decoration: BoxDecoration(
              color: colors.fieldBackground,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Opacity(
              opacity: _allCategories ? 0.5 : 1,
              child: Row(
                spacing: 8,
                children: [
                  Expanded(
                    child: _allCategories
                        ? Text(
                            appLocalizations.allCategories,
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : selectedCategories.isEmpty
                            ? Text(
                                appLocalizations.selectCategories,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colors.textSecondary.withAlpha(150),
                                ),
                              )
                            : Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: selectedCategories.map(
                                  (category) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedCategoryIds
                                              .remove(category.id);
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: category.color
                                              .withValues(alpha: 0.12),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                            color: category.color
                                                .withValues(alpha: 0.3),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconItem(
                                              backgroundColor: category.color,
                                              iconPath: category.iconPath,
                                              shape: BoxShape.circle,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              category.name,
                                              style: TextStyle(
                                                color: category.color,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(width: 3),
                                            Icon(
                                              Icons.close,
                                              size: 13,
                                              color: category.color
                                                  .withValues(alpha: 0.6),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ).toList(),
                              ),
                  ),
                  if (!_allCategories)
                    Icon(
                      Icons.chevron_right_rounded,
                      color: colors.primary,
                      size: 18,
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodSelector(dynamic appLocalizations) {
    return SegmentedButton<PeriodType>(
      showSelectedIcon: false,
      segments: [
        ButtonSegment(
            value: PeriodType.monthly,
            label: FittedBox(child: Text(appLocalizations.monthly))),
        ButtonSegment(
            value: PeriodType.weekly,
            label: FittedBox(child: Text(appLocalizations.weekly))),
        ButtonSegment(
            value: PeriodType.custom,
            label: FittedBox(child: Text(appLocalizations.other))),
      ],
      selected: {_selectedPeriodType},
      onSelectionChanged: (set) {
        setState(() {
          final next = set.first;
          if (next == PeriodType.weekly &&
              _selectedPeriodType != PeriodType.weekly) {
            _startWeekday ??= DateTime.now().weekday;
            _startWeekdayController.text = formatWeekdayLabel(
              _startWeekday!,
              localeName: appLocalizations.localeName,
            );
          }
          if (next == PeriodType.monthly &&
              _selectedPeriodType != PeriodType.monthly) {
            _startDay ??= DateTime.now().day;
            _startDayController.text = '$_startDay';
          }
          _selectedPeriodType = next;
        });
      },
    );
  }

  Widget _buildPeriodConfig(dynamic appLocalizations) {
    if (_selectedPeriodType == PeriodType.monthly) {
      return CustomTextField(
        controller: _startDayController,
        label: appLocalizations.startsOnDayOfMonth,
        readOnly: true,
        icon: Icons.chevron_right_rounded,
        onTap: () => _pickStartDayOfMonth(appLocalizations),
      );
    } else if (_selectedPeriodType == PeriodType.weekly) {
      return CustomTextField(
        controller: _startWeekdayController,
        label: appLocalizations.startsOnWeekday,
        readOnly: true,
        icon: Icons.chevron_right_rounded,
        onTap: () => _pickStartWeekday(appLocalizations),
      );
    } else {
      return Column(
        spacing: 14,
        children: [
          CustomTextField(
            controller: _startDateController,
            label: appLocalizations.startDate,
            hintText: appLocalizations.selectDate,
            icon: Icons.calendar_month_rounded,
            readOnly: true,
            onTap: () => _handleDateSelection(
              appLocalizations: appLocalizations,
              initialDate: _customStartDate ?? DateTime.now(),
              firstDate: DateTime(1999, 1),
              onSelectedDate: (picked) {
                setState(() {
                  _customStartDate = picked;
                  _startDateController.text =
                      DateFormat.yMd(appLocalizations.localeName)
                          .format(picked);
                  if (_customEndDate != null &&
                      _customEndDate!.isBefore(picked)) {
                    _customEndDate = null;
                    _endDateController.clear();
                  }
                });
              },
            ),
          ),
          CustomTextField(
            controller: _endDateController,
            label: appLocalizations.endDate,
            hintText: appLocalizations.selectEndDate,
            icon: Icons.calendar_month_rounded,
            readOnly: true,
            onTap: () => _handleDateSelection(
              appLocalizations: appLocalizations,
              initialDate: _customEndDate ?? _customStartDate ?? DateTime.now(),
              firstDate: _customStartDate ?? DateTime(1999, 1),
              onSelectedDate: (picked) {
                setState(() {
                  _customEndDate = picked;
                  _endDateController.text =
                      DateFormat.yMd(appLocalizations.localeName)
                          .format(picked);
                });
              },
            ),
          ),
        ],
      );
    }
  }

  Future<void> _handleDateSelection({
    required AppLocalizations appLocalizations,
    required DateTime initialDate,
    required DateTime firstDate,
    required ValueChanged<DateTime> onSelectedDate,
  }) async {
    final colors = context.appColors;
    final picked = await showDatePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            datePickerTheme: DatePickerThemeData(
              headerBackgroundColor: colors.primary,
              headerForegroundColor: colors.onPrimary,
              backgroundColor: colors.scaffoldBackground,
              todayBackgroundColor: WidgetStateProperty.resolveWith(
                (states) {
                  if (states.contains(WidgetState.selected)) {
                    return colors.primary;
                  }
                  return Colors.transparent;
                },
              ),
              dayBackgroundColor: WidgetStateProperty.resolveWith(
                (states) {
                  if (states.contains(WidgetState.selected)) {
                    return colors.primary;
                  }
                  return Colors.transparent;
                },
              ),
            ),
          ),
          child: child!,
        );
      },
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      onSelectedDate(picked);
    }
  }

  Future<void> _pickStartDayOfMonth(AppLocalizations appLocalizations) async {
    final day = await showDayOfMonthPicker(
      context,
      initialDay: _startDay ?? 1,
      appLocalizations: appLocalizations,
    );
    if (day != null) {
      setState(() {
        _startDay = day;
        _startDayController.text = day.toString();
      });
    }
  }

  Future<void> _pickStartWeekday(AppLocalizations appLocalizations) async {
    final weekday = await showWeekdayPicker(
      context,
      initialWeekday: _startWeekday ?? 1,
      appLocalizations: appLocalizations,
    );
    if (weekday != null) {
      setState(() {
        _startWeekday = weekday;
        _startWeekdayController.text = formatWeekdayLabel(
          weekday,
          localeName: appLocalizations.localeName,
        );
      });
    }
  }

  bool _hasPeriodConfigChanged(Budget? initial) {
    if (initial == null) return false;
    if (initial.periodType != _selectedPeriodType) return true;
    switch (_selectedPeriodType) {
      case PeriodType.monthly:
        return initial.startDay != _startDay;
      case PeriodType.weekly:
        return initial.startWeekday != _startWeekday;
      case PeriodType.custom:
        return initial.customStartDate != _customStartDate ||
            initial.customEndDate != _customEndDate;
    }
  }

  Future<void> _saveBudget() async {
    final appLocalizations = ref.read(appLocalizationsProvider);
    if (!_formKey.currentState!.validate()) return;
    if (!_allCategories && _selectedCategoryIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(appLocalizations.selectAtLeastOneCategory)));
      return;
    }

    final now = DateTime.now();
    final initial = widget.initialBudget;
    final periodConfigChanged = _hasPeriodConfigChanged(initial);

    final draft = Budget(
      name: _nameController.text,
      amount: double.parse(_amountController.text),
      periodType: _selectedPeriodType,
      startDay: _selectedPeriodType == PeriodType.monthly ? _startDay : null,
      startWeekday:
          _selectedPeriodType == PeriodType.weekly ? _startWeekday : null,
      customStartDate:
          _selectedPeriodType == PeriodType.custom ? _customStartDate : null,
      customEndDate:
          _selectedPeriodType == PeriodType.custom ? _customEndDate : null,
      createdAt: initial?.createdAt ?? now,
      updatedAt: now,
      categoryIds: _allCategories ? [] : _selectedCategoryIds,
      allCategories: _allCategories,
    );

    final currentPeriod = BudgetCalculator.getPeriodBoundaries(draft, now);
    final periodStart = _selectedPeriodType == PeriodType.custom
        ? _customStartDate
        : BudgetCalculator.normalizePeriodStart(currentPeriod.start);

    final budget = Budget(
      id: initial?.id,
      name: draft.name,
      amount: draft.amount,
      periodType: draft.periodType,
      startDay: draft.startDay,
      startWeekday: draft.startWeekday,
      customStartDate: draft.customStartDate,
      customEndDate: draft.customEndDate,
      rolloverMode: _selectedPeriodType == PeriodType.custom
          ? RolloverMode.none
          : _rolloverMode,
      rolloverAmount: periodConfigChanged ? 0 : (initial?.rolloverAmount ?? 0),
      periodStart: periodConfigChanged
          ? periodStart
          : (initial?.periodStart ?? periodStart),
      categoryIds: draft.categoryIds,
      allCategories: draft.allCategories,
      createdAt: draft.createdAt,
      updatedAt: draft.updatedAt,
    );

    if (widget.initialBudget != null) {
      await ref
          .read(budgetMutationProvider.notifier)
          .updateBudget(widget.initialBudget!, budget);
    } else {
      await ref.read(budgetMutationProvider.notifier).addBudget(budget);
    }

    if (mounted) Navigator.of(context).pop();
  }

  Widget _buildDeleteAction(AppLocalizations appLocalizations) {
    return TextButton(
      onPressed: _confirmDelete,
      child: Text(
        appLocalizations.delete,
        style: TextStyle(
          color: Theme.of(context).appBarTheme.foregroundColor,
        ),
      ),
    );
  }

  Future<void> _confirmDelete() async {
    final appLocalizations = ref.read(appLocalizationsProvider);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(appLocalizations.areYouSure),
        content: Text(appLocalizations.deleteBudgetConfirmation),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(appLocalizations.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(appLocalizations.delete,
                style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && widget.initialBudget != null) {
      await ref
          .read(budgetMutationProvider.notifier)
          .deleteBudget(widget.initialBudget!);
      if (mounted) Navigator.of(context).pop();
    }
  }
}
