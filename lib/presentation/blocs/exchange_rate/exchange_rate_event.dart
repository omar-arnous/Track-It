part of 'exchange_rate_bloc.dart';

sealed class ExchangeRateEvent {}

class InitEvent extends ExchangeRateEvent {}

class GetExchangeRatesEvent extends ExchangeRateEvent {}

class AddExchangeRateEvent extends ExchangeRateEvent {
  final ExchangeRate exchangeRate;

  AddExchangeRateEvent({required this.exchangeRate});
}

class UpdateExchangeRateEvent extends ExchangeRateEvent {
  final ExchangeRate exchangeRate;

  UpdateExchangeRateEvent({required this.exchangeRate});
}
