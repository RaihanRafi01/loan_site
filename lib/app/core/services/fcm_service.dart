import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:loan_site/app/core/services/base_client.dart';
import 'dart:convert';

import '../constants/api.dart';

class FCMService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Singleton pattern to ensure a single instance of the service
  static final FCMService _instance = FCMService._internal();
  factory FCMService() => _instance;
  FCMService._internal();

  // Method to fetch the FCM token
  Future<String?> setFCMToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        await _sendTokenToServer(token);
        print('----🏷️🏷️🏷️🏷️🏷️-->>>>>>>>>>>>> FCM Token: $token'); // Debug log
      }
    } catch (e) {
      print('Error fetching FCM token: $e');
      return null;
    }
    return null;
  }

  Future<void> _sendTokenToServer(String token) async {

    try {
      final body = jsonEncode({
        "device_token": token,
        "device_type": "android"
      });
      print('device_token: $token');
      await BaseClient.postRequest(
        api: Api.registerDeviceToken,
        body: body,
        headers: BaseClient.authHeaders(),
      );

    } catch (e) {
      print('Sign-in error: $e');
    }
  }
}