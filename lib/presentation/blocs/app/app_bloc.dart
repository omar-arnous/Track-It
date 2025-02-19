import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:trackit/domain/usecases/app/get_onboarding_state.dart';
import 'package:trackit/domain/usecases/app/get_theme.dart';
import 'package:trackit/domain/usecases/app/set_onboarding_state.dart';
import 'package:trackit/domain/usecases/app/set_theme.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final SetOnboardingStateUsecase setOnboardingState;
  final GetOnboardingStateUsecase getOnboardingState;
  final SetThemeUsecase setTheme;
  final GetThemeUsecase getTheme;

  static int currentIndex = 0;

  AppBloc({
    required this.setOnboardingState,
    required this.getOnboardingState,
    required this.setTheme,
    required this.getTheme,
  }) : super(InitialAppState()) {
    on<AppEvent>((event, emit) async {
      if (event is InitializeAppEvent ||
          event is GetOnBoardingStateEvent ||
          event is GetThemeEvent ||
          event is GetSelectedIndexEvent) {
        emit(LoadingAppState());
        final onBoardingState = await getOnboardingState();
        final isDark = await getTheme();
        emit(
          LoadedAppState(
            selectedIndex: currentIndex,
            onBoardingState: onBoardingState,
            isDark: isDark,
          ),
        );
      } else if (event is SetOnBoardingStateEvent) {
        await setOnboardingState(event.onboardingState);
        add(GetOnBoardingStateEvent());
      } else if (event is SetIsDarkTheme) {
        emit(LoadingAppState());
        await setTheme(event.isDark);
        add(GetThemeEvent());
      } else if (event is SetSelectedIndexEvent) {
        currentIndex = event.selectedIndex;
        add(GetSelectedIndexEvent());
      }
    });
  }
}
