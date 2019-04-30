// dart_server/lib/controllers/auth.dart

import 'dart:async';
import 'package:aqueduct/aqueduct.dart';

// Hardcoding username and passwords both here and in client apps
// admin: password123
// Mary: mypassword
// hash generated with AuthUtility.generatePasswordHash()
//
// a production app would have these in a database
final Map<String, User> adminUsers = {
  'admin': User(
      username: 'admin',
      saltedPasswordHash: 'ntQLWWIu/nubfZhCEy9sXgwRijuBV+d9ZN2Id3hTLbs=',
      salt: 'mysalt1'),
};
final Map<String, User> normalUsers = {
  'Mary': User(
      username: 'Mary',
      saltedPasswordHash: 'JV0R5CH9mnA6rcOGnkzSvIeGkHUvtnnvUCuFBc3XD+4=',
      salt: 'mysalt2'),
};

class User {
  User({this.username, this.saltedPasswordHash, this.salt});

  String username;
  String saltedPasswordHash;
  String salt;
}

class BasicValidator implements AuthValidator {
  final _requireAdminPriveleges = false;

  @override
  FutureOr<Authorization> validate<T>(
      AuthorizationParser<T> parser, T authorizationData,
      {List<AuthScope> requiredScope}) {
    // Get the parsed username and password from the basic
    // authentication header.
    final credentials = authorizationData as AuthBasicCredentials;

    // check if user exists
    User user;
    if (_requireAdminPriveleges) {
      user = adminUsers[credentials.username];
    } else {
      user = normalUsers[credentials.username];
    }
    if (user == null) {
      return null;
    }

    // check if password matches
    final hash =
        AuthUtility.generatePasswordHash(credentials.password, user.salt);
    if (user.saltedPasswordHash == hash) {
      return Authorization(null, null, this, credentials: credentials);
    }

    // returns a 401 Unauthorized
    return null;
  }

  // This is for OpenAPI documentation. Ignoring for now.
  @override
  List<APISecurityRequirement> documentRequirementsForAuthorizer(
      APIDocumentContext context, Authorizer authorizer,
      {List<AuthScope> scopes}) {
    return null;
  }
}

class AdminValidator extends BasicValidator {
  @override
  bool get _requireAdminPriveleges => true;
}
