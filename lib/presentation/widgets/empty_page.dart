import 'package:flutter/material.dart';

class EmptyPage extends StatelessWidget {
  final String? message;
  const EmptyPage({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          message ?? '',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
