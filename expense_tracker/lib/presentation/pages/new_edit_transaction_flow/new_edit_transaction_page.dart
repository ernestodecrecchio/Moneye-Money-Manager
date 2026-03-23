import 'package:collection/collection.dart';
import 'package:expense_tracker/application/categories/notifiers/queries/categories_list_notifier.dart';
import 'package:expense_tracker/application/common/notifiers/app_localizations_provider.dart';
import 'package:expense_tracker/application/transactions/notifiers/mutations/transaction_mutation_notifier.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/domain/models/account.dart';
import 'package:expense_tracker/domain/models/category.dart';
import 'package:expense_tracker/domain/models/transaction.dart';
import 'package:expense_tracker/domain/models/recurring_rule.dart';
import 'package:expense_tracker/application/recurring_rules/notifiers/mutations/recurring_rules_mutation_notifier.dart';
import 'package:expense_tracker/application/recurring_rules/notifiers/queries/recurring_rules_list_notifier.dart';
import 'package:expense_tracker/application/accounts/notifiers/queries/accounts_list_notifier.dart';
import 'package:expense_tracker/presentation/pages/common/custom_elevated_button.dart';
import 'package:expense_tracker/presentation/pages/new_edit_transaction_flow/account_selector_dialog.dart';
import 'package:expense_tracker/presentation/pages/common/custom_text_field.dart';
import 'package:expense_tracker/presentation/pages/new_edit_transaction_flow/category_selector_dialog.dart';
import 'package:expense_tracker/presentation/pages/common/custom_dropdown_button_form_field.dart';
import 'package:expense_tracker/presentation/pages/common/custom_form_switch.dart';
import 'package:expense_tracker/presentation/pages/options_page/recurring_rules_page/recurring_rule_detail_page.dart';
import 'package:expense_tracker/style/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:intl/intl.dart';

class NewEditTransactionPageScreenArguments {
  final bool? incomePreset;
  final Transaction? transaction;
  final RecurringRule? recurringRule;
  final Account? account;
  final bool isRecurringPreset;

  NewEditTransactionPageScreenArguments({
    this.incomePreset,
    this.transaction,
    this.recurringRule,
    this.account,
    this.isRecurringPreset = false,
  });
}

class NewEditTransactionPage extends ConsumerStatefulWidget {
  static const routeName = '/newEditTransactionPage';

  final bool? incomePreset;
  final Transaction? initialTransactionSettings;
  final RecurringRule? initialRecurringRule;
  final Account? initialAccountSettings;
  final bool isRecurringPreset;

  const NewEditTransactionPage({
    super.key,
    this.incomePreset,
    this.initialTransactionSettings,
    this.initialRecurringRule,
    this.initialAccountSettings,
    this.isRecurringPreset = false,
  });

  @override
  ConsumerState<NewEditTransactionPage> createState() =>
      _NewEditTransactionPageState();
}

