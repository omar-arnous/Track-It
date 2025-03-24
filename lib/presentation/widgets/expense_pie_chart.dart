import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackit/core/constants/colors.dart';
import 'package:trackit/core/utils/formatter.dart';
import 'package:trackit/domain/entities/account.dart';
import 'package:trackit/domain/entities/category.dart';
import 'package:trackit/domain/entities/transaction.dart';
import 'package:trackit/domain/entities/transaction_type.dart';
import 'package:trackit/presentation/blocs/category/category_bloc.dart';
import 'package:trackit/presentation/blocs/transaction/transaction_bloc.dart';

class ExpensePieChart extends StatelessWidget {
  final Account? account;
  const ExpensePieChart({
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
              return _pieCard(context, state.transactions);
            } else {
              return _emptyPieCard(context);
            }
          },
        ),
      ),
    );
  }

  Widget _emptyPieCard(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Expenses',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  '0',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: kRedColor,
                      ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 40),
        PieChart(
          PieChartData(
            sections: [],
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _pieCard(BuildContext context, List<Transaction> transactions) {
    final totalExpenses = transactions
        .where((t) => t.transactionType == TransactionType.expense)
        .fold<double>(0, (sum, t) => sum + t.amount.abs());
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Expenses',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  '-${Formatter.formatBalance(totalExpenses)} ${Formatter.formatCurrency(transactions.first.currency.name)}',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: kRedColor,
                      ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 40),
        BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            if (state is LoadedCategoriesState) {
              final categoryData = getCategoryWiseExpenses(
                transactions: transactions,
                categories: state.categories,
              );
              final colors = [
                kRedColor,
                kGreenColor,
                kPinkColor,
                kBlueColor,
                kYellowColor,
                kOrangeColor,
                kGreyColor,
              ];
              final total =
                  categoryData.values.fold<double>(0, (a, b) => a + b);
              return SizedBox(
                height: 100,
                width: 100,
                child: PieChart(
                  PieChartData(
                    sections: categoryData.entries.map((entry) {
                      final index =
                          categoryData.keys.toList().indexOf(entry.key);
                      final percentage =
                          ((entry.value / total) * 100).toString();
                      return PieChartSectionData(
                        color: colors[index % colors.length],
                        value: entry.value,
                        title: '${entry.key}\n$percentage%',
                        radius: 40,
                        titleStyle: Theme.of(context).textTheme.labelSmall,
                      );
                    }).toList(),
                    sectionsSpace: 2,
                    centerSpaceRadius: 30,
                  ),
                ),
              );
            } else {
              return const Text('');
            }
          },
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Map<String, double> getCategoryWiseExpenses(
      {required List<Transaction> transactions,
      required List<Category> categories}) {
    final Map<String, double> categoryTotals = {};

    for (var category in categories) {
      final totalForCategory = transactions
          .where((transaction) => transaction.category == category)
          .fold<double>(
            0.0,
            (sum, transaction) => sum + transaction.amount,
          );
      if (totalForCategory > 0) {
        categoryTotals[category.name] = totalForCategory;
      }
    }

    return categoryTotals;
  }
}
