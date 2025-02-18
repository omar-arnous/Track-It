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
                          return ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            onTap: () {
                              context.read<AccountBloc>().add(
                                    SelectAccountEvent(
                                      id: accounts[index].id!,
                                    ),
                                  );
                              context.pop();
                            },
                            tileColor: accounts[index].color,
                            contentPadding: const EdgeInsets.all(8),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  accounts[index].name,
                                  style: TextStyle(
                                    fontFamily: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .fontFamily,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  accounts[index].type.name,
                                  style: TextStyle(
                                    fontFamily: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .fontFamily,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '${Formatter.formatBalance(accounts[index].balance)} ${Formatter.formatCurrency(
                                    accounts[index].currency.name,
                                  )}',
                                  style: TextStyle(
                                    fontFamily: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .fontFamily,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            // trailing: Row(
                            //   children: [
                            //     IconButton(
                            //       onPressed: () {},
                            //       icon: Icon(
                            //         Icons.edit,
                            //         color: Colors.cyanAccent[300],
                            //       ),
                            //     ),
                            //     IconButton(
                            //       onPressed: () {},
                            //       icon: Icon(
                            //         Icons.delete,
                            //         color: Colors.red[600],
                            //       ),
                            //     ),
                            //   ],
                            // ),
                          );
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
