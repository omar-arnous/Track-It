import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackit/presentation/blocs/account/account_bloc.dart';
import 'package:trackit/presentation/pages/settings/last_month_comparison.dart';
import 'package:trackit/presentation/widgets/balance_card.dart';
import 'package:trackit/presentation/widgets/empty_page.dart';
import 'package:trackit/presentation/widgets/expense_pie_chart.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: BlocBuilder<AccountBloc, AccountState>(builder: (context, state) {
        if (state is LoadedAccountState) {
          final account = state.accounts
              .where(
                (account) => account.id == state.selectedAccountId,
              )
              .first;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Expenses',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ExpensePieChart(account: account),
                  const SizedBox(height: 20),
                  Text(
                    'Balance',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  BalanceCard(account: account),
                  const SizedBox(height: 20),
                  Text(
                    'Last Month Comparison',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  const LastMonthComparison(),
                ],
              ),
            ),
          );
        } else {
          return const EmptyPage();
        }
      }),
    );
  }
}
