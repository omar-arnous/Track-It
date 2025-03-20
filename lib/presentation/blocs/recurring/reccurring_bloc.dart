import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/core/strings/failures.dart';
import 'package:trackit/core/strings/messages.dart';
import 'package:trackit/domain/entities/recurring.dart';
import 'package:trackit/domain/usecases/recurring/add_recuring_payment.dart';
import 'package:trackit/domain/usecases/recurring/delete_recurring_payment.dart';
import 'package:trackit/domain/usecases/recurring/edit_recurring_payment.dart';
import 'package:trackit/domain/usecases/recurring/get_recurring_payments.dart';

part 'recurring_event.dart';
part 'recurring_state.dart';

class ReccurringBloc extends Bloc<RecurringEvent, RecurringState> {
  final GetRecurringPaymentsUsecase getRecurringPayments;
  final AddRecurringPaymentsUsecase addRecurringPayment;
  final EditRecurringPaymentsUsecase editRecurringPayment;
  final DeleteRecurringPaymentsUsecase deleteRecurringPayment;

  ReccurringBloc({
    required this.getRecurringPayments,
    required this.addRecurringPayment,
    required this.editRecurringPayment,
    required this.deleteRecurringPayment,
  }) : super(LoadingState()) {
    on<RecurringEvent>((event, emit) async {
      if (event is GetRecurringPaymentsEvent) {
        final res = await getRecurringPayments();
        emit(_mapGetResponseToState(res));
      } else if (event is AddRecurringPaymentEvent) {
        final res = await addRecurringPayment(event.recurringPayment);
        emit(_mapResponseToState(res, 'Recurring payment added successfully'));
      } else if (event is UpdateRecurringPaymentEvent) {
        final res = await editRecurringPayment(event.recurringPayment);
        emit(
            _mapResponseToState(res, 'Recurring payment updated successfully'));
      } else if (event is DeleteRecuringPaymentEvent) {
        final res = await deleteRecurringPayment(event.id);
        emit(
            _mapResponseToState(res, 'Recurring payment deleted successfully'));
      }
    });
  }

  RecurringState _mapGetResponseToState(Either<Failure, List<Recurring>> res) {
    return res.fold(
      (failure) => EmptyRecurringState(message: _getMessage(failure)),
      (recurringPayments) =>
          IdleRecurringState(recurringPayments: recurringPayments),
    );
  }

  RecurringState _mapResponseToState(
      Either<Failure, Unit> res, String message) {
    return res.fold(
        (failure) => ErrorRecurringState(message: _getMessage(failure)), (_) {
      add(GetRecurringPaymentsEvent());
      return SuccessRecurringState(message: message);
    });
  }

  String _getMessage(Failure failure) {
    switch (failure.runtimeType) {
      case EmptyDatabaseFailure:
        return 'No Recurring payments yet';
      case DatabaseAddFailure:
        return '$kFailureAdd recurring payment';
      case DatabaseEditFailure:
        return '$kFailureEdit recurring payment';
      case DatabaseDeleteFailure:
        return '$kFailureDelete recurring payment';
      default:
        return kGenericFailureMessage;
    }
  }
}
