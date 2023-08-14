import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/notifiers/account_provider.dart';
import 'package:expense_tracker/notifiers/category_provider.dart';
import 'package:expense_tracker/notifiers/transaction_provider.dart';
import 'package:expense_tracker/pages/new_edit_transaction_flow/account_selector_dialog.dart';
import 'package:expense_tracker/pages/common/custom_text_field.dart';
import 'package:expense_tracker/pages/new_edit_transaction_flow/category_selector_dialog.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewEditTransactionPageScreenArguments {
  final Transaction? transaction;
  final Account? account;

  NewEditTransactionPageScreenArguments({this.transaction, this.account});
}

class NewEditTransactionPage extends StatefulWidget {
  static const routeName = '/newEditTransactionPage';

  final Transaction? initialTransactionSettings;
  final Account? initialAccountSettings;

  const NewEditTransactionPage({
    Key? key,
    this.initialTransactionSettings,
    this.initialAccountSettings,
  }) : super(key: key);

  @override
  State<NewEditTransactionPage> createState() => _NewEditTransactionPageState();
}

class _NewEditTransactionPageState extends State<NewEditTransactionPage>
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

  final dateFormatter = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();

    _transactionTypeTabController = TabController(length: 2, vsync: this);

    if (editMode) {
      titleInput.text = widget.initialTransactionSettings!.title;
      descriptionInput.text =
          widget.initialTransactionSettings!.description ?? '';
      valueInput.text =
          widget.initialTransactionSettings!.value.abs().toString();
      dateInput.text = dateFormatter
          .format(widget.initialTransactionSettings!.date)
          .toString();
      selectedDate = widget.initialTransactionSettings!.date;

      _transactionTypeTabController.index =
          widget.initialTransactionSettings!.value >= 0 ? 0 : 1;

      if (widget.initialTransactionSettings!.categoryId != null) {
        selectedCategory = Provider.of<CategoryProvider>(context, listen: false)
            .getCategoryFromId(widget.initialTransactionSettings!.categoryId!);

        if (selectedCategory != null) {
          categoryInput.text = selectedCategory!.name;
        }
      }

      if (widget.initialTransactionSettings!.accountId != null) {
        selectedAccount = Provider.of<AccountProvider>(context, listen: false)
            .getAccountFromId(widget.initialTransactionSettings!.accountId!);

        if (selectedAccount != null) {
          accountInput.text = selectedAccount!.name;
        }
      }
    } else {
      titleInputFocusNode.requestFocus();
      dateInput.text = dateFormatter.format(selectedDate).toString();

      if (widget.initialAccountSettings != null) {
        selectedAccount = Provider.of<AccountProvider>(context, listen: false)
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
        title: Text(editMode
            ? appLocalizations.editTransaction
            : appLocalizations.newTransaction),
        backgroundColor: CustomColors.blue,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
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
            // const SizedBox(
            //   height: 14,
            // ),
            // CustomTextField(
            //   controller: descriptionInput,
            //   label: 'Descrizione',
            //   hintText: 'Inserisci una descrizione',
            //   maxLines: null,
            // ),

            const SizedBox(
              height: 14,
            ),

            CustomTextField(
              controller: valueInput,
              label: '${appLocalizations.value}*',
              hintText: appLocalizations.insertTheValueOfTheTransaction,
              textInputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))
              ],
              keyboardType: const TextInputType.numberWithOptions(
                  signed: true, decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return appLocalizations.valueIsMandatory;
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
              onTap: () => _selectDate(context),
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
            const Spacer(),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: CustomColors.blue,
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
    // return Container(
    //   clipBehavior: Clip.antiAlias,
    //   height: 50,
    //   width: double.infinity,
    //   margin: const EdgeInsets.only(top: 10),
    //   decoration: BoxDecoration(
    //     color: CustomColors.darkBlue,
    //     borderRadius: BorderRadius.circular(25),
    //   ),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       Expanded(
    //         child: TextButton(
    //           onPressed: () {
    //             if (_formKey.currentState!.validate()) {
    //               if (editMode) {
    //                 _editTransaction(income: true);
    //               } else {
    //                 _saveNewTransaction(income: true);
    //               }
    //             }
    //           },
    //           child: Text(
    //             appLocalizations.income,
    //             style: const TextStyle(
    //               color: Colors.white,
    //               fontSize: 16,
    //               fontWeight: FontWeight.w600,
    //             ),
    //           ),
    //         ),
    //       ),
    //       Container(
    //         width: 2,
    //         margin: const EdgeInsets.symmetric(vertical: 12),
    //         height: double.infinity,
    //         color: Colors.white,
    //       ),
    //       Expanded(
    //         child: TextButton(
    //           onPressed: () {
    //             if (_formKey.currentState!.validate()) {
    //               if (editMode) {
    //                 _editTransaction(income: false);
    //               } else {
    //                 _saveNewTransaction(income: false);
    //               }
    //             }
    //           },
    //           child: Text(
    //             appLocalizations.outcome,
    //             style: const TextStyle(
    //               color: Colors.white,
    //               fontSize: 16,
    //               fontWeight: FontWeight.w600,
    //             ),
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );

    return Container(
      height: 50,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            if (editMode) {
              _editTransaction(
                  income:
                      _transactionTypeTabController.index == 0 ? true : false);
            } else {
              _saveNewTransaction(
                  income:
                      _transactionTypeTabController.index == 0 ? true : false);
            }
          }
        },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: CustomColors.darkBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          editMode ? appLocalizations.applyChanges : appLocalizations.save,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  _saveNewTransaction({required bool income}) {
    final transactionValue =
        income ? double.parse(valueInput.text) : -double.parse(valueInput.text);

    Provider.of<TransactionProvider>(context, listen: false)
        .addNewTransaction(
            title: titleInput.text,
            description: descriptionInput.text,
            value: transactionValue,
            date: selectedDate,
            category: selectedCategory,
            account: selectedAccount)
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
    final valueFromTextInput = double.parse(valueInput.text);

    final transactionValue = income
        ? valueFromTextInput.abs()
        : valueFromTextInput > 0
            ? -valueFromTextInput
            : valueFromTextInput;

    Provider.of<TransactionProvider>(context, listen: false)
        .updateTransaction(
          transactionToEdit: widget.initialTransactionSettings!,
          title: titleInput.text,
          description: descriptionInput.text,
          value: transactionValue,
          date: selectedDate,
          category: selectedCategory,
          account: selectedAccount,
        )
        .then((value) => Navigator.of(context).pop());
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
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
        tabs: [
          Tab(
            text: AppLocalizations.of(context)!.income,
          ),
          Tab(
            text: AppLocalizations.of(context)!.outcome,
          )
        ],
        unselectedLabelColor: CustomColors.clearGreyText,
        labelColor: Colors.white,
        indicator: BoxDecoration(
            color: CustomColors.blue,
            borderRadius: BorderRadius.circular(54 / 2)),
      ),
    );
  }
}
