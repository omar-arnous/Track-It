part of 'account_bloc.dart';

class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object?> get props => [];
}

class InitialAccountState extends AccountState {}

class LoadingAccountState extends AccountState {}

class LoadedAccountState extends AccountState {
  final List<Account> accounts;
  final int selectedAccountId;
  const LoadedAccountState(
      {required this.accounts, required this.selectedAccountId});

  @override
  List<Object?> get props => [accounts, selectedAccountId];
}

class SuccessAccountState extends AccountState {
  final String message;
  const SuccessAccountState({required this.message});

  @override
  List<Object?> get props => [message];
}

class ErrorAccountState extends AccountState {
  final String message;
  const ErrorAccountState({required this.message});

  @override
  List<Object?> get props => [message];
}
