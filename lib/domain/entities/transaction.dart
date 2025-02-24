import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:trackit/domain/entities/currency_type.dart';
import 'package:trackit/domain/entities/payment_type.dart';
import 'package:trackit/domain/entities/transaction_type.dart';

class Transaction extends Equatable {
  final int? id;
  final TransactionType transactionType;
  final double amount;
  final PaymentType paymentType;
  final CurrencyType currency;
  final double? exchangeRate;
  final double? convertedAmount;
  final String? note;
  final DateTime date;
  final TimeOfDay time;
  final int accountId;
  final int? targetAccountId;
  final int categoryId;

  const Transaction({
    this.id,
    required this.transactionType,
    required this.amount,
    required this.paymentType,
    required this.currency,
    this.exchangeRate = 0,
    this.convertedAmount = 0,
    this.note,
    required this.date,
    required this.time,
    required this.accountId,
    this.targetAccountId,
    required this.categoryId,
  });

  @override
  List<Object?> get props => [];
}
