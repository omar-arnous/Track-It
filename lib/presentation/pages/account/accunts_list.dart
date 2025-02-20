import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackit/presentation/blocs/account/account_bloc.dart';
import 'package:trackit/presentation/pages/account/account_item.dart';
import 'package:trackit/presentation/widgets/empty_page.dart';
import 'package:trackit/presentation/widgets/show_error.dart';
import 'package:trackit/presentation/widgets/spinner.dart';

class AccountsList extends StatelessWidget {
  const AccountsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        if (state is LoadingAccountState) {
          return const Spinner();
        } else if (state is LoadedAccountState) {
          return ListView.separated(
            itemCount: state.accounts.length,
            itemBuilder: (context, index) {
              return AccountItem(
                account: state.accounts[index],
                actionable: true,
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 20);
            },
          );
        } else if (state is ErrorAccountState) {
          return EmptyPage(
            message: '${state.message} accounts yet, create one',
          );
        } else {
          return Center(
            child: Text(
              'No accounts',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }
      },
    );
  }
}
