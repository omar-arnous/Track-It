import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:trackit/domain/entities/account_type.dart';
import 'package:trackit/domain/entities/currency_type.dart';

class Account extends Equatable {
  final int? id;
  final String name;
  final AccountType type;
  final double balance;
  final double oldBalance;
  final Color color;
  final CurrencyType currency;

  const Account({
    this.id,
    required this.name,
    required this.type,
    required this.balance,
    required this.oldBalance,
    this.color = Colors.grey,
    required this.currency,
  });

  @override
  List<Object?> get props => [id, name, type, balance, color, currency];
}
