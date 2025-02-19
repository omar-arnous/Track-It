part of 'app_bloc.dart';

abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object?> get props => [];
}

class InitialAppState extends AppState {}

class LoadingAppState extends AppState {}

class LoadedAppState extends AppState {
  final bool onBoardingState;
  final bool isDark;
  final int selectedIndex;

  const LoadedAppState({
    required this.selectedIndex,
    required this.onBoardingState,
    required this.isDark,
  });

  @override
  List<Object?> get props => [selectedIndex, onBoardingState, isDark];
}
