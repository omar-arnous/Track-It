import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackit/core/constants/colors.dart';
import 'package:trackit/core/utils/formatter.dart';
import 'package:trackit/domain/entities/account.dart';
import 'package:trackit/domain/entities/transaction.dart';
import 'package:trackit/domain/entities/transaction_type.dart';
import 'package:trackit/presentation/blocs/transaction/transaction_bloc.dart';

class BalanceCard extends StatelessWidget {
  final Account? account;
  const BalanceCard({
    super.key,
    this.account,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Theme.of(context).brightness == Brightness.light
          ? kWhiteColor
          : kBlackColor,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            if (state is LoadedTransactionState) {
              return _balanceCard(context, state.transactions);
            } else {
              return _emptyBalanceCard(context);
            }
          },
        ),
      ),
    );
  }

  Widget _balanceCard(BuildContext context, List<Transaction> transactions) {
    final totalIncome = transactions
        .where((t) => t.transactionType == TransactionType.income)
        .fold<double>(0, (sum, t) => sum + t.amount);

    final totalExpenses = transactions
        .where((t) => t.transactionType == TransactionType.expense)
        .fold<double>(0, (sum, t) => sum + t.amount.abs());
    final balance = totalIncome - totalExpenses;
    final balancePercentage = totalIncome > 0
        ? ((balance / totalIncome) * 100).toStringAsFixed(1)
        : '0';

    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Balance: ${Formatter.formatBalance(balance)} ${Formatter.formatCurrency(transactions.first.currency.name)}',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: balance >= 0 ? Colors.green : Colors.red,
                  ),
            ),
            Text(
              'Remaining: $balancePercentage% of income',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: kGreyColor,
                  ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _emptyBalanceCard(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Balance'),
            Text(
              '0',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'Remaining: 100% of income',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: kGreyColor,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
