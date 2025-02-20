import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:trackit/domain/entities/account.dart';
import 'package:trackit/domain/entities/currency_type.dart';
import 'package:trackit/domain/entities/transaction_type.dart';

class Transaction extends Equatable {
  final int? id;
  final TransactionType transactionType;
  final double amount;
  final CurrencyType currency;
  final double? exchangeRate;
  final double? convertedAmount;
  final String? note;
  final DateTime? date;
  final Account account;
  final Account? targetAccount;
  final Category category;

  const Transaction({
    this.id,
    required this.transactionType,
    required this.amount,
    required this.currency,
    this.exchangeRate = 0,
    this.convertedAmount = 0,
    this.note,
    this.date,
    required this.account,
    this.targetAccount,
    required this.category,
  });

  @override
  List<Object?> get props => [];
}
