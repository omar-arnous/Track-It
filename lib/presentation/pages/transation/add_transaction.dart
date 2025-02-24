import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackit/core/utils/formatter.dart';
import 'package:trackit/domain/entities/account.dart';
import 'package:trackit/domain/entities/category.dart';
import 'package:trackit/domain/entities/currency_type.dart';
import 'package:trackit/domain/entities/payment_type.dart';
import 'package:trackit/domain/entities/transaction.dart';
import 'package:trackit/domain/entities/transaction_type.dart';
import 'package:trackit/presentation/blocs/account/account_bloc.dart';
import 'package:trackit/presentation/blocs/category/category_bloc.dart';
import 'package:trackit/presentation/blocs/transaction/transaction_bloc.dart';
import 'package:trackit/presentation/pages/category/category_list.dart';
import 'package:trackit/presentation/pages/transation/transaction_type_widget.dart';
import 'package:trackit/presentation/widgets/form_input.dart';
import 'package:trackit/presentation/widgets/payment_tile.dart';
import 'package:trackit/presentation/widgets/spinner.dart';

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
  Account? account;
  Category? category;
  late TransactionType transactionType;
  late CurrencyType currencyType;
  late PaymentType paymentType;
  late TabController _tabController;
  List<Account> accounts = [];

  bool expense = true;
  bool income = false;
  bool transfer = false;

  @override
  void initState() {
    super.initState();
    context.read<AccountBloc>().add(GetAccountsEvent());
    amountController = TextEditingController(text: "0");
    noteController = TextEditingController();
    date = DateTime.now();
    timeOfDay = TimeOfDay.now();
    transactionType = TransactionType.expense;
    paymentType = PaymentType.cash;
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
            onPressed: () {
              // final transaction = Transaction(
              //   transactionType: transactionType,
              //   amount: double.parse(amountController.text),
              //   paymentType: paymentType,
              //   currency: currencyType,
              //   date: date,
              //   time: timeOfDay,
              //   note: noteController.text,
              //   convertedAmount: 0,
              //   exchangeRate: 0,
              //   accountId: account!.id!,
              //   targetAccountId: account!.id!,
              //   categoryId: category!.id!,
              // );
              print(
                  "Transaction: $transactionType, ${double.parse(amountController.text)}, $paymentType, $currencyType, $date, $timeOfDay, ${noteController.text} $account, $category");
            },
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
                accounts = state.accounts;
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
                      _selectAccount(),
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
            dropdownColor: Colors.grey[100],
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
            onChanged: (PaymentType? newValue) {
              setState(() => paymentType = newValue!);
            },
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
            dropdownColor: Colors.grey[100],
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

  Widget _selectAccount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Target account',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        DropdownButtonHideUnderline(
          child: DropdownButton(
            dropdownColor: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            value: account,
            items: accounts
                .map(
                  (type) => DropdownMenuItem<Account>(
                    value: account,
                    child: Text(
                      type.name,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                )
                .toList(),
            onChanged: (Account? newValue) {
              setState(() => account = newValue!);
            },
          ),
        ),
      ],
    );
  }

  void _selectCategory(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.grey[100],
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
                        backgroundColor: Colors.grey[100],
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

  void validateForm() {
    final isValid = formKey.currentState!.validate();

    if (isValid) {
      final transaction = Transaction(
        transactionType: transactionType,
        amount: double.parse(amountController.text),
        paymentType: paymentType,
        currency: currencyType,
        date: date,
        time: timeOfDay,
        note: noteController.text,
        convertedAmount: 0,
        exchangeRate: 0,
        accountId: account!.id!,
        targetAccountId: account!.id!,
        categoryId: category!.id!,
      );
      print("Transaction: $transaction");
      // context.read<TransactionBloc>().add(
      //       AddTransactionEvent(transaction: transaction),
      //     );
      // context.pop();
    }
  }
}
