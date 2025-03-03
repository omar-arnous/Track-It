import 'package:trackit/domain/entities/notification.dart';

abstract class NotificationRepository {
  Future<String> getFcmToken();
  Future<void> sendNotification(Notification notification);
}
