import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackit/core/constants/colors.dart';
import 'package:trackit/domain/entities/exchange_rate.dart';
import 'package:trackit/presentation/blocs/exchange_rate/exchange_rate_bloc.dart';

class ExhangeRateInput extends StatelessWidget {
  final String title;
  bool disable;
  ExchangeRate? exchangeRate;
  final TextEditingController controller;

  ExhangeRateInput({
    super.key,
    required this.title,
    required this.controller,
    this.disable = false,
    this.exchangeRate,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                fillColor: Theme.of(context).brightness == Brightness.dark
                    ? kDarkColor
                    : kLightColor,
              ),
              controller: controller,
              enabled: disable ? false : true,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              onSubmitted: (value) {
                final updatedRate = ExchangeRate(
                  id: exchangeRate!.id,
                  baseCurrency: exchangeRate!.baseCurrency,
                  targetCurrency: exchangeRate!.targetCurrency,
                  rate: double.parse(value),
                  updatedAt: DateTime.now(),
                );
                context.read<ExchangeRateBloc>().add(
                      UpdateExchangeRateEvent(
                        exchangeRate: updatedRate,
                      ),
                    );
              },
            ),
          ),
        ],
      ),
    );
  }
}
