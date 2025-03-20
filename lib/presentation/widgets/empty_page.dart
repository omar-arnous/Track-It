import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyPage extends StatelessWidget {
  final String? message;
  const EmptyPage({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    final Widget emptyStateWidget = SvgPicture.asset(
      "assets/empty.svg",
      semanticsLabel: 'Empty State',
    );

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: emptyStateWidget),
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
