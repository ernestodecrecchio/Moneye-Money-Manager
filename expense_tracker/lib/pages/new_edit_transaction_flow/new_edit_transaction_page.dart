import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/notifiers/account_provider.dart';
import 'package:expense_tracker/notifiers/category_provider.dart';
import 'package:expense_tracker/notifiers/transaction_provider.dart';
import 'package:expense_tracker/pages/common/custom_elevated_button.dart';
import 'package:expense_tracker/pages/new_edit_transaction_flow/account_selector_dialog.dart';
import 'package:expense_tracker/pages/common/custom_text_field.dart';
import 'package:expense_tracker/pages/new_edit_transaction_flow/category_selector_dialog.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewEditTransactionPageScreenArguments {
  final bool? incomePreset;
  final Transaction? transaction;
  final Account? account;

  NewEditTransactionPageScreenArguments(
      {this.incomePreset, this.transaction, this.account});
}

class NewEditTransactionPage extends ConsumerStatefulWidget {
  static const routeName = '/newEditTransactionPage';

  final bool? incomePreset;
  final Transaction? initialTransactionSettings;
  final Account? initialAccountSettings;

  const NewEditTransactionPage({
    super.key,
    this.incomePreset,
    this.initialTransactionSettings,
    this.initialAccountSettings,
  });

  @override
  ConsumerState<NewEditTransactionPage> createState() =>
      _NewEditTransactionPageState();
}

