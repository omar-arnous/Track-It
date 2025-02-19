import 'package:trackit/domain/repositories/app_repository.dart';

class SetThemeUsecase {
  final AppRepository repository;

  SetThemeUsecase({required this.repository});

  Future<void> call(bool isDark) async {
    return await repository.setTheme(isDark);
  }
}
