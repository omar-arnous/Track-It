import 'package:flutter/material.dart';

class NoData extends StatelessWidget {
  final String? message;
  const NoData({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Expanded(
        //   child: Image.asset(
        //     'assets/empty.png',
        //     width: double.infinity,
        //     height: MediaQuery.of(context).size.height * 0.2,
        //   ),
        // ),
        Text(
          message ?? '',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 16.0),
        Text(
          'Start adding one',
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }
}
