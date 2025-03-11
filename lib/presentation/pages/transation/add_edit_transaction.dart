import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackit/core/constants/colors.dart';
import 'package:trackit/core/utils/formatter.dart';
import 'package:trackit/domain/entities/account.dart';
import 'package:trackit/domain/entities/category.dart';
import 'package:trackit/domain/entities/currency_type.dart';
import 'package:trackit/domain/entities/payment_type.dart';
import 'package:trackit/domain/entities/transaction.dart';
import 'package:trackit/domain/entities/transaction_type.dart';
import 'package:trackit/presentation/blocs/account/account_bloc.dart';
import 'package:trackit/presentation/blocs/category/category_bloc.dart';
import 'package:trackit/presentation/blocs/exchange_rate/exchange_rate_bloc.dart';
import 'package:trackit/presentation/blocs/transaction/transaction_bloc.dart';
import 'package:trackit/presentation/pages/transation/transaction_type_widget.dart';
import 'package:trackit/presentation/widgets/form_input.dart';
import 'package:trackit/presentation/widgets/payment_tile.dart';
import 'package:trackit/presentation/widgets/show_delete_confirm_dialog.dart';
import 'package:trackit/presentation/widgets/spinner.dart';

class AddEditTransaction extends StatefulWidget {
  final Transaction? transaction;
  final bool isUpdating;
  const AddEditTransaction({
    super.key,
    this.transaction,
    this.isUpdating = false,
  });

  @override
  State<AddEditTransaction> createState() => _AddEditTransactionState();
}

