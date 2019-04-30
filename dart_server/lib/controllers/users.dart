// dart_server/lib/controllers/users.dart

import 'dart:async';
import 'dart:io';
import 'package:aqueduct/aqueduct.dart';
import 'package:pusher_beams_server/pusher_beams_server.dart';
import 'package:dart_server/config.dart';

class UsersController extends ResourceController {
  PushNotifications beamsClient;

  // send push notification to Mary
  @Operation.post()
  Future<Response> notifyAuthenticatedUsers() async {
    beamsClient ??=
        PushNotifications(Properties.instanceId, Properties.secretKey);

    const title = 'Purchase';
    const message = 'Hello, Mary. Your purchase of apples will be delivered shortly.';

    final apns = {
      'aps': {
        'alert': {
          'title': title,
          'body': message,
        }
      }
    };
    final fcm = {
      'notification': {
        'title': title,
        'body':
            message,
      }
    };
    final response = await beamsClient.publishToUsers(
      ['Mary'],
      apns: apns,
      fcm: fcm,
    );
    
    return Response.ok(response.body)..contentType = ContentType.text;
  }
}
