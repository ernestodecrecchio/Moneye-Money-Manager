import 'package:expense_tracker/pages/new_category_page.dart';
import 'package:expense_tracker/pages/tab_bar_page.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const TabBarPage(),
        '/newCategory': (context) => const NewCategoryPage(),
      },
    );
  }
}
