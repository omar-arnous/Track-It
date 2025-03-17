part of 'reccurring_bloc.dart';

sealed class RecurringEvent {}

class GetRecurringPaymentsEvent extends RecurringEvent {}

class AddRecurringPaymentEvent extends RecurringEvent {
  final Recurring recurringPayment;
  AddRecurringPaymentEvent({required this.recurringPayment});
}

class UpdateRecurringPaymentEvent extends RecurringEvent {
  final Recurring recurringPayment;
  UpdateRecurringPaymentEvent({required this.recurringPayment});
}

class DeleteRecuringPaymentEvent extends RecurringEvent {
  final int id;
  DeleteRecuringPaymentEvent({required this.id});
}
