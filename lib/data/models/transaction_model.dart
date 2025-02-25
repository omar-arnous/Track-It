import 'package:trackit/domain/entities/currency_type.dart';
import 'package:trackit/domain/entities/transaction.dart';
import 'package:trackit/domain/entities/transaction_type.dart';

class TransactionModel extends Transaction {
  const TransactionModel({
    super.id,
    required super.transactionType,
    required super.amount,
    required super.currency,
    super.exchangeRate,
    super.convertedAmount,
    super.note,
    super.date,
    required super.accountId,
    super.targetAccountId,
    required super.categoryId,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      transactionType: TransactionType.values.firstWhere(
        (e) => e.toString() == json['type'],
      ),
      amount: json['amount'],
      currency: CurrencyType.values.firstWhere(
        (e) => e.toString() == json['currency'],
      ),
      exchangeRate: json['exchange_rate'],
      convertedAmount: json['converted_amount'],
      note: json['note'],
      date: DateTime.parse(json['date']),
      accountId: json['account_id'],
      targetAccountId: json['target_account_id'],
      categoryId: json['category_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "type": transactionType.toString(),
      "amount": amount,
      "currency": currency.toString(),
      "exchange_rate": exchangeRate,
      "converted_amount": convertedAmount,
      "note": note,
      "date": date!.toIso8601String(),
      "account_id": accountId,
      "target_account_id": targetAccountId ?? accountId,
      "category_id": categoryId,
    };
  }
}
