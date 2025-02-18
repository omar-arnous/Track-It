import 'package:trackit/domain/repositories/app_repository.dart';

class SetOnboardingState {
  final AppRepository repository;

  SetOnboardingState({required this.repository});

  Future<void> call(bool state) async {
    return await repository.setOnBoardingState(state);
  }
}
