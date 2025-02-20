import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trackit/core/constants/routes.dart';
import 'package:trackit/presentation/blocs/account/account_bloc.dart';
import 'package:trackit/presentation/pages/account/account_item.dart';
import 'package:trackit/presentation/widgets/show_snack_message.dart';

class AccountsListDialog extends StatelessWidget {
  const AccountsListDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 400,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                onTap: () {
                  context.pop();
                  context.push(kAddEditAccount);
                },
                leading: const Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                title: Text(
                  'Add new account',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              const Divider(thickness: 1),
              Expanded(
                child: BlocConsumer<AccountBloc, AccountState>(
                  listener: (context, state) {
                    if (state is SuccessAccountState) {
                      showSnackMessage(context, state.message);
                    }
                  },
                  builder: (context, state) {
                    if (state is LoadedAccountState) {
                      final accounts = state.accounts;
                      return ListView.separated(
                        itemCount: accounts.length,
                        itemBuilder: (context, index) {
                          return AccountItem(account: accounts[index]);
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 12);
                        },
                      );
                    } else {
                      return const SizedBox(height: 20);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
