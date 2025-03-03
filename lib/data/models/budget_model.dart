import 'package:trackit/data/models/account_model.dart';
import 'package:trackit/domain/entities/budget.dart';
import 'package:trackit/domain/entities/budget_period.dart';

class BudgetModel extends Budget {
  const BudgetModel({
    super.id,
    required super.amountLimit,
    required super.period,
    required super.startDate,
    required super.endDate,
    required super.account,
  });

  factory BudgetModel.fromJson(
      Map<String, dynamic> json, AccountModel account) {
    return BudgetModel(
      id: json['id'],
      amountLimit: json['amount_limit'],
      period: BudgetPeriod.values.firstWhere(
        (e) => e.toString() == json['period'],
      ),
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      account: account,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "amount_limit": amountLimit,
      "period": period.toString(),
      "start_date": startDate.toIso8601String(),
      "end_date": endDate.toIso8601String(),
      "account_id": account.id,
    };
  }
}
