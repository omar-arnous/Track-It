import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:trackit/data/models/notification_model.dart';

class FirebaseMessagingDataSource {
  final FirebaseMessaging firebaseMessaging;
  final String _serverKey = "AIzaSyDtXlxNHM-KWpIY80zcsxzpllwvje7QiPI";

  FirebaseMessagingDataSource({required this.firebaseMessaging});

  Future<String> getFcmToken() async {
    final res = await firebaseMessaging.getToken();
    if (res != null) {
      return res;
    }

    return "";
  }

  Future<void> sendNotification(NotificationModel notification) async {
    final url = Uri.parse("https://fcm.googleapis.com/fcm/send");

    final Map<String, dynamic> body = {
      "to": notification.token,
      "notification": {
        "title": notification.title,
        "body": notification.body,
      },
    };

    await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "key=$_serverKey",
      },
      body: jsonEncode(body),
    );
  }
}
