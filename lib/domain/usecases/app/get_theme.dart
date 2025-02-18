import 'package:trackit/domain/repositories/app_repository.dart';

class GetTheme {
  final AppRepository repository;

  GetTheme({required this.repository});

  Future<bool> call() async {
    return await repository.getTheme();
  }
}
