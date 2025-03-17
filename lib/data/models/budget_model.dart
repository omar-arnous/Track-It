import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trackit/data/models/account_model.dart';
import 'package:trackit/domain/entities/account.dart';
import 'package:trackit/domain/entities/budget.dart';
import 'package:trackit/domain/entities/period.dart';

class BudgetModel extends Budget {
  const BudgetModel({
    super.id,
    required super.amountLimit,
    required super.period,
    required super.startDate,
    required super.nextDueDate,
    required super.endDate,
    required super.account,
  });

  factory BudgetModel.fromJson(
      Map<String, dynamic> json, AccountModel account) {
    return BudgetModel(
      id: json['id'],
      amountLimit: json['amount_limit'],
      period: Period.values.firstWhere(
        (e) => e.toString() == json['period'],
      ),
      startDate: DateTime.parse(json['start_date']),
      nextDueDate: DateTime.parse(json['next_due_date']),
      endDate: DateTime.parse(json['end_date']),
      account: account,
    );
  }

  factory BudgetModel.fromSnapshot(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
    Account account,
  ) {
    return BudgetModel(
      id: snapshot.data()['id'],
      amountLimit: snapshot.data()['amount_limit'],
      period: Period.values.firstWhere(
        (e) => e.toString() == snapshot.data()['period'],
      ),
      startDate: DateTime.parse(snapshot.data()['start_date']),
      nextDueDate: DateTime.parse(snapshot.data()['next_due_date']),
      endDate: DateTime.parse(snapshot.data()['end_date']),
      account: account,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "amount_limit": amountLimit,
      "period": period.toString(),
      "start_date": startDate.toIso8601String(),
      "next_due_date": nextDueDate.toIso8601String(),
      "end_date": endDate.toIso8601String(),
      "account_id": account.id,
    };
  }
}
