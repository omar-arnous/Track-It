part of 'backup_bloc.dart';

sealed class BackupState extends Equatable {}

final class LoadingState extends BackupState {
  @override
  List<Object> get props => [];
}

final class IdleState extends BackupState {
  final List<Account> accounts;
  final List<Budget> budgets;
  final List<Transaction> transactions;

  IdleState({
    required this.accounts,
    required this.budgets,
    required this.transactions,
  });

  @override
  List<Object> get props => [accounts, budgets, transactions];
}

final class EmptyState extends BackupState {
  final String message;

  EmptyState({required this.message});

  @override
  List<Object> get props => [message];
}

final class SuccessState extends BackupState {
  final String message;

  SuccessState({required this.message});

  @override
  List<Object> get props => [message];
}

final class ErrorState extends BackupState {
  final String message;

  ErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
