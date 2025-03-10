import 'package:trackit/domain/entities/currency_type.dart';
import 'package:trackit/domain/entities/exchange_rate.dart';

class ExchangeRateModel extends ExchangeRate {
  const ExchangeRateModel({
    super.id,
    required super.baseCurrency,
    required super.targetCurrency,
    required super.rate,
    required super.updatedAt,
  });

  factory ExchangeRateModel.fromJson(Map<String, dynamic> json) {
    return ExchangeRateModel(
      id: json['id'],
      baseCurrency: CurrencyType.values
          .firstWhere((e) => e.toString() == json['base_currency']),
      targetCurrency: CurrencyType.values
          .firstWhere((e) => e.toString() == json['target_currency']),
      rate: json['rate'],
      updatedAt: DateTime.parse(json['last_updated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "base_currency": baseCurrency.toString(),
      "target_currency": targetCurrency.toString(),
      "rate": rate,
      "last_updated": updatedAt.toIso8601String(),
    };
  }
}
