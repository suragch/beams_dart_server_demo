// dart_server/lib/channel.dart

import 'package:dart_server/controllers/auth.dart';
import 'package:dart_server/controllers/token.dart';
import 'package:dart_server/controllers/interests.dart';
import 'package:dart_server/controllers/users.dart';
import 'dart_server.dart';

class DartServerChannel extends ApplicationChannel {

  // These middleware validators will check the username 
  // and passwords before allowing the user to go on.
  BasicValidator normalUserValidator;
  AdminValidator adminValidator;

  @override
  Future prepare() async {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
    normalUserValidator = BasicValidator();
    adminValidator = AdminValidator();
  }

  @override
  Controller get entryPoint {
    final router = Router();

    // user app will get a Pusher auth token here
    router
        .route('/token')
        .link(() => Authorizer.basic(normalUserValidator))
        .link(() => TokenController());

    // admin app will send push notifications for interests here
    router
        .route('/admin/interests')
        .link(() => Authorizer.basic(adminValidator))
        .link(() => InterestsController());

    // admin app will send push notifications to users here
    router
        .route('/admin/users')
        .link(() => Authorizer.basic(adminValidator))
        .link(() => UsersController());

    return router;
  }
}
