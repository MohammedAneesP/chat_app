import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

Future sendNotification({
  required String token,
  required String message,
  required String senderEmail,
  required String senderName,
}) async {
  final url = Uri.parse('https://fcm.googleapis.com/fcm/send');
  const serverKey =
      'AAAAZ0SAY24:APA91bF2i6NOIbqUGmeIqJHEQCEHtMQN_fcL7P19KQGbZke3ZLgJWSK3DAYyJrTsiyzizKf8rOuyj8MIj9JdM0SWZC7gTA0yt25jXKwO2V_bV1PLhHY2NDQKmQ-sy_B9EgCU5YpcqUCz';

  final headers = <String, String>{
    'Content-Type': 'application/json',
    'Authorization': 'key=$serverKey',
  };

  final payload = {
    'notification': {
      'title': message,
      'body': senderEmail,
    },
    'priority': 'high', // Set priority for better delivery
    'data': {
      // Optional data payload for your app
      'click_action': 'FLUTTER_NOTIFICATION_CLICK', // Custom action on tap
      "email": senderEmail
    },
    'to': token,
  };
  final response =
      await http.post(url, headers: headers, body: jsonEncode(payload));

  if (response.statusCode == 200) {
    log(response.body.toString());
    log('Notification sent successfully!');
  } else {
    log('Failed to send notification. Error: ${response.body}');
  }
}
