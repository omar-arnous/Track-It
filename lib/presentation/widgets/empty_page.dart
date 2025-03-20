import 'package:flutter/material.dart';

class EmptyPage extends StatelessWidget {
  final String? message;
  const EmptyPage({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            message ?? '',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16.0),
          Text(
            'Start adding one',
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