class _AddEditTransactionState extends State<AddEditTransaction>
    with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  late TextEditingController amountController;
  late TextEditingController noteController;
  late DateTime date;
  late TimeOfDay timeOfDay;
  Account? account;
  Account? targetAccount;
  Category? category;
  late TransactionType transactionType;
  late CurrencyType currencyType;
  late PaymentType paymentType;
  late TabController _tabController;

  bool expense = true;
  bool income = false;
  bool transfer = false;

  @override
  void initState() {
    super.initState();
    context.read<AccountBloc>().add(GetAccountsEvent());
    _tabController = TabController(length: 3, vsync: this);
    if (widget.isUpdating) {
      final transaction = widget.transaction!;
      amountController =
          TextEditingController(text: transaction.amount.toString());
      noteController = TextEditingController(text: transaction.note);
      date = transaction.date;
      timeOfDay = transaction.time;
      transactionType = transaction.transactionType;
      paymentType = transaction.paymentType;
      currencyType = transaction.currency;
      category = transaction.category;
      if (transactionType == TransactionType.expense) {
        _tabController.index = 0;
      } else if (transactionType == TransactionType.income) {
        _tabController.index = 1;
      } else {
        _tabController.index = 2;
      }
    } else {
      amountController = TextEditingController(text: "0");
      noteController = TextEditingController();
      date = DateTime.now();
      timeOfDay = TimeOfDay.now();
      transactionType = TransactionType.expense;
      paymentType = PaymentType.cash;
      currencyType = CurrencyType.syp;
    }
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
    final isUpdate = widget.isUpdating;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isUpdate ? 'Edit Transaction' : 'Add Transaction',
        ),
        actions: [
          if (isUpdate)
            IconButton(
              onPressed: deleteTransaction,
              icon: const Icon(
                Icons.delete,
                color: kRedColor,
              ),
            ),
          IconButton(
            onPressed: validateForm,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: BlocConsumer<AccountBloc, AccountState>(
          listener: (context, state) {
            if (state is LoadedAccountState) {
              setState(() {
                account = state.accounts
                    .firstWhere((e) => e.id == state.selectedAccountId);
                currencyType = state.accounts
                    .firstWhere(
                        (account) => account.id == state.selectedAccountId)
                    .currency;
              });
            }
          },
          builder: (context, state) {
            return Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      alignTextEnd: true,
                      trailing: Text(
                        Formatter.formatCurrency(currencyType.name),
                      ),
                      type: Type.number,
                    ),
                    const SizedBox(height: 30),
                    PaymentTile(
                      icon: const Icon(Icons.calendar_month),
                      title: 'Date',
                      value: Formatter.formatDate(date),
                      onPress: () => selectDate(context),
                    ),
                    const SizedBox(height: 8),
                    PaymentTile(
                      icon: const Icon(Icons.timer),
                      title: 'Time',
                      value: Formatter.formatTimeOfDay(timeOfDay),
                      onPress: () => selectTime(context),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _paymentType(),
                        _currencyType(),
                      ],
                    ),
                    const SizedBox(height: 30),
                    if (transactionType == TransactionType.transfer) ...[
                      PaymentTile(
                        icon: const Icon(Icons.account_balance_outlined),
                        title: targetAccount != null
                            ? targetAccount!.name
                            : 'Target account',
                        onPress: () => _selectAccount(context),
                      ),
                    ],
                    const SizedBox(height: 8),
                    PaymentTile(
                      icon: const Icon(Icons.layers),
                      title:
                          category != null ? category!.name : 'Select category',
                      onPress: () => _selectCategory(context),
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

  Widget _paymentType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Type',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        DropdownButtonHideUnderline(
          child: DropdownButton(
            dropdownColor: kGreyColor,
            borderRadius: BorderRadius.circular(12),
            value: paymentType,
            items: PaymentType.values
                .map(
                  (type) => DropdownMenuItem<PaymentType>(
                    value: type,
                    child: Text(
                      mapPaymentTypeToString(type),
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                )
                .toList(),
            onChanged: (PaymentType? newValue) {},
          ),
        ),
      ],
    );
  }

  Widget _currencyType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Currency Type',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        DropdownButtonHideUnderline(
          child: DropdownButton(
            dropdownColor: kGreyColor,
            borderRadius: BorderRadius.circular(12),
            value: currencyType,
            items: CurrencyType.values
                .map(
                  (type) => DropdownMenuItem<CurrencyType>(
                    value: type,
                    child: Text(
                      Formatter.formatCurrency(type.name),
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                )
                .toList(),
            onChanged: (CurrencyType? newValue) {
              setState(() => currencyType = newValue!);
            },
          ),
        ),
      ],
    );
  }

  void selectDate(BuildContext context) async {
    final currentDate = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: currentDate,
      lastDate: DateTime(currentDate.year + 5),
      onDatePickerModeChange: (value) {},
    );

    if (pickedDate != null && pickedDate != date) {
      setState(() {
        date = pickedDate;
      });
    }
  }

  void selectTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != timeOfDay) {
      setState(() {
        timeOfDay = pickedTime;
      });
    }
  }

  void _selectAccount(BuildContext context) async {
    showModalBottomSheet(
      backgroundColor: kGreyColor,
      context: context,
      builder: (context) {
        return BlocBuilder<AccountBloc, AccountState>(
          builder: (context, state) {
            if (state is LoadedAccountState) {
              final accounts = state.accounts;
              return Container(
                height: 300,
                padding: const EdgeInsets.all(12),
                child: ListView.separated(
                  itemCount: accounts.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 8);
                  },
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        setState(() => targetAccount = accounts[index]);
                        context.pop();
                      },
                      tileColor: accounts[index].color,
                      title: Column(
                        children: [
                          Text(
                            accounts[index].name,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(color: kWhiteColor),
                          ),
                          Text(
                            accounts[index].type.name,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                  color: kWhiteColor,
                                ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            } else {
              return const Spinner();
            }
          },
        );
      },
    );
  }

  void _selectCategory(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: kGreyColor,
      context: context,
      builder: (context) {
        return BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            if (state is LoadedCategoriesState) {
              final categories = state.categories;
              return Container(
                height: 300,
                padding: const EdgeInsets.all(12),
                child: ListView.separated(
                  itemCount: categories.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 8);
                  },
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        setState(() => category = categories[index]);
                        context.pop();
                      },
                      leading: CircleAvatar(
                        backgroundColor: kGreyColor,
                        child: Icon(
                          categories[index].icon,
                          color: categories[index].color,
                        ),
                      ),
                      title: Text(
                        categories[index].name,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    );
                  },
                ),
              );
            } else {
              return const Spinner();
            }
          },
        );
      },
    );
  }

  void deleteTransaction() async {
    await showDeleteDialog(
      context: context,
      onConfirm: () async {
        context.read<TransactionBloc>().add(
              DeleteTransactionEvent(id: widget.transaction!.id!),
            );
        await Future.delayed(const Duration(milliseconds: 300));
        if (!mounted) return;
        context.read<AccountBloc>().add(GetAccountsEvent());
      },
      label: 'delete',
      title: 'Delete transaction',
      content: 'Are you sure you want to delete this transaction',
    );

    if (!mounted) return;
    // context.read<TransactionBloc>().add(
    //       GetTransactionsByAccountEvent(accountId: account!.id!),
    //     );
    context.pop();
  }

  void validateForm() {
    final isValid = formKey.currentState!.validate();

    if (isValid) {
      final transaction = Transaction(
        id: widget.transaction?.id,
        transactionType: transactionType,
        amount: double.parse(amountController.text),
        paymentType: paymentType,
        currency: currencyType,
        date: date,
        time: timeOfDay,
        note: noteController.text,
        convertedAmount: 0,
        exchangeRate: 0,
        account: account!,
        targetAccount: targetAccount ?? account,
        category: category!,
      );
      if (widget.isUpdating) {
        context.read<AccountBloc>().add(
              ReverseBalanceEvent(id: account!.id!),
            );
        context.read<TransactionBloc>().add(
              UpdateTransactionEvent(transaction: transaction),
            );
      } else {
        context.read<TransactionBloc>().add(
              AddTransactionEvent(transaction: transaction),
            );
      }

      if (transactionType == TransactionType.expense) {
        context.read<AccountBloc>().add(
              DecreaseBalanceEvent(
                id: transaction.account.id!,
                value: transaction.amount,
              ),
            );
      } else if (transactionType == TransactionType.income) {
        context.read<AccountBloc>().add(
              IncreaseBalanceEvent(
                id: transaction.account.id!,
                value: transaction.amount,
              ),
            );
      } else {
        final rateState = context.read<ExchangeRateBloc>().state;
        if (rateState is IdleState) {
          final rate = rateState.exchangeRates.first.rate;
          double targetAmount = 0;
          if (account!.currency == CurrencyType.syp &&
              targetAccount!.currency == CurrencyType.usd) {
            targetAmount = transaction.amount / rate;
          } else if (account!.currency == CurrencyType.usd &&
              targetAccount!.currency == CurrencyType.syp) {
            targetAmount = transaction.amount * rate;
          } else {
            targetAmount = transaction.amount;
          }
          context.read<AccountBloc>().add(
                DecreaseBalanceEvent(
                  id: transaction.account.id!,
                  value: transaction.amount,
                ),
              );
          context.read<AccountBloc>().add(
                IncreaseBalanceEvent(
                  id: transaction.targetAccount!.id!,
                  value: targetAmount,
                ),
              );
        }
      }
      context.pop();
    }
  }
}
