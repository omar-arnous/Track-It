import 'package:trackit/domain/repositories/app_repository.dart';

class GetOnboardingStateUsecase {
  final AppRepository repository;

  GetOnboardingStateUsecase({required this.repository});

  Future<bool> call() async {
    return await repository.getOnBoardingState();
  }
}
