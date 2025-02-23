import 'package:flutter/material.dart';

class NoData extends StatelessWidget {
  final String? message;
  const NoData({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Text(
      message ?? '',
      style: Theme.of(context).textTheme.labelLarge,
    );
  }
}
