import 'package:trackit/domain/entities/notification.dart';
import 'package:trackit/domain/repositories/notification_repository.dart';

class SendNotification {
  NotificationRepository repository;

  SendNotification({required this.repository});

  Future<void> call(Notification notification) async {
    return await repository.sendNotification(notification);
  }
}
