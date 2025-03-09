import 'package:flutter/material.dart';
import 'package:trackit/core/constants/colors.dart';

class TransactionTypeWidget extends StatelessWidget {
  final TabController controller;
  final Function(int value) onPress;
  const TransactionTypeWidget({
    super.key,
    required this.controller,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? kBlackColor
            : kWhiteColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: controller,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? kWhiteColor
              : kBlackColor,
          borderRadius: BorderRadius.circular(8),
        ),
        dividerColor: Colors.transparent,
        labelColor: Theme.of(context).brightness == Brightness.dark
            ? kBlackColor
            : kWhiteColor,
        unselectedLabelColor: Theme.of(context).brightness == Brightness.dark
            ? kWhiteColor
            : kBlackColor,
        labelPadding: EdgeInsets.zero,
        onTap: onPress,
        tabs: const [
          Tab(
            text: 'EXPENSE',
          ),
          Tab(
            text: 'INCOME',
          ),
          Tab(
            text: 'TRANSFER',
          ),
        ],
      ),
    );
  }
}
