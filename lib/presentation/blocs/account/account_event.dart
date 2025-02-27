part of 'account_bloc.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object?> get props => [];
}

class GetAccountsEvent extends AccountEvent {}

class SelectAccountEvent extends AccountEvent {
  final Account account;
  const SelectAccountEvent({required this.account});

  @override
  List<Object?> get props => [account];
}

class AddAccountEvent extends AccountEvent {
  final Account account;
  const AddAccountEvent({required this.account});

  @override
  List<Object?> get props => [account];
}

class UpdateAccountEvent extends AccountEvent {
  final Account account;
  const UpdateAccountEvent({required this.account});

  @override
  List<Object?> get props => [account];
}

class DeleteAccountEvent extends AccountEvent {
  final int id;
  const DeleteAccountEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class DecreaseBalanceEvent extends AccountEvent {
  final int id;
  final double value;

  const DecreaseBalanceEvent({required this.id, required this.value});

  @override
  List<Object?> get props => [id, value];
}

class IncreaseBalanceEvent extends AccountEvent {
  final int id;
  final double value;

  const IncreaseBalanceEvent({required this.id, required this.value});

  @override
  List<Object?> get props => [id, value];
}

class ReverseBalanceEvent extends AccountEvent {
  final int id;

  const ReverseBalanceEvent({required this.id});

  @override
  List<Object?> get props => [id];
}
