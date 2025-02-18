import 'package:flutter/material.dart';
import 'package:trackit/domain/entities/account.dart';
import 'package:trackit/presentation/pages/account/account_form.dart';

class AccountAddEditPage extends StatelessWidget {
  final Account? account;
  final bool isUpdateAccount;
  const AccountAddEditPage({
    super.key,
    this.account,
    this.isUpdateAccount = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isUpdateAccount ? 'Update account' : 'Add account'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isUpdateAccount
                    ? 'Modify your current account'
                    : 'Create a new account',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 12),
              AccountForm(
                isUpdate: isUpdateAccount,
                account: account,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
