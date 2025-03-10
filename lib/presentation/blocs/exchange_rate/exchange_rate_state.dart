part of 'exchange_rate_bloc.dart';

abstract class ExchangeRateState extends Equatable {}

final class LoadingState extends ExchangeRateState {
  @override
  List<Object> get props => [];
}

final class IdleState extends ExchangeRateState {
  final List<ExchangeRate> exchangeRates;

  IdleState({required this.exchangeRates});

  @override
  List<Object> get props => [exchangeRates];
}

final class EmptyState extends ExchangeRateState {
  final String message;

  EmptyState({required this.message});

  @override
  List<Object> get props => [message];
}

final class SuccessState extends ExchangeRateState {
  final String message;

  SuccessState({required this.message});

  @override
  List<Object> get props => [message];
}

final class ErrorState extends ExchangeRateState {
  final String message;

  ErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
