import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackit/domain/entities/currency_type.dart';
import 'package:trackit/domain/entities/exchange_rate.dart';
import 'package:trackit/presentation/blocs/exchange_rate/exchange_rate_bloc.dart';
import 'package:trackit/presentation/pages/exchange_rate/exchange_rate_item.dart';
import 'package:trackit/presentation/widgets/Spinner.dart';
import 'package:trackit/presentation/widgets/no_data.dart';
import 'package:trackit/presentation/widgets/show_error.dart';
import 'package:trackit/presentation/widgets/show_snack_message.dart';

class ExchangeRateList extends StatelessWidget {
  const ExchangeRateList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exchange Rates'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: BlocConsumer<ExchangeRateBloc, ExchangeRateState>(
          listener: (context, state) {
            if (state is SuccessState) {
              showSnackMessage(context, state.message);
            }

            if (state is ErrorState) {
              ShowError.show(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is LoadingState) {
              return const Spinner();
            } else if (state is EmptyState) {
              final exchangeRate = ExchangeRate(
                baseCurrency: CurrencyType.syp,
                targetCurrency: CurrencyType.usd,
                rate: 10000,
                updatedAt: DateTime.now(),
              );
              context
                  .read<ExchangeRateBloc>()
                  .add(AddExchangeRateEvent(exchangeRate: exchangeRate));
              return NoData(message: state.message);
            } else if (state is IdleState) {
              final exchangeRates = state.exchangeRates;
              return ListView.separated(
                itemCount: exchangeRates.length,
                itemBuilder: (context, index) {
                  return ExchangeRateItem(
                    exchangeRate: exchangeRates[index],
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 20);
                },
              );
            } else {
              return const Spinner();
            }
          },
        ),
      ),
    );
  }
}
