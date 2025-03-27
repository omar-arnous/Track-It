import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trackit/core/constants/colors.dart';

class OnboardingContent extends StatelessWidget {
  final String illustration, title, description;

  const OnboardingContent({
    super.key,
    required this.title,
    required this.description,
    required this.illustration,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: SvgPicture.asset(illustration),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .displayLarge!
              .copyWith(color: kGreyColor),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
