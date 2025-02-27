import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trackit/config/router.dart';
import 'package:trackit/core/constants/routes.dart';
import 'package:trackit/core/utils/formatter.dart';
import 'package:trackit/domain/entities/payment_type.dart';
import 'package:trackit/domain/entities/transaction.dart';
import 'package:trackit/domain/entities/transaction_type.dart';

class TransactionTile extends StatelessWidget {
  Transaction transaction;
  TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => context.push(
        kAddEditTransactionRoute,
        extra: AddEditTransactionParams(
          isUpdating: true,
          transaction: transaction,
        ),
      ),
      leading: CircleAvatar(
        backgroundColor: Colors.grey[100],
        child: Icon(
          transaction.category.icon,
          color: transaction.category.color,
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            transaction.category.name,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            mapPaymentTypeToString(transaction.paymentType),
            style: Theme.of(context).textTheme.labelMedium,
          ),
          Text(
            transaction.note ?? '',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontStyle: FontStyle.italic,
                ),
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            transaction.transactionType == TransactionType.expense
                ? '-${Formatter.formatBalance(transaction.amount)}'
                : transaction.transactionType == TransactionType.income
                    ? '+${Formatter.formatBalance(transaction.amount)}'
                    : Formatter.formatBalance(transaction.amount),
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: transaction.transactionType == TransactionType.expense
                      ? Colors.red[400]
                      : transaction.transactionType == TransactionType.income
                          ? Colors.green[400]
                          : Colors.amber[400],
                ),
          ),
          Text(
            Formatter.formatDate(transaction.date),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
