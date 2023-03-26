import 'dart:io';

import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/notifiers/transaction_provider.dart';
import 'package:expense_tracker/pages/account_selector_dialog.dart';
import 'package:expense_tracker/pages/common/custom_text_field.dart';
import 'package:expense_tracker/pages/new_transaction_flow/category_selector_dialog.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewTransactionPage extends StatefulWidget {
  static const routeName = '/newTransactionPage';

  const NewTransactionPage({Key? key}) : super(key: key);

  @override
  State<NewTransactionPage> createState() => _NewTransactionPageState();
}

class _NewTransactionPageState extends State<NewTransactionPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController titleInput = TextEditingController();
  TextEditingController descriptionInput = TextEditingController();
  TextEditingController valueInput = TextEditingController();
  TextEditingController dateInput = TextEditingController();
  TextEditingController categoryInput = TextEditingController();
  TextEditingController accountInput = TextEditingController();

  String? title;
  double? value;
  Category? selectedCategory;
  Account? selectedAccount;
  DateTime selectedDate = DateTime.now();

  final dateFormatter = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();

    dateInput.text = dateFormatter.format(selectedDate).toString();
  }

  @override
  void dispose() {
    titleInput.dispose();
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
        title: const Text('Nuova transazione'),
        backgroundColor: CustomColors.blue,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(
          horizontal: 17,
        ),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: _buildForm(),
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
              label: 'Titolo*',
              hintText: 'Inserisci il titolo della transazione',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Il titolo è obbligatorio';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 14,
            ),
            CustomTextField(
              controller: descriptionInput,
              label: 'Descrizione',
              hintText: 'Inserisci una descrizione',
              maxLines: null,
            ),
            const SizedBox(
              height: 14,
            ),
            CustomTextField(
              controller: valueInput,
              label: 'Valore*',
              hintText: 'Inserisci il valore',
              textInputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'(^[-,+]?\d*\.?\d*)'))
              ],
              keyboardType: const TextInputType.numberWithOptions(
                  signed: true, decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Il valore è obbligatorio';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 14,
            ),
            CustomTextField(
              controller: dateInput,
              label: 'Data',
              hintText: 'Seleziona la data',
              icon: Icons.calendar_month_rounded,
              readOnly: true,
              onTap: () => _selectDate(context),
            ),
            const SizedBox(
              height: 14,
            ),
            CustomTextField(
              controller: categoryInput,
              label: 'Categoria',
              hintText: 'Seleziona la categoria',
              icon: Icons.chevron_right_rounded,
              readOnly: true,
              onTap: () async {
                final Category? newSelectedCategory = await showDialog(
                  context: context,
                  builder: ((context) {
                    return Dialog(
                      child: CategorySelectorDialog(
                          currentSelection: selectedCategory),
                    );
                  }),
                );

                if (newSelectedCategory != null) {
                  categoryInput.text = newSelectedCategory.name;
                  setState(() => selectedCategory = newSelectedCategory);
                }
              },
            ),
            const SizedBox(
              height: 14,
            ),
            CustomTextField(
              controller: accountInput,
              label: 'Conto',
              hintText: 'Seleziona il conto',
              icon: Icons.chevron_right_rounded,
              readOnly: true,
              onTap: () async {
                final Account? newSelectedAccount = await showDialog(
                  context: context,
                  builder: ((context) {
                    return Dialog(
                      child: AccountSelectorDialog(
                          currentSelection: selectedAccount),
                    );
                  }),
                );

                if (newSelectedAccount != null) {
                  accountInput.text = newSelectedAccount.name;
                  setState(() => selectedAccount = newSelectedAccount);
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
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _saveNewTransaction();
          }
        },
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(CustomColors.darkBlue),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: const BorderSide(
                style: BorderStyle.none,
                width: 0,
              ),
            ),
          ),
        ),
        child: const Text(
          'Salva',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  _saveNewTransaction() {
    Provider.of<TransactionProvider>(context, listen: false)
        .addNewTransaction(
            title: titleInput.text,
            value: double.parse(valueInput.text),
            date: selectedDate,
            category: selectedCategory,
            account: selectedAccount)
        .then((value) => Navigator.of(context).pop());
  }
}
