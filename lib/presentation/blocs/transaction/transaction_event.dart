part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

class GetTransactionsByAccountEvent extends TransactionEvent {
  int accountId;

  GetTransactionsByAccountEvent({required this.accountId});

  @override
  List<Object?> get props => [accountId];
}

class AddTransactionEvent extends TransactionEvent {
  Transaction transaction;

  AddTransactionEvent({required this.transaction});

  @override
  List<Object?> get props => [transaction];
}

class UpdateTransactionEvent extends TransactionEvent {
  Transaction transaction;

  UpdateTransactionEvent({required this.transaction});

  @override
  List<Object?> get props => [transaction];
}

class DeleteTransactionEvent extends TransactionEvent {
  int id;

  DeleteTransactionEvent({required this.id});

  @override
  List<Object?> get props => [id];
}
