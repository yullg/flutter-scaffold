import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../bean/token.dart';
import '../../core/exceptions.dart';
import '../../core/remote_server.dart';

class AuthorizationRemote with RemoteServer {
  Future<Token> clientToken({required String clientId, required String clientSecret, required String scope}) async {
    var response = await http.post(
      serverUri("/authorization/oauth/token"),
      headers: {"Authorization": "Basic ${base64Encode('$clientId:$clientSecret'.codeUnits)}"},
      body: {"grant_type": "client_credentials", "scope": scope},
    );
    if (response.statusCode == 200) {
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      return Token(
          tokenType: json["token_type"],
          accessToken: json["access_token"],
          expiresIn: json["expires_in"],
          scope: json["scope"],
          jti: json["jti"],
          time: DateTime.now());
    }
    throw RemoteException(null, null, responseToMap(response));
  }

  Future<Token> accountToken(
      {required String clientId, required String clientSecret, required String scope, required String username, required String password}) async {
    var response = await http.post(
      serverUri("/authorization/oauth/token"),
      headers: {"Authorization": "Basic ${base64Encode('$clientId:$clientSecret'.codeUnits)}"},
      body: {"grant_type": "password", "username": username, "password": password, "scope": scope},
    );
    if (response.statusCode == 200) {
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      return Token(
          tokenType: json["token_type"],
          accessToken: json["access_token"],
          refreshToken: json["refresh_token"],
          expiresIn: json["expires_in"],
          scope: json["scope"],
          jti: json["jti"],
          time: DateTime.now());
    }
    throw RemoteException(null, null, responseToMap(response));
  }

  Future<Token> refreshToken({required String clientId, required String clientSecret, required String scope, required String refreshToken}) async {
    var response = await http.post(
      serverUri("/authorization/oauth/token"),
      headers: {"Authorization": "Basic ${base64Encode('$clientId:$clientSecret'.codeUnits)}"},
      body: {"grant_type": "refresh_token", "refresh_token": refreshToken, "scope": scope},
    );
    if (response.statusCode == 200) {
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      return Token(
          tokenType: json["token_type"],
          accessToken: json["access_token"],
          refreshToken: json["refresh_token"],
          expiresIn: json["expires_in"],
          scope: json["scope"],
          jti: json["jti"],
          time: DateTime.now());
    }
    throw RemoteException(null, null, responseToMap(response));
  }
}
