import 'package:equatable/equatable.dart';
import 'package:trackit/domain/entities/account.dart';
import 'package:trackit/domain/entities/budget_period.dart';
import 'package:trackit/domain/entities/category.dart';

class Budget extends Equatable {
  final int id;
  final double amountLimit;
  final BudgetPeriod period;
  final DateTime startDate;
  final DateTime endDate;
  final Account account;
  final Category category;

  const Budget({
    required this.id,
    required this.amountLimit,
    required this.period,
    required this.startDate,
    required this.endDate,
    required this.account,
    required this.category,
  });

  @override
  List<Object> get props =>
      [id, amountLimit, period, startDate, endDate, account, category];
}
