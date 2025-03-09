import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/core/strings/failures.dart';
import 'package:trackit/domain/entities/account.dart';
import 'package:trackit/domain/entities/budget.dart';
import 'package:trackit/domain/entities/transaction.dart';
import 'package:trackit/domain/usecases/account/backup_accounts.dart';
import 'package:trackit/domain/usecases/account/restore_accounts.dart';
import 'package:trackit/domain/usecases/budget/backup_budget.dart';
import 'package:trackit/domain/usecases/budget/restore_budget.dart';
import 'package:trackit/domain/usecases/transaction/backup_transactions.dart';
import 'package:trackit/domain/usecases/transaction/restore_transactions.dart';

part 'backup_event.dart';
part 'backup_state.dart';

class BackupBloc extends Bloc<BackupEvent, BackupState> {
  final BackupAccountsUsecase backupAccounts;
  final RestoreAccountsUsecase restoreAccounts;
  final BackupBudgetUsecase backupBudget;
  final RestoreBudgetUsecase restoreBudget;
  final BackupTransactionsUsecase backupTransactions;
  final RestoreTransactionsUsecase restoreTransactions;

  BackupBloc({
    required this.backupAccounts,
    required this.restoreAccounts,
    required this.backupBudget,
    required this.restoreBudget,
    required this.backupTransactions,
    required this.restoreTransactions,
  }) : super(LoadingState()) {
    on<BackupEvent>((event, emit) async {
      bool res = false;
      if (event is BackupData) {
        final accountsRes = await backupAccounts();
        res = _completeBackup(accountsRes);
        if (res == true) {
          final budgetRes = await backupBudget();
          res = _completeBackup(budgetRes);
          if (res == true) {
            final transactionRes = await backupTransactions();
            emit(_mapResponseToState(
                transactionRes, 'Backup has been done successfully'));
          } else {
            emit(ErrorState(message: 'Backup has not been completed'));
          }
        } else {
          emit(ErrorState(message: 'Backup has not been completed'));
        }
      } else if (event is RestoreData) {
        final accountsRes = await restoreAccounts();
        res = _completeBackup(accountsRes);
        if (res == true) {
          final budgetRes = await restoreBudget();
          res = _completeBackup(budgetRes);
          if (res == true) {
            final transactionRes = await restoreTransactions();
            emit(_mapResponseToState(
                transactionRes, 'Data has been restored successfully'));
          } else {
            emit(ErrorState(message: 'Cannot restore data'));
          }
        } else {
          emit(ErrorState(message: 'Cannot restore data'));
        }
      }
    });
  }

  bool _completeBackup(Either<Failure, Unit> res) {
    return res.fold((failure) => false, (_) => true);
  }

  BackupState _mapResponseToState(Either<Failure, Unit> res, String message) {
    return res.fold((failure) => ErrorState(message: _getMessage(failure)),
        (_) => SuccessState(message: message));
  }

  String _getMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Connection error, Unable to backup/restore data';
      case EmptyDatabaseFailure:
        return 'No data to backup';
      default:
        return kGenericFailureMessage;
    }
  }
}
