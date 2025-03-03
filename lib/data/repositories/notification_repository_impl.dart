import 'package:trackit/data/datasources/notification/firebase_messaging_data_source.dart';
import 'package:trackit/data/models/notification_model.dart';
import 'package:trackit/domain/entities/notification.dart';
import 'package:trackit/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final FirebaseMessagingDataSource dataSource;

  NotificationRepositoryImpl({required this.dataSource});

  @override
  Future<String> getFcmToken() async {
    return await dataSource.getFcmToken();
  }

  @override
  Future<void> sendNotification(Notification notification) async {
    final notificationModel = NotificationModel(
      title: notification.title,
      body: notification.body,
      token: notification.token,
    );

    await dataSource.sendNotification(notificationModel);
  }
}
