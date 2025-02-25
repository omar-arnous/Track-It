import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackit/presentation/blocs/account/account_bloc.dart';
import 'package:trackit/presentation/widgets/Spinner.dart';
import 'package:trackit/presentation/widgets/account_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Accounts',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        BlocBuilder<AccountBloc, AccountState>(
          builder: (context, state) {
            if (state is LoadingAccountState) {
              return const Spinner();
            } else if (state is LoadedAccountState) {
              final account = state.accounts.firstWhere(
                (account) => account.id == state.selectedAccountId,
              );
              return AccountCard(account: account);
            } else if (state is ErrorAccountState) {
              return const AccountCard();
            } else {
              return const AccountCard();
            }
          },
        ),
        const Text('Pie Chart'),
        const Text('Transactions List'),
      ],
    );
  }
}