class _NewEditTransactionPageState extends ConsumerState<NewEditTransactionPage>
    with SingleTickerProviderStateMixin {
  late final AppLocalizations appLocalizations;

  bool get editMode {
    return widget.initialTransactionSettings != null;
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

  Category? selectedCategory;
  Account? selectedAccount;
  DateTime selectedDate = DateTime.now();
  bool includeInReportCheckboxValue = true;

  final dateFormatter = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();

    _transactionTypeTabController = TabController(length: 2, vsync: this);

    if (editMode) {
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
            .read(categoryProvider.notifier)
            .getCategoryFromId(initialTransaction.categoryId!);

        if (selectedCategory != null) {
          categoryInput.text = selectedCategory!.name;
        }
      }

      if (initialTransaction.accountId != null) {
        selectedAccount = ref
            .read(accountProvider.notifier)
            .getAccountFromId(initialTransaction.accountId!);

        if (selectedAccount != null) {
          accountInput.text = selectedAccount!.name;
        }
      }

      includeInReportCheckboxValue = initialTransaction.includeInReports;
    } else {
      titleInputFocusNode.requestFocus();
      dateInput.text = dateFormatter.format(selectedDate).toString();

      final incomePreset = widget.incomePreset;

      _transactionTypeTabController.index =
          incomePreset == null || incomePreset == true ? 0 : 1;

      if (widget.initialAccountSettings != null) {
        selectedAccount = ref
            .read(accountProvider.notifier)
            .getAccountFromId(widget.initialAccountSettings!.id!);

        if (selectedAccount != null) {
          accountInput.text = selectedAccount!.name;
        }
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    appLocalizations = AppLocalizations.of(context)!;
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

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          editMode
              ? appLocalizations.editTransaction
              : appLocalizations.newTransaction,
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 17),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: _buildForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Column(
          children: [
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
            const SizedBox(
              height: 14,
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
            const SizedBox(
              height: 8,
            ),
            _buildSegmentedBar(),
            const SizedBox(
              height: 14,
            ),
            CustomTextField(
              controller: dateInput,
              label: appLocalizations.date,
              hintText: appLocalizations.selectDate,
              icon: Icons.calendar_month_rounded,
              readOnly: true,
              onTap: () => _selectDate(),
            ),
            const SizedBox(
              height: 14,
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
            const SizedBox(
              height: 14,
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
            const SizedBox(
              height: 14,
            ),
            Row(
              children: [
                Text(
                  appLocalizations.includeInReports,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: CustomColors.lightBlack,
                  ),
                ),
                const Spacer(),
                Checkbox(
                  value: includeInReportCheckboxValue,
                  activeColor: CustomColors.blue,
                  onChanged: (_) {
                    includeInReportCheckboxValue =
                        !includeInReportCheckboxValue;

                    setState(() {});
                  },
                )
              ],
            ),
            const Spacer(),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              datePickerTheme: DatePickerThemeData(
                headerBackgroundColor: CustomColors.blue,
                headerForegroundColor: Colors.white,
                backgroundColor: Colors.white,
                todayBackgroundColor: WidgetStateProperty.resolveWith(
                  (states) {
                    if (states.contains(WidgetState.selected)) {
                      return CustomColors.blue; // OK
                    }

                    return Colors.transparent; //OK
                  },
                ),
                dayBackgroundColor: WidgetStateProperty.resolveWith(
                  (states) {
                    if (states.contains(WidgetState.selected)) {
                      return CustomColors.blue; // OK
                    }

                    return Colors.transparent; //OK
                  },
                ),
              ),
            ),
            child: child!,
          );
        },
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));

    if (picked != null && picked != selectedDate) {
      setState(() {
        dateInput.text = dateFormatter.format(picked).toString();

        selectedDate = picked;
      });
    }
  }

  Widget _buildSaveButton() {
    return CustomElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          if (editMode) {
            _editTransaction(
                income:
                    _transactionTypeTabController.index == 0 ? true : false);
          } else {
            _saveNewTransaction(
                isIncome:
                    _transactionTypeTabController.index == 0 ? true : false);
          }
        }
      },
      text: editMode ? appLocalizations.applyChanges : appLocalizations.save,
    );
  }

  _saveNewTransaction({required bool isIncome}) {
    final transactionValue = isIncome
        ? double.parse(valueInput.text)
        : -double.parse(valueInput.text);

    ref
        .read(transactionProvider.notifier)
        .addNewTransaction(
            title: titleInput.text,
            description: descriptionInput.text,
            amount: transactionValue,
            date: selectedDate,
            category: selectedCategory,
            account: selectedAccount,
            includeInReports: includeInReportCheckboxValue,
            isHidden: false)
        .then((value) async {
      final InAppReview inAppReview = InAppReview.instance;

      if (await inAppReview.isAvailable()) {
        inAppReview.requestReview();
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  _editTransaction({required bool income}) {
    if (context.mounted) {
      final valueFromTextInput = double.parse(valueInput.text);

      final transactionValue = income
          ? valueFromTextInput.abs()
          : valueFromTextInput > 0
              ? -valueFromTextInput
              : valueFromTextInput;

      ref
          .read(transactionProvider.notifier)
          .updateTransaction(
              transactionToEdit: widget.initialTransactionSettings!,
              title: titleInput.text,
              description: descriptionInput.text,
              amount: transactionValue,
              date: selectedDate,
              category: selectedCategory,
              account: selectedAccount,
              includeInReports: includeInReportCheckboxValue,
              isHidden: false)
          .then((value) => {if (mounted) Navigator.of(context).pop()});
    }
  }

  _buildSegmentedBar() {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: CustomColors.lightBlue,
        borderRadius: BorderRadius.circular(54 / 2),
      ),
      child: TabBar(
        controller: _transactionTypeTabController,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerHeight: 0,
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
        tabs: [
          Tab(
            text: AppLocalizations.of(context)!.income,
          ),
          Tab(
            text: AppLocalizations.of(context)!.expense,
          )
        ],
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            return states.contains(WidgetState.focused)
                ? null
                : Colors.transparent;
          },
        ),
        unselectedLabelColor: CustomColors.clearGreyText,
        labelColor: Colors.white,
        indicator: BoxDecoration(
            color: CustomColors.blue,
            borderRadius: BorderRadius.circular(54 / 2)),
      ),
    );
  }
}
