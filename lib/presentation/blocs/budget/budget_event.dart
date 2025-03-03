part of 'budget_bloc.dart';

abstract class BudgetEvent {}

class InitEvent extends BudgetEvent {}

class GetBudgetsEvent extends BudgetEvent {}

class AddBudgetEvent extends BudgetEvent {
  final Budget budget;

  AddBudgetEvent({required this.budget});
}

class UpdateBudgetEvent extends BudgetEvent {
  final Budget budget;

  UpdateBudgetEvent({required this.budget});
}

class DeleteBudgetEvent extends BudgetEvent {
  final int id;

  DeleteBudgetEvent({required this.id});
}

class BudgetNotifyLimitEvent extends BudgetEvent {
  final bool isLimit;

  BudgetNotifyLimitEvent({required this.isLimit});
}
