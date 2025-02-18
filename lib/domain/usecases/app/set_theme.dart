import 'package:trackit/domain/repositories/app_repository.dart';

class SetTheme {
  final AppRepository repository;

  SetTheme({required this.repository});

  Future<void> call(bool isDark) async {
    return await repository.setTheme(isDark);
  }
}
