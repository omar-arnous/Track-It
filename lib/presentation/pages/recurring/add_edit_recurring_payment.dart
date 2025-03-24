import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackit/core/constants/colors.dart';
import 'package:trackit/core/utils/background_tasks.dart';
import 'package:trackit/core/utils/formatter.dart';
import 'package:trackit/domain/entities/account.dart';
import 'package:trackit/domain/entities/category.dart';
import 'package:trackit/domain/entities/currency_type.dart';
import 'package:trackit/domain/entities/payment_type.dart';
import 'package:trackit/domain/entities/period.dart';
import 'package:trackit/domain/entities/recurring.dart';
import 'package:trackit/presentation/blocs/account/account_bloc.dart';
import 'package:trackit/presentation/blocs/category/category_bloc.dart';
import 'package:trackit/presentation/blocs/recurring/reccurring_bloc.dart';
import 'package:trackit/presentation/widgets/form_input.dart';
import 'package:trackit/presentation/widgets/payment_tile.dart';
import 'package:trackit/presentation/widgets/show_delete_confirm_dialog.dart';
import 'package:trackit/presentation/widgets/spinner.dart';

class AddEditRecurringPayment extends StatefulWidget {
  final Recurring? recurringPayment;
  final bool isUpdating;
  const AddEditRecurringPayment({
    super.key,
    this.recurringPayment,
    this.isUpdating = false,
  });

  @override
  State<AddEditRecurringPayment> createState() =>
      _AddEditRecurringPaymentState();
}

class _AddEditRecurringPaymentState extends State<AddEditRecurringPayment> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController amountController;
  late TextEditingController noteController;
  late PaymentType paymentType;
  late CurrencyType currencyType;
  late Period frequency;
  late DateTime startDate;
  Account? account;
  Category? category;

  @override
  void initState() {
    super.initState();
    context.read<AccountBloc>().add(GetAccountsEvent());
    if (widget.isUpdating) {
      final recurringPayment = widget.recurringPayment!;
      amountController = TextEditingController(
        text: recurringPayment.amount.toStringAsFixed(2),
      );
      noteController = TextEditingController(text: recurringPayment.note);
      paymentType = recurringPayment.paymentType;
      currencyType = recurringPayment.currencyType;
      frequency = recurringPayment.frequency;
      startDate = recurringPayment.createdAt;
      account = recurringPayment.account;
      category = recurringPayment.category;
    } else {
      amountController = TextEditingController(text: '0');
      noteController = TextEditingController();
      paymentType = PaymentType.cash;
      currencyType = CurrencyType.syp;
      frequency = Period.daily;
      startDate = DateTime.now();
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isUpdate = widget.isUpdating;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isUpdate ? 'Edit Recurring Payment' : 'Add Recurring Payment',
        ),
        actions: [
          if (isUpdate)
            IconButton(
              onPressed: deleteRecurringPayment,
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
                    const SizedBox(height: 10),
                    FormInput(
                      controller: amountController,
                      leading: const Text('Amount'),
                      alignTextEnd: true,
                      trailing: Text(
                        Formatter.formatCurrency(currencyType.name),
                      ),
                      type: Type.number,
                    ),
                    const SizedBox(height: 30),
                    const Text('Start Date'),
                    const SizedBox(height: 8),
                    PaymentTile(
                      icon: const Icon(Icons.calendar_month),
                      title: 'Start Date',
                      value: Formatter.formatDate(startDate),
                      onPress: () => selectDate(context),
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
                    _frequency(),
                    const SizedBox(height: 30),
                    PaymentTile(
                      icon: const Icon(Icons.account_balance),
                      title: account != null ? account!.name : 'Account',
                      onPress: () => _selectAccount(context),
                    ),
                    const SizedBox(height: 8),
                    PaymentTile(
                      icon: const Icon(Icons.layers),
                      title: category != null ? category!.name : 'Category',
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
            dropdownColor: Theme.of(context).brightness == Brightness.dark
                ? kBlackColor
                : kWhiteColor,
            borderRadius: BorderRadius.circular(8),
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
            dropdownColor: Theme.of(context).brightness == Brightness.dark
                ? kBlackColor
                : kWhiteColor,
            borderRadius: BorderRadius.circular(8),
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

  Widget _frequency() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Frequency',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        DropdownButtonHideUnderline(
          child: DropdownButton(
            dropdownColor: Theme.of(context).brightness == Brightness.dark
                ? kBlackColor
                : kWhiteColor,
            borderRadius: BorderRadius.circular(8),
            value: frequency,
            items: Period.values
                .map(
                  (type) => DropdownMenuItem<Period>(
                    value: type,
                    child: Text(
                      type.name,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                )
                .toList(),
            onChanged: (Period? newValue) {
              setState(() => frequency = newValue!);
            },
          ),
        ),
      ],
    );
  }

  void _selectAccount(BuildContext context) async {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? kBlackColor
          : kWhiteColor,
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
                        setState(() => account = accounts[index]);
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
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? kBlackColor
          : kWhiteColor,
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
                        backgroundColor: kWhiteColor,
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

  void selectDate(BuildContext context) async {
    final currentDate = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(currentDate.month - 1),
      lastDate: DateTime(currentDate.year + 5),
    );

    if (pickedDate != null && pickedDate != startDate) {
      setState(() {
        startDate = pickedDate;
      });
    }
  }

  void deleteRecurringPayment() async {
    await showDeleteDialog(
      context: context,
      onConfirm: () async {
        context.read<ReccurringBloc>().add(
              DeleteRecuringPaymentEvent(id: widget.recurringPayment!.id!),
            );
        await Future.delayed(const Duration(milliseconds: 300));
        if (!mounted) return;
        context.read<AccountBloc>().add(GetAccountsEvent());
      },
      label: 'delete',
      title: 'Delete recurring payment',
      content: 'Are you sure you want to delete this recurring payment',
    );

    if (!mounted) return;
    context.pop();
  }

  void validateForm() {
    final isValid = formKey.currentState!.validate();

    if (isValid) {
      final recurringPayment = Recurring(
        id: widget.recurringPayment?.id,
        paymentType: paymentType,
        currencyType: currencyType,
        amount: double.parse(amountController.text),
        frequency: frequency,
        createdAt: startDate,
        nextDueDate: getNextDueDate(
          startDate.toIso8601String(),
          frequency.toString(),
        ),
        note: noteController.text,
        account: account!,
        category: category!,
      );
      if (widget.isUpdating) {
        context.read<ReccurringBloc>().add(
              UpdateRecurringPaymentEvent(
                recurringPayment: recurringPayment,
              ),
            );
      } else {
        context.read<ReccurringBloc>().add(
              AddRecurringPaymentEvent(
                recurringPayment: recurringPayment,
              ),
            );
      }

      context.pop();
    }
  }
}
