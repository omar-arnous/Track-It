import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:trackit/domain/entities/account.dart';
import 'package:trackit/presentation/blocs/account/account_bloc.dart';
import 'package:trackit/presentation/widgets/form_button.dart';
import 'package:trackit/presentation/widgets/form_input.dart';

class AccountForm extends StatefulWidget {
  final Account? account;
  final bool isUpdate;
  const AccountForm({
    super.key,
    this.account,
    this.isUpdate = false,
  });

  @override
  State<AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends State<AccountForm> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  late TextEditingController _nameController;
  late TextEditingController _balanceController;
  AccountType _accountType = AccountType.cash;
  CurrencyType _currencyType = CurrencyType.usd;
  Color _currentColor = Colors.grey;

  @override
  void initState() {
    _nameController = TextEditingController();
    _balanceController = TextEditingController(
      text: 0.00.toStringAsFixed(2),
    );
    if (widget.isUpdate) {
      _nameController.text = widget.account!.name;
      _balanceController.text = widget.account!.balance.toStringAsFixed(2);
      _accountType = widget.account!.type;
      _currencyType = widget.account!.currency;
      _currentColor = widget.account!.color;
    }
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormInput(
            controller: _nameController,
            label: 'Account name',
            focus: true,
            require: true,
          ),
          const SizedBox(height: 15),
          _AccountTypeField(),
          const SizedBox(height: 15),
          FormInput(
            controller: _balanceController,
            label: 'Initial balance',
            type: Type.number,
          ),
          const SizedBox(height: 15),
          _CurrencyTypeField(),
          const SizedBox(height: 15),
          _ColorPicker(context),
          const SizedBox(height: 24),
          FormButton(
            label: widget.isUpdate ? 'Update account' : 'Add account',
            isLoading: isLoading,
            onPress: validateForm,
          )
        ],
      ),
    );
  }

  Widget _CurrencyTypeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Currency Type',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        Wrap(
          spacing: 10.0,
          children: [
            ChoiceChip.elevated(
              label: const Text('SYP'),
              selected: _currencyType == CurrencyType.syp,
              onSelected: (seleclted) {
                setState(() => _currencyType = CurrencyType.syp);
              },
            ),
            ChoiceChip.elevated(
              label: const Text('USD'),
              selected: _currencyType == CurrencyType.usd,
              onSelected: (seleclted) {
                setState(() => _currencyType = CurrencyType.usd);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _AccountTypeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account Type',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        Wrap(
          spacing: 10.0,
          children: [
            ChoiceChip.elevated(
              showCheckmark: false,
              avatar: const Icon(Icons.attach_money),
              label: const Text('Cash'),
              selected: _accountType == AccountType.cash,
              onSelected: (seleclted) {
                setState(() => _accountType = AccountType.cash);
              },
            ),
            ChoiceChip.elevated(
              showCheckmark: false,
              avatar: const Icon(Icons.account_balance),
              label: const Text('Bank'),
              selected: _accountType == AccountType.bank,
              onSelected: (seleclted) {
                setState(() => _accountType = AccountType.bank);
              },
            ),
            ChoiceChip.elevated(
              showCheckmark: false,
              avatar: const Icon(Icons.savings),
              label: const Text('Savings'),
              selected: _accountType == AccountType.saving,
              onSelected: (seleclted) {
                setState(() => _accountType = AccountType.saving);
              },
            ),
            ChoiceChip.elevated(
              showCheckmark: false,
              avatar: const Icon(Icons.credit_card),
              label: const Text('Credit'),
              selected: _accountType == AccountType.credit,
              onSelected: (seleclted) {
                setState(() => _accountType = AccountType.credit);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _ColorPicker(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              height: 50.0,
              width: 10.0,
              color: _currentColor,
            ),
            const SizedBox(width: 8.0),
            Text(
              'Color',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
        TextButton(
          child: const Text('Select'),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: BlockPicker(
                    pickerColor: Colors.white,
                    onColorChanged: (color) {
                      setState(() => _currentColor = color);
                    },
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('save'),
                    )
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }

  void validateForm() {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      setState(() {
        isLoading = true;
      });
      final account = Account(
        name: _nameController.text,
        type: _accountType,
        balance: double.parse(_balanceController.text),
        currency: _currencyType,
        color: _currentColor,
      );
      context.read<AccountBloc>().add(
            AddAccountEvent(account: account),
          );
      setState(() {
        isLoading = false;
      });
      context.pop();
    }
  }
}
