import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/core/strings/failures.dart';
import 'package:trackit/core/strings/messages.dart';
import 'package:trackit/domain/entities/exchange_rate.dart';
import 'package:trackit/domain/usecases/exchange_rate/add_exchange_rate.dart';
import 'package:trackit/domain/usecases/exchange_rate/get_exchange_rates.dart';
import 'package:trackit/domain/usecases/exchange_rate/update_exchange_rate.dart';

part 'exchange_rate_event.dart';
part 'exchange_rate_state.dart';

class ExchangeRateBloc extends Bloc<ExchangeRateEvent, ExchangeRateState> {
  final GetExchangeRatesUsecase getExchangeRates;
  final AddExchangeRateUsecase addExchangeRate;
  final UpdateExchangeRateUsecase updateExchangeRate;

  ExchangeRateBloc({
    required this.getExchangeRates,
    required this.addExchangeRate,
    required this.updateExchangeRate,
  }) : super(LoadingState()) {
    on<ExchangeRateEvent>((event, emit) async {
      if (event is InitEvent || event is GetExchangeRatesEvent) {
        final res = await getExchangeRates();
        emit(_mapGetResponseToState(res));
      } else if (event is AddExchangeRateEvent) {
        final res = await addExchangeRate(event.exchangeRate);
        emit(_mapResponseToState(res, 'Exchange rate added successfully'));
      } else if (event is UpdateExchangeRateEvent) {
        final res = await updateExchangeRate(event.exchangeRate);
        emit(_mapResponseToState(res, 'Exchange rate updated successfully'));
      }
    });
  }

  ExchangeRateState _mapGetResponseToState(
      Either<Failure, List<ExchangeRate>> res) {
    return res.fold(
      (failure) => EmptyState(message: _getMessage(failure)),
      (exchangeRates) => IdleState(exchangeRates: exchangeRates),
    );
  }

  ExchangeRateState _mapResponseToState(
      Either<Failure, Unit> res, String message) {
    return res.fold(
      (failure) => EmptyState(message: _getMessage(failure)),
      (_) => SuccessState(message: message),
    );
  }

  String _getMessage(Failure failure) {
    switch (failure.runtimeType) {
      case EmptyDatabaseFailure:
        return 'No exchange rates yet, create one';
      case DatabaseAddFailure:
        return '$kFailureAdd exchange rate';
      case DatabaseEditFailure:
        return '$kFailureEdit exchange rate';
      default:
        return kGenericFailureMessage;
    }
  }
}
