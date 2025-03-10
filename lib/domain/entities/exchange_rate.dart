import 'package:equatable/equatable.dart';
import 'package:trackit/domain/entities/currency_type.dart';

class ExchangeRate extends Equatable {
  final int? id;
  final CurrencyType baseCurrency;
  final CurrencyType targetCurrency;
  final double rate;
  final DateTime updatedAt;

  const ExchangeRate({
    this.id,
    required this.baseCurrency,
    required this.targetCurrency,
    required this.rate,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        baseCurrency,
        targetCurrency,
        rate,
        updatedAt,
      ];
}
