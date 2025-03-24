import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackit/core/constants/routes.dart';
import 'package:trackit/domain/entities/account.dart';
import 'package:trackit/presentation/blocs/account/account_bloc.dart';
import 'package:trackit/presentation/pages/settings/setting_tile.dart';
import 'package:trackit/presentation/pages/transation/transaction_list.dart';
import 'package:trackit/presentation/widgets/Spinner.dart';
import 'package:trackit/presentation/widgets/account_card.dart';
import 'package:trackit/presentation/widgets/expense_pie_chart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        const SizedBox(height: 24),
        const SettingTile(
          title: 'Analytics',
          path: kAnalyticsPage,
          trailing: Icons.line_axis_outlined,
        ),
        const SizedBox(height: 24),
        Text(
          'Transactions',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
        const TransactionList(),
      ],
    );
  }
}