class _NewEditTransactionPageState extends ConsumerState<NewEditTransactionPage>
    with SingleTickerProviderStateMixin {
  bool get editMode {
    return widget.initialTransactionSettings != null ||
        widget.initialRecurringRule != null;
  }

  final _formKey = GlobalKey<FormState>();

  late final TabController _transactionTypeTabController;

  TextEditingController titleInput = TextEditingController();
  final titleInputFocusNode = FocusNode();

  TextEditingController descriptionInput = TextEditingController();
  TextEditingController valueInput = TextEditingController();
  TextEditingController dateInput = TextEditingController();
  TextEditingController categoryInput = TextEditingController();
  TextEditingController accountInput = TextEditingController();
  TextEditingController intervalInput = TextEditingController(text: '1');
  TextEditingController endDateInput = TextEditingController();

  bool _isRecurring = false;
  String _frequency = 'monthly';

  Category? selectedCategory;
  Account? selectedAccount;
  DateTime selectedDate = DateTime.now();
  DateTime? selectedEndDate;
  bool _includeInReport = true;

  final elementSpacing = 14.0;
  final dateFormatter = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();

    _transactionTypeTabController = TabController(length: 2, vsync: this);

    if (widget.initialTransactionSettings != null) {
      final initialTransaction = widget.initialTransactionSettings!;

      titleInput.text = initialTransaction.title;
      descriptionInput.text = initialTransaction.description ?? '';
      valueInput.text = initialTransaction.amount.abs().toString();
      dateInput.text = dateFormatter.format(initialTransaction.date).toString();
      selectedDate = initialTransaction.date;

      _transactionTypeTabController.index =
          initialTransaction.amount >= 0 ? 0 : 1;

      if (initialTransaction.categoryId != null) {
        selectedCategory = ref
            .read(categoriesListProvider)
            .asData
            ?.value
            .firstWhereOrNull(
                (element) => element.id == initialTransaction.categoryId);

        if (selectedCategory != null) {
          categoryInput.text = selectedCategory!.name;
        }
      }

      if (initialTransaction.accountId != null) {
        selectedAccount = ref.read(accountsListProvider).maybeWhen(
              data: (accountsList) => accountsList.firstWhereOrNull(
                  (element) => element.id == initialTransaction.accountId!),
              orElse: () => null,
            );

        if (selectedAccount != null) {
          accountInput.text = selectedAccount!.name;
        }
      }

      _includeInReport = initialTransaction.includeInReports;
    } else if (widget.initialRecurringRule != null) {
      _isRecurring = true;
      final initialRule = widget.initialRecurringRule!;

      titleInput.text = initialRule.title;
      descriptionInput.text = initialRule.description ?? '';
      valueInput.text = initialRule.amount.abs().toString();
      dateInput.text = dateFormatter.format(initialRule.startDate).toString();
      selectedDate = initialRule.startDate;

      if (initialRule.endDate != null) {
        selectedEndDate = initialRule.endDate;
        endDateInput.text =
            dateFormatter.format(initialRule.endDate!).toString();
      }

      _transactionTypeTabController.index = initialRule.amount >= 0 ? 0 : 1;

      if (initialRule.categoryId != null) {
        selectedCategory = ref
            .read(categoriesListProvider)
            .asData
            ?.value
            .firstWhereOrNull(
                (element) => element.id == initialRule.categoryId);

        if (selectedCategory != null) {
          categoryInput.text = selectedCategory!.name;
        }
      }

      if (initialRule.accountId != null) {
        selectedAccount = ref.read(accountsListProvider).maybeWhen(
              data: (accountsList) => accountsList.firstWhereOrNull(
                  (element) => element.id == initialRule.accountId!),
              orElse: () => null,
            );

        if (selectedAccount != null) {
          accountInput.text = selectedAccount!.name;
        }
      }

      _includeInReport = initialRule.includeInReports;
      _frequency = initialRule.frequency;
      intervalInput.text = initialRule.frequencyInterval.toString();
    } else {
      titleInputFocusNode.requestFocus();
      dateInput.text = dateFormatter.format(selectedDate).toString();

      if (widget.isRecurringPreset) {
        _isRecurring = true;
      }

      final incomePreset = widget.incomePreset;

      _transactionTypeTabController.index =
          incomePreset == null || incomePreset == true ? 0 : 1;

      if (widget.initialAccountSettings != null) {
        selectedAccount = ref.read(accountsListProvider).maybeWhen(
              data: (accountsList) => accountsList.firstWhereOrNull((element) =>
                  element.id == widget.initialAccountSettings!.id!),
              orElse: () => null,
            );

        if (selectedAccount != null) {
          accountInput.text = selectedAccount!.name;
        }
      }
    }
  }

  @override
  void dispose() {
    titleInput.dispose();
    titleInputFocusNode.dispose();

    descriptionInput.dispose();
    valueInput.dispose();
    dateInput.dispose();
    categoryInput.dispose();
    accountInput.dispose();
    intervalInput.dispose();
    endDateInput.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final isTransactionLoading =
        ref.watch(transactionMutationProvider).isLoading;
    final isRuleLoading = ref.watch(recurringRulesMutationProvider).isLoading;
    final isLoading = isTransactionLoading || isRuleLoading;

    final rulesAsync = ref.watch(recurringRulesListProvider);
    final originalTx = widget.initialTransactionSettings;
    final isGenerated = originalTx?.isGenerated == true;
    final ruleId = originalTx?.recurringId;

    RecurringRule? generatedRule;
    bool isRuleDeleted = false;

    if (isGenerated && ruleId != null && rulesAsync.hasValue) {
      final rules = rulesAsync.value;
      if (rules != null) {
        generatedRule = rules.firstWhereOrNull((r) => r.id == ruleId);
        if (generatedRule == null) {
          isRuleDeleted = true;
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          editMode
              ? (widget.initialRecurringRule != null
                  ? appLocalizations.editRecurringTransaction
                  : appLocalizations.editTransaction)
              : (widget.isRecurringPreset
                  ? appLocalizations.newRecurringTransaction
                  : appLocalizations.newTransaction),
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 17),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: _buildForm(
                  appLocalizations, isLoading, generatedRule, isRuleDeleted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneratedInfoBox(AppLocalizations appLocalizations,
      RecurringRule? generatedRule, bool isRuleDeleted,
      {bool isEditingRule = false}) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = Colors.amber.withAlpha(isDark ? 30 : 50);
    final onColor = colorScheme.onSurface;
    final iconColor = isDark ? Colors.amber.shade300 : Colors.amber.shade800;

    String message;
    if (isEditingRule) {
      message = appLocalizations.editRuleInfo;
    } else if (isRuleDeleted) {
      message = appLocalizations.transactionGeneratedByDeletedRule;
    } else {
      message = appLocalizations.transactionGeneratedByRule;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Icon(
                (isRuleDeleted || isEditingRule)
                    ? Icons.warning_amber_rounded
                    : Icons.info_outline,
                color: iconColor,
                size: 20,
              ),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(color: onColor, fontSize: 13),
                ),
              ),
            ],
          ),
          if (generatedRule != null)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    RecurringRuleDetailPage.routeName,
                    arguments: generatedRule,
                  );
                },
                child: Text(appLocalizations.viewRule),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildForm(AppLocalizations appLocalizations, bool isLoading,
      RecurringRule? generatedRule, bool isRuleDeleted) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Column(
          spacing: elementSpacing,
          children: [
            if (generatedRule != null ||
                isRuleDeleted ||
                widget.initialRecurringRule != null)
              _buildGeneratedInfoBox(
                  appLocalizations, generatedRule, isRuleDeleted,
                  isEditingRule: widget.initialRecurringRule != null),
            _buildSegmentedBar(appLocalizations),
            CustomTextField(
              controller: titleInput,
              label: '${appLocalizations.title}*',
              hintText: appLocalizations.insertTheTitleOfTheTransaction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return appLocalizations.titleIsMandatory;
                }
                return null;
              },
              focusNode: titleInputFocusNode,
            ),
            CustomTextField(
              controller: valueInput,
              label: '${appLocalizations.amount}*',
              hintText: appLocalizations.insertTheAmountOfTheTransaction,
              textInputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))
              ],
              keyboardType: const TextInputType.numberWithOptions(
                  signed: true, decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return appLocalizations.amountIsMandatory;
                }
                return null;
              },
            ),
            CustomTextField(
              controller: dateInput,
              label: appLocalizations.date,
              hintText: appLocalizations.selectDate,
              icon: Icons.calendar_month_rounded,
              readOnly: true,
              onTap: () => _handleDateSelection(
                initialDate: selectedDate,
                firstDate: DateTime(1999, 1),
                onSelectedDate: (picked) {
                  if (picked != selectedDate) {
                    setState(() {
                      dateInput.text = dateFormatter.format(picked).toString();
                      selectedDate = picked;
                    });
                  }
                },
              ),
            ),
            CustomTextField(
              controller: categoryInput,
              label: appLocalizations.category,
              hintText: appLocalizations.selectCategory,
              icon: Icons.chevron_right_rounded,
              readOnly: true,
              onTap: () async {
                final Category? newSelectedCategory =
                    await showCategoryBottomSheet(context, selectedCategory);

                if (newSelectedCategory != null) {
                  if (newSelectedCategory == selectedCategory) {
                    selectedCategory = null;
                    categoryInput.clear();
                  } else {
                    categoryInput.text = newSelectedCategory.name;
                    selectedCategory = newSelectedCategory;
                  }

                  setState(() {});
                }
              },
            ),
            CustomTextField(
              controller: accountInput,
              label: appLocalizations.account,
              hintText: appLocalizations.selectAccount,
              icon: Icons.chevron_right_rounded,
              readOnly: true,
              onTap: () async {
                final Account? newSelectedAccount =
                    await showAccountBottomSheet(context, selectedAccount);

                if (newSelectedAccount != null) {
                  if (newSelectedAccount == selectedAccount) {
                    selectedAccount = null;
                    accountInput.clear();
                  } else {
                    accountInput.text = newSelectedAccount.name;
                    selectedAccount = newSelectedAccount;
                  }

                  setState(() {});
                }
              },
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Divider(height: 1),
            ),
            if (!editMode || widget.isRecurringPreset)
              _buildRepeatTransactionSection(appLocalizations),
            CustomFormSwitch(
              label: appLocalizations.includeInReports,
              value: _includeInReport,
              onChanged: (_) {
                _includeInReport = !_includeInReport;

                setState(() {});
              },
            ),
            const Spacer(),
            _buildSaveButton(appLocalizations, isLoading),
          ],
        ),
      ),
    );
  }

  Widget _buildRepeatTransactionSection(AppLocalizations localizations) {
    return Column(
      spacing: elementSpacing,
      children: [
        if (!editMode &&
            !widget.isRecurringPreset &&
            widget.initialRecurringRule == null)
          CustomFormSwitch(
            label: localizations.repeatTransaction,
            value: _isRecurring,
            onChanged: (val) {
              setState(() {
                _isRecurring = val;
              });
            },
          ),
        if (_isRecurring) ...[
          Row(
            spacing: 14,
            children: [
              Expanded(
                flex: 1,
                child: CustomTextField(
                  controller: intervalInput,
                  label: localizations.interval,
                  hintText: '1',
                  keyboardType: TextInputType.number,
                ),
              ),
              Expanded(
                flex: 2,
                child: CustomDropdownButtonFormField<String>(
                  label: localizations.frequency,
                  value: _frequency,
                  items: [
                    DropdownMenuItem(
                        value: 'daily', child: Text(localizations.daily)),
                    DropdownMenuItem(
                        value: 'weekly', child: Text(localizations.weekly)),
                    DropdownMenuItem(
                        value: 'monthly', child: Text(localizations.monthly)),
                    DropdownMenuItem(
                        value: 'yearly', child: Text(localizations.yearly)),
                  ],
                  onChanged: widget.initialRecurringRule != null
                      ? null
                      : (val) {
                          if (val != null) setState(() => _frequency = val);
                        },
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 8,
            children: [
              Expanded(
                child: CustomTextField(
                  controller: endDateInput,
                  label: localizations.endDate,
                  hintText: localizations.selectEndDate,
                  infoText: localizations.endDateInfo,
                  icon: Icons.calendar_month_rounded,
                  readOnly: true,
                  onTap: () => _handleDateSelection(
                    initialDate: selectedEndDate ?? selectedDate,
                    firstDate: selectedDate,
                    onSelectedDate: (picked) {
                      if (picked != selectedEndDate) {
                        setState(() {
                          endDateInput.text =
                              dateFormatter.format(picked).toString();
                          selectedEndDate = picked;
                        });
                      }
                    },
                  ),
                ),
              ),
              if (selectedEndDate != null)
                IconButton(
                  icon: Icon(Icons.clear_rounded,
                      color: context.appColors.primary),
                  onPressed: () {
                    setState(() {
                      selectedEndDate = null;
                      endDateInput.clear();
                    });
                  },
                ),
            ],
          ),
        ],
      ],
    );
  }

  Future<void> _handleDateSelection({
    required DateTime initialDate,
    required DateTime firstDate,
    required ValueChanged<DateTime> onSelectedDate,
  }) async {
    final colors = context.appColors;
    final DateTime? picked = await showDatePicker(
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
        lastDate: DateTime(2101));

    if (picked != null) {
      onSelectedDate(picked);
    }
  }

  Widget _buildSaveButton(AppLocalizations appLocalizations, bool isLoading) {
    return CustomElevatedButton(
      text: editMode ? appLocalizations.applyChanges : appLocalizations.save,
      isLoading: isLoading,
      onPressed: () async {
        if (!_formKey.currentState!.validate()) return;

        if (editMode) {
          await _editTransaction(
              income: _transactionTypeTabController.index == 0 ? true : false);
        } else {
          await _saveNewTransaction(
              isIncome:
                  _transactionTypeTabController.index == 0 ? true : false);
        }

        if (!mounted) return;
        Navigator.of(context).pop();
      },
    );
  }

  Future<void> _saveNewTransaction({required bool isIncome}) async {
    final transactionValue = isIncome
        ? double.parse(valueInput.text)
        : -double.parse(valueInput.text);

    final newTransaction = Transaction(
        title: titleInput.text,
        description: descriptionInput.text,
        amount: transactionValue,
        date: selectedDate,
        categoryId: selectedCategory?.id,
        accountId: selectedAccount?.id,
        includeInReports: _includeInReport,
        isHidden: false);

    if (_isRecurring) {
      final newRule = RecurringRule(
        title: titleInput.text,
        description: descriptionInput.text,
        amount: transactionValue,
        startDate: selectedDate,
        endDate: selectedEndDate,
        categoryId: selectedCategory?.id,
        accountId: selectedAccount?.id,
        includeInReports: _includeInReport,
        isHidden: false,
        frequency: _frequency,
        frequencyInterval: int.tryParse(intervalInput.text) ?? 1,
      );

      await ref
          .read(recurringRulesMutationProvider.notifier)
          .addRecurringRule(newRule);
    } else {
      await ref
          .read(transactionMutationProvider.notifier)
          .addTransaction(newTransaction);
    }

    final InAppReview inAppReview = InAppReview.instance;

    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    }
  }

  Future<void> _editTransaction({required bool income}) async {
    if (context.mounted) {
      final valueFromTextInput = double.parse(valueInput.text);

      final transactionValue = income
          ? valueFromTextInput.abs()
          : valueFromTextInput > 0
              ? -valueFromTextInput
              : valueFromTextInput;

      final modifiedTransaction = Transaction(
        title: titleInput.text,
        description: descriptionInput.text,
        amount: transactionValue,
        date: selectedDate,
        categoryId: selectedCategory?.id,
        accountId: selectedAccount?.id,
        includeInReports: _includeInReport,
        isHidden: false,
        recurringId: widget.initialTransactionSettings?.recurringId,
        originalDate: widget.initialTransactionSettings?.originalDate,
      );

      if (widget.initialRecurringRule != null) {
        final modifiedRule = RecurringRule(
          title: titleInput.text,
          description: descriptionInput.text,
          amount: transactionValue,
          startDate: selectedDate,
          endDate: selectedEndDate,
          categoryId: selectedCategory?.id,
          accountId: selectedAccount?.id,
          includeInReports: _includeInReport,
          isHidden: false,
          frequency: _frequency,
          frequencyInterval: int.tryParse(intervalInput.text) ?? 1,
          lastGeneratedDate: (widget.initialRecurringRule!.lastGeneratedDate !=
                      null &&
                  !selectedDate
                      .isAfter(widget.initialRecurringRule!.lastGeneratedDate!))
              ? widget.initialRecurringRule!.lastGeneratedDate
              : null,
        );
        modifiedRule.id = widget.initialRecurringRule!.id;

        await ref
            .read(recurringRulesMutationProvider.notifier)
            .updateRecurringRule(widget.initialRecurringRule!, modifiedRule);
      } else {
        await ref.read(transactionMutationProvider.notifier).updateTransaction(
            widget.initialTransactionSettings!, modifiedTransaction);
      }
    }
  }

  Container _buildSegmentedBar(AppLocalizations appLocalizations) {
    final colors = context.appColors;

    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(54 / 2),
      ),
      child: TabBar(
        controller: _transactionTypeTabController,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerHeight: 0,
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
        tabs: [
          Tab(
            text: appLocalizations.income,
          ),
          Tab(
            text: appLocalizations.expense,
          )
        ],
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            return states.contains(WidgetState.focused)
                ? null
                : Colors.transparent;
          },
        ),
        unselectedLabelColor: colors.textSecondary,
        labelColor: colors.onPrimary,
        indicator: BoxDecoration(
            color: colors.primary, borderRadius: BorderRadius.circular(54 / 2)),
      ),
    );
  }
}
