import 'package:trackit/domain/repositories/auth_repository.dart';

class ResetPasswordUsecase {
  final AuthRepository repository;

  ResetPasswordUsecase({required this.repository});

  Future<void> call(String email) async {
    return await repository.resetPassword(email);
  }
}
