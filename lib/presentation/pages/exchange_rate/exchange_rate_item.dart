import 'package:flutter/material.dart';
import 'package:trackit/core/constants/colors.dart';
import 'package:trackit/core/utils/formatter.dart';
import 'package:trackit/domain/entities/exchange_rate.dart';
import 'package:trackit/presentation/pages/exchange_rate/exhange_rate_input.dart';

class ExchangeRateItem extends StatefulWidget {
  ExchangeRate exchangeRate;
  ExchangeRateItem({super.key, required this.exchangeRate});

  @override
  State<ExchangeRateItem> createState() => _ExchangeRateItemState();
}

class _ExchangeRateItemState extends State<ExchangeRateItem> {
  late TextEditingController baseController;
  late TextEditingController targetController;

  @override
  void initState() {
    super.initState();
    baseController = TextEditingController(text: '1');
    targetController = TextEditingController(
        text: widget.exchangeRate.rate.toStringAsFixed(2));
  }

  @override
  void dispose() {
    baseController.dispose();
    targetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? kBlackColor
            : kWhiteColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExhangeRateInput(
                title: Formatter.formatCurrency(
                  widget.exchangeRate.baseCurrency.name,
                ),
                disable: true,
                controller: baseController,
              ),
              const Icon(Icons.currency_exchange),
              ExhangeRateInput(
                title: Formatter.formatCurrency(
                  widget.exchangeRate.targetCurrency.name,
                ),
                controller: targetController,
                exchangeRate: widget.exchangeRate,
              ),
            ],
          ),
          Text(
            'Latest update: ${Formatter.formatDate(widget.exchangeRate.updatedAt)}',
          ),
        ],
      ),
    );
  }
}
