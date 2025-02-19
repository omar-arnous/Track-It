import 'package:trackit/domain/repositories/app_repository.dart';

class SetOnboardingStateUsecase {
  final AppRepository repository;

  SetOnboardingStateUsecase({required this.repository});

  Future<void> call(bool state) async {
    return await repository.setOnBoardingState(state);
  }
}
