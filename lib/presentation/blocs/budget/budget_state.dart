part of 'budget_bloc.dart';

abstract class BudgetState extends Equatable {}

final class LoadingState extends BudgetState {
  @override
  List<Object> get props => [];
}

final class IdleState extends BudgetState {
  final Budget budget;

  IdleState({required this.budget});

  @override
  List<Object> get props => [budget];
}

final class SuccessState extends BudgetState {
  @override
  List<Object> get props => [];
}

final class ErrorState extends BudgetState {
  final String message;

  ErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
