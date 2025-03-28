import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trackit/core/utils/color_convertor.dart';
import 'package:trackit/domain/entities/account.dart';
import 'package:trackit/domain/entities/account_type.dart';
import 'package:trackit/domain/entities/currency_type.dart';

class AccountModel extends Account {
  const AccountModel({
    super.id,
    required super.name,
    required super.type,
    required super.balance,
    required super.oldBalance,
    required super.totalExpenses,
    required super.totalIncomes,
    super.color,
    required super.currency,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id'],
      name: json['name'],
      type: AccountType.values.firstWhere((e) => e.toString() == json['type']),
      balance: json['balance'],
      oldBalance: json['old_balance'],
      totalExpenses: json['total_expenses'],
      totalIncomes: json['total_incomes'],
      color: ColorConvertor.hexStringToColor(json['color']),
      currency: CurrencyType.values
          .firstWhere((e) => e.toString() == json['currency']),
    );
  }

  factory AccountModel.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
    return AccountModel(
      id: snapshot.data()['id'],
      name: snapshot.data()['name'],
      type: AccountType.values
          .firstWhere((e) => e.toString() == snapshot.data()['type']),
      balance: snapshot.data()['balance'],
      oldBalance: snapshot.data()['old_balance'],
      totalExpenses: snapshot.data()['total_expenses'],
      totalIncomes: snapshot.data()['total_incomes'],
      color: ColorConvertor.hexStringToColor(snapshot.data()['color']),
      currency: CurrencyType.values
          .firstWhere((e) => e.toString() == snapshot.data()['currency']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.toString(),
      'balance': balance,
      'old_balance': oldBalance,
      'total_expenses': totalExpenses,
      'total_incomes': totalIncomes,
      'color': ColorConvertor.colorToHexString(color),
      'currency': currency.toString(),
    };
  }
}
