import 'package:equatable/equatable.dart';
import 'package:trackit/domain/entities/account.dart';
import 'package:trackit/domain/entities/period.dart';

class Budget extends Equatable {
  final int? id;
  final double amountLimit;
  final Period period;
  final DateTime startDate;
  final DateTime endDate;
  final Account account;

  const Budget({
    this.id,
    required this.amountLimit,
    required this.period,
    required this.startDate,
    required this.endDate,
    required this.account,
  });

  @override
  List<Object?> get props => [
        id,
        amountLimit,
        period,
        startDate,
        endDate,
        account,
      ];
}
