import 'package:flutter/foundation.dart';

import '../bean/token.dart';

class SecurityManager {
  static AuthenticationNotifier? _authenticationNotifier;

  static Future<void> initialize() async {
    _authenticationNotifier = AuthenticationNotifier(null);
  }

  static AuthenticationNotifier get authenticationNotifier => _authenticationNotifier!;

  static set authentication(Authentication? authentication) => authenticationNotifier.value = authentication;

  static Authentication? get authentication => authenticationNotifier.value;

  static bool get authenticated => authentication != null;

  static bool get clientAuthenticated => authentication?.type == AuthenticationType.client;

  static bool get accountAuthenticated => authentication?.type == AuthenticationType.account;

  static String get requireCredential => authentication!.token.accessToken;

  static Future<void> destroy() async {
    _authenticationNotifier?.dispose();
    _authenticationNotifier = null;
  }

  SecurityManager._();
}

class AuthenticationNotifier extends ValueNotifier<Authentication?> {
  AuthenticationNotifier(Authentication? value) : super(value);
}

enum AuthenticationType { client, account }

class Authentication {
  final AuthenticationType type;
  final Token token;

  Authentication(this.type, this.token);

  @override
  String toString() {
    return 'Authentication{type: $type, token: $token}';
  }
}
