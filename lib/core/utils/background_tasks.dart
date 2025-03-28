import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trackit/core/constants/db_constants.dart';
import 'package:trackit/data/models/account_model.dart';
import 'package:trackit/data/models/category_model.dart';
import 'package:trackit/data/models/transaction_model.dart';
import 'package:trackit/domain/entities/currency_type.dart';
import 'package:trackit/domain/entities/payment_type.dart';
import 'package:trackit/domain/entities/period.dart';
import 'package:trackit/domain/entities/transaction_type.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      Database db =
          await openDatabase(join(await getDatabasesPath(), kDatabaseName));

      String today = DateTime.now().toIso8601String();

      List<Map<String, dynamic>> recurringPayments = await db.query(
        kRecurringTransactionsTable,
        where: "next_due_date = ?",
        whereArgs: [today],
      );

      List<Map<String, dynamic>> budgets = await db.query(
        kBudgetsTable,
      );

      for (var budget in budgets) {
        final currentDate = DateTime.now();
        final endDate = budget['end_date'];
        if (DateTime.parse(endDate).isBefore(currentDate)) {
          if (budget['next_due_date'] == today) {
            await sendNotification(
                "Budget Proccessed",
                "A budget of ${budget['amount']} was sent.",
                "Budget Notification");
          }
        }
      }

      for (var recurringPayment in recurringPayments) {
        double amount = recurringPayment['amount'];
        DateTime nextDueDate =
            getNextDueDate(today, recurringPayment['frequency']);
        await db.update(
          kRecurringTransactionsTable,
          {
            'next_due_date': nextDueDate.toIso8601String(),
          },
          where: 'id = ?',
          whereArgs: [recurringPayment['id']],
        );
        List<Map<String, dynamic>> accounts = await db.query(
          kAccountsTable,
          where: "id = ?",
          whereArgs: [recurringPayment['account_id']],
        );
        List<Map<String, dynamic>> categories = await db.query(
          kCategoriesTable,
          where: "id = ?",
          whereArgs: [recurringPayment['category_id']],
        );
        final transaction = TransactionModel(
          transactionType: TransactionType.expense,
          amount: amount,
          paymentType: PaymentType.values.firstWhere(
              (e) => e.toString() == recurringPayment['payment_type']),
          currency: CurrencyType.values
              .firstWhere((e) => e.toString() == recurringPayment['currency']),
          note: recurringPayment['note'],
          date: DateTime.now(),
          time: TimeOfDay.now(),
          account: AccountModel.fromJson(accounts.first),
          targetAccount: AccountModel.fromJson(accounts.first),
          category: CategoryModel.fromJson(categories.first),
        );
        await db.insert(kTransactionsTable, transaction.toJson());
        await sendNotification("Recurring Payment Proccessed",
            "A payment of $amount was sent.", "Recurring Payment Notification");
      }
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  });
}

Future<void> sendNotification(
    String title, String body, String description) async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var androidDetails = AndroidNotificationDetails(
    'payment_channel',
    'payments',
    channelDescription: description,
    importance: Importance.high,
    priority: Priority.high,
  );
  var platformChannelSpecifics = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
      0, title, body, platformChannelSpecifics);
}

DateTime getNextDueDate(String currentDate, String frequency) {
  final frequencyValue =
      Period.values.firstWhere((e) => e.toString() == frequency);
  DateTime date = DateTime.parse(currentDate);
  switch (frequencyValue) {
    case Period.daily:
      return date.add(const Duration(days: 1));
    case Period.weekly:
      return date.add(const Duration(days: 7));
    case Period.monthly:
      return DateTime(date.year, date.month + 1, date.day);
    default:
      return DateTime.parse(currentDate);
  }
}
