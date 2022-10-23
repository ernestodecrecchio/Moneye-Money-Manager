import 'package:expense_tracker/models/transaction.dart' as trans;
import 'package:expense_tracker/models/transaction.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabasePopulate {
  static addData(Database db) async {
    final stipendio1 = trans.Transaction(
      title: 'stipendio',
      value: 1555,
      date: DateTime(2022, 1, 27),
      accountId: 2,
    );
    final stipendio2 = trans.Transaction(
        title: 'stipendio',
        value: 1545,
        date: DateTime(2022, 2, 26),
        accountId: 1);
    final stipendio3 = trans.Transaction(
        title: 'stipendio',
        value: 1450,
        date: DateTime(2022, 3, 27),
        accountId: 1);
    final stipendio4 = trans.Transaction(
        title: 'stipendio',
        value: 1535,
        date: DateTime(2022, 4, 27),
        accountId: 1);
    final stipendio5 = trans.Transaction(
        title: 'stipendio',
        value: 1600,
        date: DateTime(2022, 5, 26),
        accountId: 1);
    final stipendio6 = trans.Transaction(
        title: 'stipendio',
        value: 1500,
        date: DateTime(2022, 6, 27),
        accountId: 1);
    final stipendio7 = trans.Transaction(
        title: 'stipendio',
        value: 1512,
        date: DateTime(2022, 7, 26),
        accountId: 1);
    final stipendio8 = trans.Transaction(
        title: 'stipendio',
        value: 1527,
        date: DateTime(2022, 8, 26),
        accountId: 1);
    final stipendio9 = trans.Transaction(
        title: 'stipendio',
        value: 1558,
        date: DateTime(2022, 9, 27),
        accountId: 1);
    final stipendio10 = trans.Transaction(
        title: 'stipendio',
        value: 1558,
        date: DateTime(2022, 10, 27),
        accountId: 1);

    await db.insert(transactionsTable, stipendio1.toJson());
    await db.insert(transactionsTable, stipendio2.toJson());
    await db.insert(transactionsTable, stipendio3.toJson());
    await db.insert(transactionsTable, stipendio4.toJson());
    await db.insert(transactionsTable, stipendio5.toJson());
    await db.insert(transactionsTable, stipendio6.toJson());
    await db.insert(transactionsTable, stipendio7.toJson());
    await db.insert(transactionsTable, stipendio8.toJson());
    await db.insert(transactionsTable, stipendio9.toJson());
    await db.insert(transactionsTable, stipendio10.toJson());

    final netflix1 = trans.Transaction(
      title: 'Netflix',
      value: -4.50,
      date: DateTime(2022, 1, 21),
      accountId: 2,
      categoryId: 4,
    );
    final netflix2 = trans.Transaction(
      title: 'Netflix',
      value: -4.50,
      date: DateTime(2022, 2, 20),
      accountId: 2,
      categoryId: 4,
    );
    final netflix3 = trans.Transaction(
      title: 'Netflix',
      value: -4.50,
      date: DateTime(2022, 3, 20),
      accountId: 2,
      categoryId: 4,
    );
    final netflix4 = trans.Transaction(
      title: 'Netflix',
      value: -4.50,
      date: DateTime(2022, 4, 20),
      accountId: 2,
      categoryId: 4,
    );
    final netflix5 = trans.Transaction(
      title: 'Netflix',
      value: -4.50,
      date: DateTime(2022, 5, 20),
      accountId: 2,
      categoryId: 4,
    );
    final netflix6 = trans.Transaction(
      title: 'Netflix',
      value: -4.50,
      date: DateTime(2022, 6, 21),
      accountId: 2,
      categoryId: 4,
    );
    final netflix7 = trans.Transaction(
      title: 'Netflix',
      value: -4.50,
      date: DateTime(2022, 7, 22),
      accountId: 2,
      categoryId: 4,
    );
    final netflix8 = trans.Transaction(
      title: 'Netflix',
      value: -4.50,
      date: DateTime(2022, 8, 22),
      accountId: 2,
      categoryId: 4,
    );
    final netflix9 = trans.Transaction(
      title: 'Netflix',
      value: -4.50,
      date: DateTime(2022, 9, 21),
      accountId: 2,
      categoryId: 4,
    );

    await db.insert(transactionsTable, netflix1.toJson());
    await db.insert(transactionsTable, netflix2.toJson());
    await db.insert(transactionsTable, netflix3.toJson());
    await db.insert(transactionsTable, netflix4.toJson());
    await db.insert(transactionsTable, netflix5.toJson());
    await db.insert(transactionsTable, netflix6.toJson());
    await db.insert(transactionsTable, netflix7.toJson());
    await db.insert(transactionsTable, netflix8.toJson());
    await db.insert(transactionsTable, netflix9.toJson());

    final auto1 = trans.Transaction(
        title: 'Lavaggio auto',
        value: -12,
        date: DateTime(2022, 1, 7),
        accountId: 1,
        categoryId: 1);
    final auto2 = trans.Transaction(
        title: 'Lavaggio auto',
        value: -12,
        date: DateTime(2022, 3, 14),
        accountId: 1,
        categoryId: 1);
    final auto3 = trans.Transaction(
        title: 'Lavaggio auto',
        value: -12,
        date: DateTime(2022, 5, 2),
        accountId: 1,
        categoryId: 1);
    final auto4 = trans.Transaction(
        title: 'Lavaggio auto',
        value: -12,
        date: DateTime(2022, 7, 5),
        accountId: 1,
        categoryId: 1);
    final auto5 = trans.Transaction(
        title: 'Lavaggio auto',
        value: -12,
        date: DateTime(2022, 10, 24),
        accountId: 1,
        categoryId: 1);

    await db.insert(transactionsTable, auto1.toJson());
    await db.insert(transactionsTable, auto2.toJson());
    await db.insert(transactionsTable, auto3.toJson());
    await db.insert(transactionsTable, auto4.toJson());
    await db.insert(transactionsTable, auto5.toJson());

    final pub1 = trans.Transaction(
        title: 'Panino pub',
        value: -12,
        date: DateTime(2022, 10, 3),
        accountId: 1);
    final pub2 = trans.Transaction(
        title: 'Panino pub',
        value: -12.5,
        date: DateTime(2022, 10, 24),
        accountId: 1);
    final pub3 = trans.Transaction(
        title: 'Panino pub',
        value: -17,
        date: DateTime(2022, 2, 4),
        accountId: 1);
    final pub4 = trans.Transaction(
        title: 'Panino pub',
        value: -18.9,
        date: DateTime(2022, 2, 12),
        accountId: 1);
    final pub5 = trans.Transaction(
        title: 'Panino pub',
        value: -21,
        date: DateTime(2022, 3, 6),
        accountId: 1);
    final pub6 = trans.Transaction(
        title: 'Panino pub',
        value: -12,
        date: DateTime(2022, 3, 24),
        accountId: 1);
    final pub7 = trans.Transaction(
        title: 'Panino pub',
        value: -8,
        date: DateTime(2022, 3, 17),
        accountId: 1);
    final pub8 = trans.Transaction(
        title: 'Panino pub',
        value: -23,
        date: DateTime(2022, 4, 23),
        accountId: 1);
    final pub9 = trans.Transaction(
        title: 'Panino pub',
        value: -12,
        date: DateTime(2022, 5, 6),
        accountId: 1);
    final pub10 = trans.Transaction(
        title: 'Panino pub',
        value: -10,
        date: DateTime(2022, 5, 15),
        accountId: 1);
    final pub11 = trans.Transaction(
        title: 'Panino pub',
        value: -6,
        date: DateTime(2022, 6, 7),
        accountId: 1);
    final pub12 = trans.Transaction(
        title: 'Panino pub',
        value: -9.9,
        date: DateTime(2022, 7, 9),
        accountId: 1);
    final pub13 = trans.Transaction(
        title: 'Panino pub',
        value: -17,
        date: DateTime(2022, 7, 24),
        accountId: 1);
    final pub14 = trans.Transaction(
        title: 'Panino pub',
        value: -12.5,
        date: DateTime(2022, 7, 28),
        accountId: 1);
    final pub15 = trans.Transaction(
        title: 'Panino pub',
        value: -13.4,
        date: DateTime(2022, 8, 10),
        accountId: 1);
    final pub16 = trans.Transaction(
        title: 'Panino pub',
        value: -10.4,
        date: DateTime(2022, 8, 29),
        accountId: 1);
    final pub17 = trans.Transaction(
        title: 'Panino pub',
        value: -12,
        date: DateTime(2022, 8, 24),
        accountId: 1);
    final pub18 = trans.Transaction(
        title: 'Panino pub',
        value: -11.25,
        date: DateTime(2022, 9, 25),
        accountId: 1);

    await db.insert(transactionsTable, pub1.toJson());
    await db.insert(transactionsTable, pub2.toJson());
    await db.insert(transactionsTable, pub3.toJson());
    await db.insert(transactionsTable, pub4.toJson());
    await db.insert(transactionsTable, pub5.toJson());
    await db.insert(transactionsTable, pub6.toJson());
    await db.insert(transactionsTable, pub7.toJson());
    await db.insert(transactionsTable, pub8.toJson());
    await db.insert(transactionsTable, pub9.toJson());
    await db.insert(transactionsTable, pub10.toJson());
    await db.insert(transactionsTable, pub11.toJson());
    await db.insert(transactionsTable, pub12.toJson());
    await db.insert(transactionsTable, pub13.toJson());
    await db.insert(transactionsTable, pub14.toJson());
    await db.insert(transactionsTable, pub15.toJson());
    await db.insert(transactionsTable, pub16.toJson());
    await db.insert(transactionsTable, pub17.toJson());
    await db.insert(transactionsTable, pub18.toJson());

    final componentiPC = trans.Transaction(
        title: 'componentiPC',
        value: -1750,
        date: DateTime(2022, 3, 11),
        accountId: 1);
    await db.insert(transactionsTable, componentiPC.toJson());

    final passaporto = trans.Transaction(
        title: 'passaport',
        value: -78.90,
        date: DateTime(2022, 10, 11),
        accountId: 1);

    await db.insert(transactionsTable, passaporto.toJson());

    final traversine1 = trans.Transaction(
        title: 'traversine',
        value: -12,
        date: DateTime(2022, 9, 11),
        accountId: 1);
    final traversine2 = trans.Transaction(
        title: 'traversine',
        value: -1200,
        date: DateTime(2022, 6, 18),
        accountId: 1,
        categoryId: 1);

    await db.insert(transactionsTable, traversine1.toJson());
    await db.insert(transactionsTable, traversine2.toJson());

    final ciboCane1 = trans.Transaction(
        title: 'Cibo cane',
        value: -64.5,
        date: DateTime(2022, 3, 10),
        accountId: 1);
    final ciboCane2 = trans.Transaction(
        title: 'Cibo cane',
        value: -70.99,
        date: DateTime(2022, 5, 21),
        accountId: 1);
    final ciboCane3 = trans.Transaction(
        title: 'Cibo cane',
        value: -64.5,
        date: DateTime(2022, 7, 24),
        accountId: 1);
    final ciboCane4 = trans.Transaction(
        title: 'Cibo cane',
        value: -64.5,
        date: DateTime(2022, 9, 15),
        accountId: 1);

    await db.insert(transactionsTable, ciboCane1.toJson());
    await db.insert(transactionsTable, ciboCane2.toJson());
    await db.insert(transactionsTable, ciboCane3.toJson());
    await db.insert(transactionsTable, ciboCane4.toJson());

    final benzina1 = trans.Transaction(
        title: 'Benzina',
        value: -20,
        date: DateTime(2022, 10, 3),
        accountId: 1);
    final benzina2 = trans.Transaction(
        title: 'Benzina',
        value: -20,
        date: DateTime(2022, 2, 21),
        accountId: 1);
    final benzina3 = trans.Transaction(
        title: 'Benzina',
        value: -20,
        date: DateTime(2022, 3, 17),
        accountId: 1);
    final benzina4 = trans.Transaction(
        title: 'Benzina', value: -20, date: DateTime(2022, 4, 1), accountId: 1);
    final benzina5 = trans.Transaction(
        title: 'Benzina',
        value: -20,
        date: DateTime(2022, 5, 15),
        accountId: 3);
    final benzina6 = trans.Transaction(
        title: 'Benzina',
        value: -20,
        date: DateTime(2022, 6, 21),
        accountId: 1);
    final benzina7 = trans.Transaction(
        title: 'Benzina',
        value: -50,
        date: DateTime(2022, 7, 18),
        accountId: 1);

    await db.insert(transactionsTable, benzina1.toJson());
    await db.insert(transactionsTable, benzina2.toJson());
    await db.insert(transactionsTable, benzina3.toJson());
    await db.insert(transactionsTable, benzina4.toJson());
    await db.insert(transactionsTable, benzina5.toJson());
    await db.insert(transactionsTable, benzina6.toJson());
    await db.insert(transactionsTable, benzina7.toJson());

    final ricaricaTIM1 = trans.Transaction(
        title: 'Ricarica telefonica',
        value: -10,
        date: DateTime(2022, 10, 3),
        accountId: 1);
    final ricaricaTIM2 = trans.Transaction(
        title: 'Ricarica telefonica',
        value: -10,
        date: DateTime(2022, 2, 3),
        accountId: 1);
    final ricaricaTIM3 = trans.Transaction(
        title: 'Ricarica telefonica',
        value: -10,
        date: DateTime(2022, 3, 3),
        accountId: 1);
    final ricaricaTIM4 = trans.Transaction(
        title: 'Ricarica telefonica',
        value: -10,
        date: DateTime(2022, 4, 3),
        accountId: 1);
    final ricaricaTIM5 = trans.Transaction(
        title: 'Ricarica telefonica',
        value: -10,
        date: DateTime(2022, 5, 3),
        accountId: 1);
    final ricaricaTIM6 = trans.Transaction(
        title: 'Ricarica telefonica',
        value: -10,
        date: DateTime(2022, 6, 3),
        accountId: 1);
    final ricaricaTIM7 = trans.Transaction(
        title: 'Ricarica telefonica',
        value: -10,
        date: DateTime(2022, 7, 3),
        accountId: 1);
    final ricaricaTIM8 = trans.Transaction(
        title: 'Ricarica telefonica',
        value: -10,
        date: DateTime(2022, 8, 3),
        accountId: 1);
    final ricaricaTIM9 = trans.Transaction(
        title: 'Ricarica telefonica',
        value: -10,
        date: DateTime(2022, 9, 3),
        accountId: 1);

    await db.insert(transactionsTable, ricaricaTIM1.toJson());
    await db.insert(transactionsTable, ricaricaTIM2.toJson());
    await db.insert(transactionsTable, ricaricaTIM3.toJson());
    await db.insert(transactionsTable, ricaricaTIM4.toJson());
    await db.insert(transactionsTable, ricaricaTIM5.toJson());
    await db.insert(transactionsTable, ricaricaTIM6.toJson());
    await db.insert(transactionsTable, ricaricaTIM7.toJson());
    await db.insert(transactionsTable, ricaricaTIM8.toJson());
    await db.insert(transactionsTable, ricaricaTIM9.toJson());

    final bollettaInternet1 = trans.Transaction(
        title: 'Bolletta Internet',
        value: -43,
        date: DateTime(2022, 10, 1),
        accountId: 4,
        categoryId: 2);
    final bollettaInternet2 = trans.Transaction(
        title: 'Bolletta Internet',
        value: -44,
        date: DateTime(2022, 2, 2),
        accountId: 4,
        categoryId: 2);
    final bollettaInternet3 = trans.Transaction(
        title: 'Bolletta Internet',
        value: -26,
        date: DateTime(2022, 3, 3),
        accountId: 4,
        categoryId: 2);
    final bollettaInternet4 = trans.Transaction(
        title: 'Bolletta Internet',
        value: -32,
        date: DateTime(2022, 4, 4),
        accountId: 4,
        categoryId: 2);
    final bollettaInternet5 = trans.Transaction(
        title: 'Bolletta Internet',
        value: -44,
        date: DateTime(2022, 5, 5),
        accountId: 4,
        categoryId: 2);
    final bollettaInternet6 = trans.Transaction(
        title: 'Bolletta Internet',
        value: -44,
        date: DateTime(2022, 6, 6),
        accountId: 4,
        categoryId: 2);
    final bollettaInternet7 = trans.Transaction(
        title: 'Bolletta Internet',
        value: -37,
        date: DateTime(2022, 7, 7),
        accountId: 4,
        categoryId: 2);
    final bollettaInternet8 = trans.Transaction(
        title: 'Bolletta Internet',
        value: -37,
        date: DateTime(2022, 8, 7),
        accountId: 4,
        categoryId: 2);
    final bollettaInternet9 = trans.Transaction(
        title: 'Bolletta Internet',
        value: -37,
        date: DateTime(2022, 9, 7),
        accountId: 4,
        categoryId: 2);

    await db.insert(transactionsTable, bollettaInternet1.toJson());
    await db.insert(transactionsTable, bollettaInternet2.toJson());
    await db.insert(transactionsTable, bollettaInternet3.toJson());
    await db.insert(transactionsTable, bollettaInternet4.toJson());
    await db.insert(transactionsTable, bollettaInternet5.toJson());
    await db.insert(transactionsTable, bollettaInternet6.toJson());
    await db.insert(transactionsTable, bollettaInternet7.toJson());
    await db.insert(transactionsTable, bollettaInternet8.toJson());
    await db.insert(transactionsTable, bollettaInternet9.toJson());
  }
}
