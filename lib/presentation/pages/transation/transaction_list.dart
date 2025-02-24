import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackit/core/utils/formatter.dart';
import 'package:trackit/domain/entities/transaction.dart';
import 'package:trackit/presentation/blocs/account/account_bloc.dart';
import 'package:trackit/presentation/blocs/transaction/transaction_bloc.dart';
import 'package:trackit/presentation/widgets/no_data.dart';
import 'package:trackit/presentation/widgets/show_snack_message.dart';
import 'package:trackit/presentation/widgets/spinner.dart';

class TransactionList extends StatelessWidget {
  final int? count;
  const TransactionList({super.key, this.count});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state is LoadedAccountState) {
          context.read<TransactionBloc>().add(
                GetTransactionsByAccountEvent(
                  accountId: state.selectedAccountId,
                ),
              );
        }
      },
      child: BlocConsumer<TransactionBloc, TransactionState>(
        listener: (context, state) {
          if (state is SuccesTransactionState) {
            showSnackMessage(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is LoadingTransactionState) {
            return const Spinner();
          } else if (state is LoadedTransactionState) {
            return _buildTransactionList(state.transactions);
          } else if (state is ErrorTransactionState) {
            return NoData(message: state.message);
          } else if (state is EmptyTransactionState) {
            return NoData(message: state.message);
          } else {
            return const NoData(message: "No Transactions");
          }
        },
      ),
    );
  }

  Widget _buildTransactionList(List<Transaction> transactions) {
    return Expanded(
      child: ListView.separated(
        itemCount: count ?? transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[100],
              child: Icon(
                transaction.category.icon,
                color: transaction.category.color,
              ),
            ),
            title: Column(
              children: [
                Text(transaction.category.name),
                Text(transaction.account.type.name),
                Text(transaction.note ?? ''),
              ],
            ),
            trailing: Column(
              children: [
                Text(Formatter.formatBalance(transaction.amount)),
                Text(Formatter.formatDate(transaction.date)),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 8);
        },
      ),
    );
  }
}
