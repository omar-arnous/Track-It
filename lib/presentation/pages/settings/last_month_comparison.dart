import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackit/core/constants/colors.dart';
import 'package:trackit/domain/entities/account.dart';
import 'package:trackit/domain/entities/transaction.dart';
import 'package:trackit/presentation/blocs/transaction/transaction_bloc.dart';

class LastMonthComparison extends StatelessWidget {
  final Account? account;
  const LastMonthComparison({
    super.key,
    this.account,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: Theme.of(context).brightness == Brightness.light
          ? kWhiteColor
          : kBlackColor,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            if (state is LoadedTransactionState) {
              return _barChart(context, state.transactions);
            } else {
              return _emptyBarChart(context);
            }
          },
        ),
      ),
    );
  }

  Widget _barChart(BuildContext context, List<Transaction> transactions) {
    final DateTime now = DateTime.now();
    final DateTime firstDayOfCurrentMonth = DateTime(now.year, now.month, 1);
    final DateTime firstDayOfLastMonth = DateTime(now.year, now.month - 1, 1);
    final DateTime firstDayOfNextMonth = DateTime(now.year, now.month + 1, 1);
    final double lastMonthTotal = transactions
        .where((tx) =>
            tx.date.isAfter(
                firstDayOfLastMonth.subtract(const Duration(days: 1))) &&
            tx.date.isBefore(firstDayOfCurrentMonth))
        .fold(
          0.0,
          (sum, tx) => sum + tx.amount,
        );
    final double currentMonthTotal = transactions
        .where((tx) =>
            tx.date.isAfter(
                firstDayOfCurrentMonth.subtract(const Duration(days: 1))) &&
            tx.date.isBefore(firstDayOfNextMonth))
        .fold(
          0.0,
          (sum, tx) => sum + tx.amount,
        );

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      width: double.infinity,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: lastMonthTotal,
                  color: kGreyColor,
                ),
              ],
              showingTooltipIndicators: [0],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: currentMonthTotal,
                  color: kPrimaryColor,
                ),
              ],
              showingTooltipIndicators: [0],
            ),
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, _) {
                    switch (value.toInt()) {
                      case 0:
                        return const Text('Last Month');
                      case 1:
                        return const Text('This Month');
                      default:
                        return const SizedBox.shrink();
                    }
                  }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _emptyBarChart(BuildContext context) {
    return Row(
      children: [
        BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            barGroups: [
              BarChartGroupData(
                x: 0,
                barRods: [
                  BarChartRodData(
                    toY: 0, // empty bar
                    color: kGreyColor,
                    width: 20,
                  ),
                ],
              ),
              BarChartGroupData(
                x: 1,
                barRods: [
                  BarChartRodData(
                    toY: 0, // empty bar
                    color: kPrimaryColor,
                    width: 20,
                  ),
                ],
              ),
            ],
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, _) {
                    switch (value.toInt()) {
                      case 0:
                        return const Text('Last Month');
                      case 1:
                        return const Text('This Month');
                      default:
                        return const SizedBox.shrink();
                    }
                  },
                ),
              ),
              leftTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
          ),
        ),
      ],
    );
  }
}
