part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class InitializeAppEvent extends AppEvent {}

class SetOnBoardingStateEvent extends AppEvent {
  final bool onboardingState;

  const SetOnBoardingStateEvent({required this.onboardingState});

  @override
  List<Object?> get props => [onboardingState];
}

class GetOnBoardingStateEvent extends AppEvent {}

class SetIsDarkTheme extends AppEvent {
  final bool isDark;

  const SetIsDarkTheme({required this.isDark});

  @override
  List<Object?> get props => [isDark];
}

class GetThemeEvent extends AppEvent {}

class SetSelectedIndexEvent extends AppEvent {
  final int selectedIndex;

  const SetSelectedIndexEvent({required this.selectedIndex});

  @override
  List<Object?> get props => [selectedIndex];
}

class GetSelectedIndexEvent extends AppEvent {}
