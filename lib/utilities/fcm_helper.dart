import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FcmHelper {
  static const _serverKey =
      'key=';

  static Future<void> saveFcmTokenLocally(String token) async {
    try {
      debugPrint('Start saving firebase token $token');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcm_token', token);
      debugPrint('Done saving firebase token $token');
    } catch (err) {
      debugPrint(err);
    }
  }

  static Future<String> getFirebaseToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('fcm_token');
  }

  static Future<void> sendNotification({
    String title,
    String body,
    String to,
    Map<String, dynamic> data = const {},
  }) async {
    final response = await post(
      'https://fcm.googleapis.com/fcm/send',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': _serverKey,
      },
      body: json.encode({
        'to': to,
        'notification': {
          'body': body,
          'title': title,
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        },
        'data': data
      }),
    );
    debugPrint(response.body);
  }
}
