import 'package:equatable/equatable.dart';

enum AccountType { cash, bank, saving }

enum CurrencyType { usd, syp }

class Account extends Equatable {
  final int? id;
  final String name;
  final AccountType type;
  final double balance;
  final CurrencyType currency;

  const Account({
    this.id,
    required this.name,
    required this.type,
    required this.balance,
    required this.currency,
  });

  @override
  List<Object?> get props => [id, name, type, balance, currency];
}
