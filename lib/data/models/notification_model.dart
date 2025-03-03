import 'package:trackit/domain/entities/notification.dart';

class NotificationModel extends Notification {
  NotificationModel({
    required super.title,
    required super.body,
    required super.token,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title'],
      body: json['body'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "body": body,
      "token": token,
    };
  }
}
