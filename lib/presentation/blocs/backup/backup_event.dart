part of 'backup_bloc.dart';

sealed class BackupEvent {}

class BackupData extends BackupEvent {
  final List<Account> accounts;
  final List<Transaction> transactions;
  final List<Budget> budgets;

  BackupData({
    required this.accounts,
    required this.budgets,
    required this.transactions,
  });
}

class RestoreData extends BackupEvent {}
