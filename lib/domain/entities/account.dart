import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum AccountType { cash, bank, saving }

enum CurrencyType { usd, syp }

class Account extends Equatable {
  final int? id;
  final String name;
  final AccountType type;
  final double balance;
  final Color color;
  final CurrencyType currency;

  const Account({
    this.id,
    required this.name,
    required this.type,
    required this.balance,
    this.color = Colors.grey,
    required this.currency,
  });

  @override
  List<Object?> get props => [id, name, type, balance, color, currency];
}
