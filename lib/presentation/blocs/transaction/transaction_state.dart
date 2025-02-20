part of 'transaction_bloc.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object?> get props => [];
}

class InitialTransactionState extends TransactionState {}

class LoadingTransactionState extends TransactionState {}

class LoadedTransactionState extends TransactionState {
  final List<Transaction> transactions;

  const LoadedTransactionState({required this.transactions});

  @override
  List<Object?> get props => [transactions];
}

class EmptyTransactionState extends TransactionState {
  final String message;

  const EmptyTransactionState({required this.message});

  @override
  List<Object?> get props => [message];
}

class SuccesTransactionState extends TransactionState {
  final String message;

  const SuccesTransactionState({required this.message});

  @override
  List<Object?> get props => [message];
}

class ErrorTransactionState extends TransactionState {
  final String message;

  const ErrorTransactionState({required this.message});

  @override
  List<Object?> get props => [message];
}
