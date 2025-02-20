import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/core/strings/failures.dart';
import 'package:trackit/core/strings/messages.dart';
import 'package:trackit/domain/entities/transaction.dart';
import 'package:trackit/domain/usecases/transaction/add_transaction.dart';
import 'package:trackit/domain/usecases/transaction/delete_transaction.dart';
import 'package:trackit/domain/usecases/transaction/get_transactions_by_account_id.dart';
import 'package:trackit/domain/usecases/transaction/update_transaction.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final GetTransactionsByAccountIdUsecase getTransactionsByAccountId;
  final AddTransactionUsecase addTransaction;
  final UpdateTransactionUsecase updateTransaction;
  final DeleteTransactionUsecase deleteTransaction;

  TransactionBloc({
    required this.getTransactionsByAccountId,
    required this.addTransaction,
    required this.updateTransaction,
    required this.deleteTransaction,
  }) : super(InitialTransactionState()) {
    on<TransactionEvent>((event, emit) async {
      if (event is GetTransactionsByAccountEvent) {
        emit(LoadingTransactionState());

        final res = await getTransactionsByAccountId(event.accountId);
        emit(_mapGetResponseToState(res));
      } else if (event is AddTransactionEvent) {
        final res = await addTransaction(event.transaction);
        emit(_mapResponseToState(res, 'Transaction added successfully'));
      } else if (event is UpdateTransactionEvent) {
        final res = await updateTransaction(event.transaction);
        emit(_mapResponseToState(res, 'Transaction updated successfully'));
      } else if (event is DeleteTransactionEvent) {
        final res = await deleteTransaction(event.id);
        emit(_mapResponseToState(res, 'Transaction deleted successfully'));
      }
    });
  }

  TransactionState _mapGetResponseToState(
      Either<Failure, List<Transaction>> res) {
    return res.fold(
      (failure) =>
          const EmptyTransactionState(message: "There is no transactions"),
      (transactions) => LoadedTransactionState(transactions: transactions),
    );
  }

  TransactionState _mapResponseToState(
      Either<Failure, Unit> res, String message) {
    return res.fold(
      (failure) => ErrorTransactionState(message: _getMessage(failure)),
      (_) => SuccesTransactionState(message: message),
    );
  }

  String _getMessage(Failure failure) {
    switch (failure.runtimeType) {
      case DatabaseAddFailure:
        return '$kFailureAdd transaction';
      case DatabaseEditFailure:
        return '$kFailureEdit transaction';
      case DatabaseDeleteFailure:
        return '$kFailureDelete transaction';
      default:
        return kGenericFailureMessage;
    }
  }
}
