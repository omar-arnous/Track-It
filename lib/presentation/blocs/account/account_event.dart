part of 'account_bloc.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object?> get props => [];
}

class GetAccountsEvent extends AccountEvent {}

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
