import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackit/core/constants/colors.dart';
import 'package:trackit/core/utils/formatter.dart';
import 'package:trackit/domain/entities/account.dart';
import 'package:trackit/domain/entities/budget.dart';
import 'package:trackit/domain/entities/period.dart';
import 'package:trackit/presentation/blocs/account/account_bloc.dart';
import 'package:trackit/presentation/blocs/budget/budget_bloc.dart';
import 'package:trackit/presentation/widgets/form_input.dart';
import 'package:trackit/presentation/widgets/payment_tile.dart';
import 'package:trackit/presentation/widgets/spinner.dart';

class AddEditBudget extends StatefulWidget {
  final Budget? budget;
  final bool isUpdating;

  const AddEditBudget({
    super.key,
    this.budget,
    this.isUpdating = false,
  });

  @override
  State<AddEditBudget> createState() => _AddEditBudgetState();
}

class _AddEditBudgetState extends State<AddEditBudget> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController amountLimitController;
  late Period period;
  late DateTime startDate;
  late DateTime endDate;
  Account? account;

  @override
  void initState() {
    context.read<AccountBloc>().add(GetAccountsEvent());
    if (widget.isUpdating) {
      final budget = widget.budget!;
      amountLimitController = TextEditingController(
        text: budget.amountLimit.toString(),
      );
      period = budget.period;
      startDate = budget.startDate;
      endDate = budget.endDate;
      account = budget.account;
    }

    amountLimitController = TextEditingController();
    period = Period.monthly;
    startDate = DateTime.now();
    endDate = DateTime.now();
    super.initState();
  }

  @override
  void dispose() {
    amountLimitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isUpdate = widget.isUpdating;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isUpdate ? 'Edit Budget' : 'Add Budget',
        ),
        actions: [
          IconButton(
            onPressed: validateForm,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormInput(
                  controller: amountLimitController,
                  leading: const Text('Amount limit'),
                  type: Type.number,
                ),
                const SizedBox(height: 30),
                _budgetPeriod(),
                const SizedBox(height: 30),
                PaymentTile(
                  icon: const Icon(Icons.calendar_month),
                  title: 'Start Date',
                  value: Formatter.formatDate(startDate),
                  onPress: () => selectStartDate(context),
                ),
                const SizedBox(height: 8),
                PaymentTile(
                  icon: const Icon(Icons.calendar_month),
                  title: 'End Date',
                  value: Formatter.formatDate(endDate),
                  onPress: () => selectEndDate(context),
                ),
                const SizedBox(height: 8),
                PaymentTile(
                  icon: const Icon(Icons.account_balance_outlined),
                  title: 'Account',
                  value: account != null ? account!.name : '',
                  onPress: () => _selectAccount(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void selectStartDate(BuildContext context) async {
    final currentDate = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: currentDate,
      lastDate: DateTime(currentDate.year + 5),
      onDatePickerModeChange: (value) {},
    );

    if (pickedDate != null && pickedDate != startDate) {
      setState(() {
        startDate = pickedDate;
      });
    }
  }

  void selectEndDate(BuildContext context) async {
    final currentDate = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: currentDate,
      lastDate: DateTime(currentDate.year + 5),
      onDatePickerModeChange: (value) {},
    );

    if (pickedDate != null && pickedDate != endDate) {
      setState(() {
        endDate = pickedDate;
      });
    }
  }

  Widget _budgetPeriod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Budget Period',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        DropdownButtonHideUnderline(
          child: DropdownButton(
            dropdownColor: Theme.of(context).brightness == Brightness.dark
                ? kBlackColor
                : kWhiteColor,
            borderRadius: BorderRadius.circular(12),
            value: period,
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
              setState(() => period = newValue!);
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

  void validateForm() {
    final isValid = formKey.currentState!.validate();

    if (isValid) {
      final budget = Budget(
        id: widget.budget?.id,
        amountLimit: double.parse(amountLimitController.text),
        period: period,
        startDate: startDate,
        endDate: endDate,
        account: account!,
      );

      if (widget.isUpdating) {
        context.read<BudgetBloc>().add(UpdateBudgetEvent(budget: budget));
      } else {
        context.read<BudgetBloc>().add(AddBudgetEvent(budget: budget));
      }
      context.pop();
    }
  }
}
