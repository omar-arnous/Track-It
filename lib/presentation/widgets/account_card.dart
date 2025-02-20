import 'package:flutter/material.dart';
import 'package:trackit/core/utils/formatter.dart';
import 'package:trackit/domain/entities/account.dart';
import 'package:trackit/presentation/pages/account/accounts_list_dialog.dart';

class AccountCard extends StatelessWidget {
  final Account? account;
  const AccountCard({super.key, this.account});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: account == null ? Colors.grey : account!.color,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account == null ? 'account name' : account!.name,
                  style: TextStyle(
                    fontFamily:
                        Theme.of(context).textTheme.displayLarge!.fontFamily,
                    color: Colors.white,
                  ),
                ),
                Text(
                  account == null ? 'account type' : account!.type.name,
                  style: TextStyle(
                    fontFamily:
                        Theme.of(context).textTheme.labelMedium!.fontFamily,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${Formatter.formatBalance(account == null ? 0 : account!.balance)} ${Formatter.formatCurrency(
                    account == null ? 'usd' : account!.currency.name,
                  )}',
                  style: TextStyle(
                    fontFamily:
                        Theme.of(context).textTheme.bodyLarge!.fontFamily,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const AccountsListDialog();
                  },
                );
              },
              icon: const Icon(
                Icons.more_horiz,
                color: Colors.white,
              ),
              alignment: Alignment.topLeft,
            ),
          ],
        ),
      ),
    );
  }
}
