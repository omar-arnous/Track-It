import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trackit/config/router.dart';
import 'package:trackit/core/constants/routes.dart';
import 'package:trackit/core/utils/formatter.dart';
import 'package:trackit/domain/entities/account.dart';
import 'package:trackit/presentation/blocs/account/account_bloc.dart';
import 'package:trackit/presentation/widgets/show_delete_confirm_dialog.dart';

class AccountItem extends StatelessWidget {
  final bool actionable;
  final Account account;

  const AccountItem({
    super.key,
    required this.account,
    this.actionable = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onTap: () {
        if (actionable == true) {
          context.push(
            kAddEditAccountRoute,
            extra: AddEditAccountParams(
              isUpdating: true,
              account: account,
            ),
          );
        } else {
          context.read<AccountBloc>().add(
                SelectAccountEvent(account: account),
              );
          context.pop();
        }
      },
      tileColor: account.color,
      contentPadding: const EdgeInsets.all(8),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            account.name,
            style: TextStyle(
              fontFamily: Theme.of(context).textTheme.bodyLarge!.fontFamily,
              color: Colors.white,
            ),
          ),
          Text(
            account.type.name,
            style: TextStyle(
              fontFamily: Theme.of(context).textTheme.bodyMedium!.fontFamily,
              color: Colors.white,
            ),
          ),
          Text(
            '${Formatter.formatBalance(account.balance)} ${Formatter.formatCurrency(
              account.currency.name,
            )}',
            style: TextStyle(
              fontFamily: Theme.of(context).textTheme.labelLarge!.fontFamily,
              color: Colors.white,
            ),
          ),
        ],
      ),
      trailing: actionable == true
          ? IconButton(
              onPressed: () {
                showDeleteDialog(
                  context: context,
                  onConfirm: () async {
                    context.read<AccountBloc>().add(
                          DeleteAccountEvent(
                            id: account.id!,
                          ),
                        );
                  },
                  label: 'delete',
                  title: 'Delete ${account.name}',
                  content: 'Are you sure you want to delete this account?',
                  showSnack: true,
                  snakMessage: 'account deleted succesfully',
                );
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            )
          : null,
    );
  }
}
