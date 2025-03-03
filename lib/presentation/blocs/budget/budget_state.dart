part of 'budget_bloc.dart';

abstract class BudgetState extends Equatable {}

final class LoadingState extends BudgetState {
  @override
  List<Object> get props => [];
}

final class IdleState extends BudgetState {
  final List<Budget> budgets;

  IdleState({required this.budgets});

  @override
  List<Object> get props => [budgets];
}

final class EmptyState extends BudgetState {
  final String message;

  EmptyState({required this.message});

  @override
  List<Object> get props => [message];
}

final class NotifiactionTokenReceivedState extends BudgetState {
  final String token;

  NotifiactionTokenReceivedState({required this.token});

  @override
  List<Object> get props => [token];
}

final class SuccessState extends BudgetState {
  final String message;

  SuccessState({required this.message});

  @override
  List<Object> get props => [message];
}

final class ErrorState extends BudgetState {
  final String message;

  ErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
