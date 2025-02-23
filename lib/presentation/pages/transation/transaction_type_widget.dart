import 'package:flutter/material.dart';

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
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: controller,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black,
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
