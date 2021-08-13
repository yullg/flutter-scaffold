import 'dart:convert';

import '../app/security_manager.dart';
import '../core/scaffold_logger.dart';
import '../dal/local/authorization_local.dart';
import '../dal/remote/authorization_remote.dart';
import '../scaffold_module.dart';

class AuthorizationService {
  static final _authorizationLocal = AuthorizationLocal();
  static final _authorizationRemote = AuthorizationRemote();

  static Future<void> clientSignIn() async {
    try {
      var token = await _authorizationRemote.clientToken(
          clientId: ScaffoldModule.config.server_clientId,
          clientSecret: ScaffoldModule.config.server_clientSecret,
          scope: ScaffoldModule.config.server_scope);
      SecurityManager.authentication = Authentication(AuthenticationType.client, token);
    } catch (e, s) {
      ScaffoldLogger.error(null, e, s);
      rethrow;
    }
  }

  static Future<void> accountSignIn({required String username, required String password}) async {
    try {
      var token = await _authorizationRemote.accountToken(
          clientId: ScaffoldModule.config.server_clientId,
          clientSecret: ScaffoldModule.config.server_clientSecret,
          scope: ScaffoldModule.config.server_scope,
          username: username,
          password: password);
      await _authorizationLocal.deleteToken();
      await _authorizationLocal.insertToken(token);
      SecurityManager.authentication = Authentication(AuthenticationType.account, token);
    } catch (e, s) {
      ScaffoldLogger.error(null, e, s);
      rethrow;
    }
  }

  static Future<void> codeSignIn({required String receiver, required String code}) async {
    try {
      String password = jsonEncode({"client": ScaffoldModule.config.server_clientId, "receiver": receiver, "code": code});
      var token = await _authorizationRemote.accountToken(
          clientId: ScaffoldModule.config.server_clientId,
          clientSecret: ScaffoldModule.config.server_clientSecret,
          scope: ScaffoldModule.config.server_scope,
          username: "@",
          password: password);
      await _authorizationLocal.deleteToken();
      await _authorizationLocal.insertToken(token);
      SecurityManager.authentication = Authentication(AuthenticationType.account, token);
    } catch (e, s) {
      ScaffoldLogger.error(null, e, s);
      rethrow;
    }
  }

  static Future<void> refreshAuthorization() async {
    try {
      if (SecurityManager.clientAuthenticated) {
        var newToken = await _authorizationRemote.clientToken(
            clientId: ScaffoldModule.config.server_clientId,
            clientSecret: ScaffoldModule.config.server_clientSecret,
            scope: ScaffoldModule.config.server_scope);
        SecurityManager.authentication = Authentication(AuthenticationType.client, newToken);
      } else if (SecurityManager.accountAuthenticated) {
        var newToken = await _authorizationRemote.refreshToken(
            clientId: ScaffoldModule.config.server_clientId,
            clientSecret: ScaffoldModule.config.server_clientSecret,
            scope: SecurityManager.authentication!.token.scope,
            refreshToken: SecurityManager.authentication!.token.refreshToken!);
        await _authorizationLocal.deleteToken();
        await _authorizationLocal.insertToken(newToken);
        SecurityManager.authentication = Authentication(AuthenticationType.account, newToken);
      }
    } catch (e, s) {
      ScaffoldLogger.error(null, e, s);
      rethrow;
    }
  }

  static Future<void> tryAutoSignIn() async {
    try {
      var previousToken = await _authorizationLocal.findLatestToken();
      if (previousToken == null) return; // 没有登录记录
      var token = await _authorizationRemote.refreshToken(
          clientId: ScaffoldModule.config.server_clientId,
          clientSecret: ScaffoldModule.config.server_clientSecret,
          scope: previousToken.scope,
          refreshToken: previousToken.refreshToken!);
      await _authorizationLocal.deleteToken();
      await _authorizationLocal.insertToken(token);
      SecurityManager.authentication = Authentication(AuthenticationType.account, token);
    } catch (e, s) {
      ScaffoldLogger.error(null, e, s);
      rethrow;
    }
  }

  static Future<void> signOut() async {
    try {
      SecurityManager.authentication = null;
      await _authorizationLocal.deleteToken();
    } catch (e, s) {
      ScaffoldLogger.error(null, e, s);
      rethrow;
    }
  }

  AuthorizationService._();
}
