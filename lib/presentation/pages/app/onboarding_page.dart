import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trackit/core/constants/colors.dart';
import 'package:trackit/core/constants/routes.dart';
import 'package:trackit/presentation/blocs/app/app_bloc.dart';
import 'package:trackit/presentation/pages/app/onboarding_content.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
          child: Column(
            children: [
              const Spacer(flex: 2),
              SizedBox(
                height: 600,
                child: PageView.builder(
                  onPageChanged: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  itemCount: onBoardingData.length,
                  itemBuilder: (context, index) {
                    final onBoardingItem = onBoardingData[index];
                    return OnboardingContent(
                      title: onBoardingItem['title'],
                      description: onBoardingItem['description'],
                      illustration: onBoardingItem['illustration'],
                    );
                  },
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  onBoardingData.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: AnimatedDot(
                      isActive: _selectedIndex == index ? true : false,
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 2),
              _getStartedButton(context),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedDot extends StatelessWidget {
  const AnimatedDot({
    super.key,
    required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 6,
      width: isActive ? 20 : 6,
      decoration: BoxDecoration(
        color: isActive ? kGreenColor : kGreyColor,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

Widget _getStartedButton(BuildContext context) {
  return ElevatedButton(
    onPressed: () {
      context.read<AppBloc>().add(
            const SetOnBoardingStateEvent(
              onboardingState: true,
            ),
          );
      context.go(kSignUpRoute);
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Get Started'.toUpperCase(),
        ),
        const Icon(Icons.arrow_right_alt),
      ],
    ),
  );
}

List<Map<String, dynamic>> onBoardingData = [
  {
    "title": "Track Your Spending Easily",
    "description":
        "Stay on top of your daily expenses and take control of your finances.",
    "illustration": "assets/onboarding-1.svg"
  },
  {
    "title": "Set Budgets, Reach Goals",
    "description":
        "Create weekly, monthly, or yearly budgets and get notified when you’re close to your limit.",
    "illustration": "assets/onboarding-2.svg"
  },
  {
    "title": "Visualize Your Progress",
    "description": "Analyze your spending with beautiful charts anytime.",
    "illustration": "assets/onboarding-3.svg"
  },
];
