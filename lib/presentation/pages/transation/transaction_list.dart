import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackit/domain/entities/transaction.dart';
import 'package:trackit/presentation/blocs/account/account_bloc.dart';
import 'package:trackit/presentation/blocs/transaction/transaction_bloc.dart';
import 'package:trackit/presentation/widgets/empty_page.dart';
import 'package:trackit/presentation/widgets/no_data.dart';
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
                    accountId: state.selectedAccountId),
              );
        }
      },
      child: BlocBuilder<TransactionBloc, TransactionState>(
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
            return const Spinner();
          }
        },
      ),
    );
  }

  Widget _buildTransactionList(List<Transaction> transactions) {
    return ListView.separated(
      itemCount: count ?? transactions.length,
      itemBuilder: (context, index) {
        return null;
      },
      separatorBuilder: (context, index) {
        return const Divider(
          thickness: 1,
        );
      },
    );
  }
}
