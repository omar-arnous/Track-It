import 'package:cloud_firestore/cloud_firestore.dart' as cloud;
import 'package:trackit/data/models/account_model.dart';
import 'package:trackit/data/models/category_model.dart';
import 'package:trackit/domain/entities/currency_type.dart';
import 'package:trackit/domain/entities/payment_type.dart';
import 'package:trackit/domain/entities/period.dart';
import 'package:trackit/domain/entities/recurring.dart';

class RecurringModel extends Recurring {
  const RecurringModel({
    super.id,
    required super.paymentType,
    required super.currencyType,
    required super.amount,
    required super.frequency,
    required super.createdAt,
    required super.nextDueDate,
    super.note,
    required super.account,
    required super.category,
  });

  factory RecurringModel.fromJson(
    Map<String, dynamic> json,
    AccountModel account,
    CategoryModel category,
  ) {
    return RecurringModel(
      id: json['id'],
      paymentType: PaymentType.values
          .firstWhere((e) => e.toString() == json['payment_type']),
      currencyType: CurrencyType.values
          .firstWhere((e) => e.toString() == json['currency']),
      amount: json['amount'],
      frequency:
          Period.values.firstWhere((e) => e.toString() == json['frequency']),
      createdAt: DateTime.parse(json['created_at']),
      nextDueDate: DateTime.parse(json['next_due_date']),
      note: json['note'],
      account: account,
      category: category,
    );
  }

  factory RecurringModel.fromSnapshot(
    cloud.QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
    AccountModel account,
    CategoryModel category,
  ) {
    return RecurringModel(
      id: snapshot.data()['id'],
      paymentType: PaymentType.values
          .firstWhere((e) => e.toString() == snapshot.data()['payment_type']),
      currencyType: CurrencyType.values
          .firstWhere((e) => e.toString() == snapshot.data()['currency']),
      amount: snapshot.data()['amount'],
      frequency: Period.values
          .firstWhere((e) => e.toString() == snapshot.data()['frequency']),
      createdAt: DateTime.parse(snapshot.data()['created_at']),
      nextDueDate: DateTime.parse(snapshot.data()['next_due_date']),
      note: snapshot.data()['note'],
      account: account,
      category: category,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "payment_type": paymentType.toString(),
      "amount": amount,
      "currency": currencyType.toString(),
      "frequency": frequency.toString(),
      "next_due_date": nextDueDate.toIso8601String(),
      "created_at": createdAt.toIso8601String(),
      "note": note,
      "account_id": account.id,
      "category_id": category.id,
    };
  }
}
