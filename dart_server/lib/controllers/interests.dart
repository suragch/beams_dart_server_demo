// dart_server/lib/controllers/interests.dart

import 'dart:async';
import 'dart:io';
import 'package:aqueduct/aqueduct.dart';
import 'package:pusher_beams_server/pusher_beams_server.dart';
import 'package:dart_server/config.dart';

class InterestsController extends ResourceController {
  PushNotifications beamsClient;

  // send push notifications to users who are subscribed to the interest
  @Operation.post()
  Future<Response> notifyInterestedUsers() async {
    beamsClient ??=
        PushNotifications(Properties.instanceId, Properties.secretKey);

    const title = 'Sale';
    const message = 'Apples are 50% off today!';

    final fcm = {
      'notification': {
        'title': title,
        'body': message,
      }
    };
    final apns = {
      'aps': {
        'alert': {
          'title': title,
          'body': message,
        }
      }
    };
    final response = await beamsClient.publishToInterests(
      ['apples'],
      apns: apns,
      fcm: fcm,
    );

    return Response.ok(response.body)..contentType = ContentType.text;
  }
}
