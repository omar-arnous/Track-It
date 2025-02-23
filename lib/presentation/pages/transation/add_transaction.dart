import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackit/core/utils/formatter.dart';
import 'package:trackit/domain/entities/currency_type.dart';
import 'package:trackit/domain/entities/transaction_type.dart';
import 'package:trackit/presentation/blocs/account/account_bloc.dart';
import 'package:trackit/presentation/pages/transation/transaction_type_widget.dart';
import 'package:trackit/presentation/widgets/form_input.dart';
import 'package:trackit/presentation/widgets/payment_tile.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction>
    with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  late TextEditingController amountController;
  late TextEditingController noteController;
  late DateTime date;
  late TimeOfDay timeOfDay;
  late int account;
  late int category;
  late TransactionType transactionType;
  late CurrencyType currencyType;
  late TabController _tabController;

  bool expense = true;
  bool income = false;
  bool transfer = false;

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController(text: "0");
    noteController = TextEditingController();
    date = DateTime.now();
    timeOfDay = TimeOfDay.now();
    transactionType = TransactionType.expense;
    account = 1;
    category = 1;
    currencyType = CurrencyType.syp;
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Transaction',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: BlocConsumer<AccountBloc, AccountState>(
          listener: (context, state) {
            if (state is LoadedAccountState) {
              account = state.selectedAccountId;
              currencyType = state.accounts
                  .firstWhere(
                      (account) => account.id == state.selectedAccountId)
                  .currency;
            }
          },
          builder: (context, state) {
            return Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TransactionTypeWidget(
                      controller: _tabController,
                      onPress: (value) {
                        if (value == 0) {
                          setState(() {
                            transactionType = TransactionType.expense;
                          });
                        } else if (value == 1) {
                          setState(() {
                            transactionType = TransactionType.income;
                          });
                        } else {
                          setState(() {
                            transactionType = TransactionType.transfer;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    FormInput(
                      controller: amountController,
                      label: '',
                      leading: const Text('Amount'),
                      trailing: Text(
                        Formatter.formatCurrency(currencyType.name),
                      ),
                      type: Type.number,
                    ),
                    const SizedBox(height: 30),
                    PaymentTile(
                      icon: const Icon(Icons.calendar_month),
                      title: 'Date',
                    ),
                    const SizedBox(height: 8),
                    PaymentTile(
                      icon: const Icon(Icons.credit_card),
                      title: 'Select account',
                    ),
                    const SizedBox(height: 8),
                    if (transactionType == TransactionType.transfer) ...[
                      PaymentTile(
                        icon: const Icon(Icons.swap_horiz),
                        title: 'Select target account',
                      ),
                      const SizedBox(height: 8),
                    ],
                    PaymentTile(
                      icon: const Icon(Icons.layers),
                      title: 'Select category',
                    ),
                    const SizedBox(height: 8),
                    FormInput(
                      controller: noteController,
                      label: 'Note',
                      type: Type.textarea,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // void validateForm() {
  //   final isValid = _formKey.currentState!.validate();

  //   if (isValid) {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     if (widget.isUpdate) {
  //       final updateAccount = Account(
  //         id: widget.account!.id,
  //         name: _nameController.text,
  //         type: _accountType,
  //         balance: double.parse(_balanceController.text),
  //         currency: _currencyType,
  //         color: _currentColor,
  //       );
  //       context.read<AccountBloc>().add(
  //             UpdateAccountEvent(account: updateAccount),
  //           );
  //     } else {
  //       final newAccount = Account(
  //         name: _nameController.text,
  //         type: _accountType,
  //         balance: double.parse(_balanceController.text),
  //         currency: _currencyType,
  //         color: _currentColor,
  //       );
  //       context.read<AccountBloc>().add(
  //             AddAccountEvent(account: newAccount),
  //           );
  //     }
  //     setState(() {
  //       isLoading = false;
  //     });
  //     context.pop();
  //   }
  // }
}
