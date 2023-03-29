import 'package:expense_tracker/Common/Icon%20Picker/icon_picker_modal_view.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/notifiers/account_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewAccountPage extends StatefulWidget {
  static const routeName = '/newAccountPage';

  const NewAccountPage({Key? key}) : super(key: key);

  @override
  State<NewAccountPage> createState() => _NewAccountPageState();
}

class _NewAccountPageState extends State<NewAccountPage> {
  TextEditingController titleInput = TextEditingController();
  TextEditingController descriptionInput = TextEditingController();

  String? title;
  String? description;
  Color selectedColor = Colors.amber;

  IconData? selectedIcon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuovo conto')),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            TextFormField(
              controller: titleInput,
              decoration: const InputDecoration(hintText: 'Nome'),
              onChanged: (newValue) {
                title = newValue;
              },
            ),
            TextFormField(
              controller: descriptionInput,
              decoration: const InputDecoration(hintText: 'Descrizione'),
              onChanged: (newValue) {
                description = newValue;
              },
            ),
            Row(
              children: [
                const Text('Colore'),
                Container(
                  height: 40,
                  width: 40,
                  color: selectedColor,
                ),
                ElevatedButton(
                  onPressed: () {
                    _showColorPicker();
                  },
                  child: const Text('Seleziona colore'),
                )
              ],
            ),
            Row(
              children: [
                const Text('Icona'),
                Icon(selectedIcon),
                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: ((context) {
                        return IconPickerModalView();
                      }),
                    ).then((value) {
                      selectedIcon = value['icon'];
                      setState(() {});
                    });
                  },
                  child: const Text('Seleziona icona'),
                )
              ],
            ),
            const Spacer(),
            ElevatedButton(
                onPressed: _saveNewAccount, child: const Text('Salva'))
          ],
        ),
      ),
    );
  }

  _showColorPicker() {
    // create some values
    Color pickerColor = const Color(0xff443a49);

    // ValueChanged<Color> callback
    void changeColor(Color color) {
      setState(() => pickerColor = color);
    }

    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return AlertDialog(
    //       title: const Text('Pick a color!'),
    //       content: SingleChildScrollView(
    //         child: BlockPicker(
    //           pickerColor: selectedColor,
    //           onColorChanged: changeColor,
    //         ),
    //       ),
    //       actions: <Widget>[
    //         ElevatedButton(
    //           child: const Text('Got it'),
    //           onPressed: () {
    //             setState(() => selectedColor = pickerColor);
    //             Navigator.of(context).pop();
    //           },
    //         ),
    //       ],
    //     );
    //   },
    // );
  }

  _saveNewAccount() {
    if (title != null) {
      final newAccount = Account(
        name: title!,
        colorValue: selectedColor.value,
        iconData: selectedIcon,
      );
      Provider.of<AccountProvider>(context, listen: false)
          .addNewAccount(newAccount: newAccount)
          .then((value) => Navigator.of(context).pop());
    }
  }
}
