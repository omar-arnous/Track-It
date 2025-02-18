abstract class AppRepository {
  Future<void> setOnBoardingState(bool state);
  Future<void> setTheme(bool isDark);
  Future<bool> getOnBoardingState();
  Future<bool> getTheme();
}
