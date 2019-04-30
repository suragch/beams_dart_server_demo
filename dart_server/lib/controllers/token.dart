// dart_server/lib/controllers/token.dart

import 'dart:async';
import 'package:aqueduct/aqueduct.dart';
import 'package:pusher_beams_server/pusher_beams_server.dart';
import 'package:dart_server/config.dart';

class TokenController extends ResourceController {
  PushNotifications beamsClient;

  // give a Pusher Beams auth token back to an authorized user
  @Operation.get()
  Future<Response> generateBeamsTokenForUser() async {
    
    // get the username from the already authenticated credentials
    final username = request.authorization.credentials.username;
    
    // generate the token for the user
    beamsClient ??= PushNotifications(Properties.instanceId, Properties.secretKey);
    final token = beamsClient.generateToken(username);

    // return the token to the user
    return Response.ok({'token':token});
  }
}
