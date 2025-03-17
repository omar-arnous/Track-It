part of 'reccurring_bloc.dart';

abstract class RecurringState extends Equatable {}

final class LoadingState extends RecurringState {
  @override
  List<Object> get props => [];
}

final class IdleRecurringState extends RecurringState {
  final List<Recurring> recurringPayments;

  IdleRecurringState({required this.recurringPayments});

  @override
  List<Object> get props => [recurringPayments];
}

final class EmptyRecurringState extends RecurringState {
  final String message;

  EmptyRecurringState({required this.message});

  @override
  List<Object> get props => [message];
}

final class SuccessRecurringState extends RecurringState {
  final String message;

  SuccessRecurringState({required this.message});

  @override
  List<Object> get props => [message];
}

final class ErrorRecurringState extends RecurringState {
  final String message;

  ErrorRecurringState({required this.message});

  @override
  List<Object> get props => [message];
}
