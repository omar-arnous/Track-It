import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trackit/core/constants/routes.dart';
import 'package:trackit/core/utils/formatter.dart';
import 'package:trackit/presentation/blocs/account/account_bloc.dart';
import 'package:trackit/presentation/widgets/show_error.dart';
import 'package:trackit/presentation/widgets/show_snack_message.dart';

class AccountsListDialog extends StatelessWidget {
  const AccountsListDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: double.maxFinite,
      child: Dialog(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                BlocConsumer<AccountBloc, AccountState>(
                    listener: (context, state) {
                  if (state is SuccessAccountState) {
                    showSnackMessage(context, state.message);
                  }
                }, builder: (context, state) {
                  if (state is LoadedAccountState) {
                    final accounts = state.accounts;
                    return ListView.separated(
                      itemCount: accounts.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () => context.read<AccountBloc>().add(
                                SelectAccountEvent(
                                  id: accounts[index].id!,
                                ),
                              ),
                          tileColor: accounts[index].color,
                          contentPadding: const EdgeInsets.all(8),
                          isThreeLine: true,
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(accounts[index].name),
                              Text(accounts[index].type.toString()),
                              Text(
                                '${Formatter.formatBalance(accounts[index].balance)} ${Formatter.formatCurrency(
                                  accounts[index].currency.toString(),
                                )}',
                              ),
                            ],
                          ),
                          trailing: Row(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.cyanAccent[300],
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red[600],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider(thickness: 1);
                      },
                    );
                  } else {
                    return Text(
                      'No accounts, create a new one',
                      style: Theme.of(context).textTheme.bodyMedium,
                    );
                  }
                }),
                ListTile(
                  onTap: () => context.push(kAddEditAccount),
                  leading: const Icon(Icons.add),
                  title: Text(
                    'Add new account',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
