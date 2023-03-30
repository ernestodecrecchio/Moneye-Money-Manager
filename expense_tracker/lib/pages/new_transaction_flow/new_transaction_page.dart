import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/notifiers/transaction_provider.dart';
import 'package:expense_tracker/pages/new_transaction_flow/account_selector_dialog.dart';
import 'package:expense_tracker/pages/common/custom_text_field.dart';
import 'package:expense_tracker/pages/new_transaction_flow/category_selector_dialog.dart';
import 'package:expense_tracker/style.dart';
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
        minimum: const EdgeInsets.symmetric(horizontal: 17),
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
              hintText: 'Inserisci il valore della transazione',
              textInputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))
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
                final Category? newSelectedCategory =
                    await showCategoryBottomSheet(context, selectedCategory);

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
                final Account? newSelectedAccount =
                    await showAccountBottomSheet(context, selectedAccount);

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
    return Container(
      clipBehavior: Clip.antiAlias,
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: CustomColors.darkBlue,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _saveNewTransaction(income: true);
                }
              },
              child: const Text(
                'Entrata',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Container(
            width: 2,
            margin: const EdgeInsets.symmetric(vertical: 12),
            height: double.infinity,
            color: Colors.white,
          ),
          Expanded(
            child: TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _saveNewTransaction(income: false);
                }
              },
              child: const Text(
                'Uscita',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _saveNewTransaction({required bool income}) {
    final transactionValue =
        income ? double.parse(valueInput.text) : -double.parse(valueInput.text);

    print(transactionValue);

    Provider.of<TransactionProvider>(context, listen: false)
        .addNewTransaction(
            title: titleInput.text,
            value: transactionValue,
            date: selectedDate,
            category: selectedCategory,
            account: selectedAccount)
        .then((value) => Navigator.of(context).pop());
  }
}
