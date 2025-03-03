import 'package:trackit/domain/repositories/notification_repository.dart';

class GetFcmTokenUsecase {
  NotificationRepository repository;

  GetFcmTokenUsecase({required this.repository});

  Future<String> call() async {
    return await repository.getFcmToken();
  }
}
