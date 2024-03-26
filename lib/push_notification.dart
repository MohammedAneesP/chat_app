import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotification {
  static Future getFcmPermission() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

// For apple platforms, ensure the APNS token is available before making any FCM plugin API calls
    final apnsToken = await FirebaseMessaging.instance.getToken();
    if (apnsToken != null) {
      log(apnsToken.toString());
    }
  }
}
