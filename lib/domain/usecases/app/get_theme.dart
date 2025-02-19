import 'package:trackit/domain/repositories/app_repository.dart';

class GetThemeUsecase {
  final AppRepository repository;

  GetThemeUsecase({required this.repository});

  Future<bool> call() async {
    return await repository.getTheme();
  }
}
