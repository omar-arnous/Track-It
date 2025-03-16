import 'package:equatable/equatable.dart';
import 'package:trackit/domain/entities/account.dart';
import 'package:trackit/domain/entities/category.dart';
import 'package:trackit/domain/entities/currency_type.dart';
import 'package:trackit/domain/entities/period.dart';
import 'package:trackit/domain/entities/payment_type.dart';

class Recurring extends Equatable {
  final int? id;
  final PaymentType paymentType;
  final CurrencyType currencyType;
  final double amount;
  final Period frequency;
  final DateTime createdAt;
  final DateTime nextDueDate;
  final String? note;
  final Account account;
  final Category category;

  const Recurring({
    this.id,
    required this.paymentType,
    required this.currencyType,
    required this.amount,
    required this.frequency,
    required this.createdAt,
    required this.nextDueDate,
    this.note,
    required this.account,
    required this.category,
  });

  @override
  List<Object?> get props => [
        id,
        paymentType,
        currencyType,
        amount,
        frequency,
        createdAt,
        nextDueDate,
        note,
        account,
        category,
      ];
}
