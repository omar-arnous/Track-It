import 'package:flutter/material.dart';
import 'package:trackit/data/models/account_model.dart';
import 'package:trackit/data/models/category_model.dart';
import 'package:trackit/domain/entities/currency_type.dart';
import 'package:trackit/domain/entities/payment_type.dart';
import 'package:trackit/domain/entities/transaction.dart';
import 'package:trackit/domain/entities/transaction_type.dart';

class TransactionModel extends Transaction {
  const TransactionModel({
    super.id,
    required super.transactionType,
    required super.amount,
    required super.paymentType,
    required super.currency,
    super.exchangeRate,
    super.convertedAmount,
    super.note,
    required super.date,
    required super.time,
    required super.account,
    super.targetAccount,
    required super.category,
  });

  factory TransactionModel.fromJson(
    Map<String, dynamic> json,
    AccountModel account,
    AccountModel targetAccount,
    CategoryModel category,
  ) {
    final parts = json['time'].split(":");
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    return TransactionModel(
      id: json['id'],
      transactionType: TransactionType.values.firstWhere(
        (e) => e.toString() == json['type'],
      ),
      amount: json['amount'],
      paymentType: PaymentType.values.firstWhere(
        (e) => e.toString() == json['payment_type'],
      ),
      currency: CurrencyType.values.firstWhere(
        (e) => e.toString() == json['currency'],
      ),
      exchangeRate: json['exchange_rate'],
      convertedAmount: json['converted_amount'],
      note: json['note'],
      date: DateTime.parse(json['date']),
      time: TimeOfDay(hour: hour, minute: minute),
      account: account,
      targetAccount: targetAccount,
      category: category,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "type": transactionType.toString(),
      "amount": amount,
      "payment_type": paymentType.toString(),
      "currency": currency.toString(),
      "exchange_rate": exchangeRate,
      "converted_amount": convertedAmount,
      "note": note,
      "date": date.toIso8601String(),
      "time": "${time.hour}:${time.minute}",
      "account_id": account.id,
      "target_account_id": targetAccount?.id ?? account.id,
      "category_id": category.id,
    };
  }
}
