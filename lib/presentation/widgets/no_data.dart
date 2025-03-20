import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoData extends StatelessWidget {
  final String? message;
  const NoData({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    final Widget emptyStateWidget = SvgPicture.asset(
      "assets/empty.svg",
      semanticsLabel: 'Empty State',
      height: 200,
      width: double.infinity,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        emptyStateWidget,
        const SizedBox(height: 20),
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
