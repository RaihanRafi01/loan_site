import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'fcm_service.dart'; // Assuming FCMService is in a separate file

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Singleton pattern
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // Request notification permission from the user
  Future<bool> requestNotificationPermission() async {
    try {
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        print('Notification permission granted');
        return true;
      } else {
        print('Notification permission denied');
        return false;
      }
    } catch (e) {
      print('Error requesting notification permission: $e');
      return false;
    }
  }

  // Optionally, show a dialog to prompt the user to enable notifications
  Future<void> showNotificationPrompt(BuildContext context) async {
    bool hasPermission = await requestNotificationPermission();

    if (!hasPermission) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Enable Notifications'),
              content: const Text(
                'Would you like to receive notifications for updates and alerts?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    // Retry requesting permission
                    await requestNotificationPermission();
                  },
                  child: const Text('Enable'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  // Initialize notification settings and listeners
  Future<void> initializeNotifications() async {
    // Request permission when initializing
    await requestNotificationPermission();

    // Handle foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received foreground notification: ${message.notification?.title}');
      // Add custom handling for foreground notifications here
    });

    // Handle background notifications
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // Background message handler
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print('Handling background message: ${message.notification?.title}');
    // Add custom handling for background notifications here
  }
}