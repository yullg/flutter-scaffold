import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../app/security_manager.dart';
import '../bll/authorization_service.dart';
import '../core/scaffold_logger.dart';

export 'package:http/http.dart' show Response;

Future<http.Response> head(Uri url, {Map<String, String>? headers}) => _withClient((client) => client.head(url, headers: headers));

Future<http.Response> get(Uri url, {Map<String, String>? headers}) => _withClient((client) => client.get(url, headers: headers));

Future<http.Response> post(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
    _withClient((client) => client.post(url, headers: headers, body: body, encoding: encoding));

Future<http.Response> put(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
    _withClient((client) => client.put(url, headers: headers, body: body, encoding: encoding));

Future<http.Response> patch(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
    _withClient((client) => client.patch(url, headers: headers, body: body, encoding: encoding));

Future<http.Response> delete(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
    _withClient((client) => client.delete(url, headers: headers, body: body, encoding: encoding));

Future<String> read(Uri url, {Map<String, String>? headers}) => _withClient((client) => client.read(url, headers: headers));

Future<Uint8List> readBytes(Uri url, {Map<String, String>? headers}) => _withClient((client) => client.readBytes(url, headers: headers));

Future<T> _withClient<T>(Future<T> Function(AuthorizationClient) fn) async {
  var client = AuthorizationClient();
  try {
    return await fn(client);
  } finally {
    client.close();
  }
}

class AuthorizationClient extends http.BaseClient {
  final http.Client _client = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    await _maybeRefreshAuthorization().catchError((e) {});
    if (SecurityManager.authenticated) {
      request.headers["Authorization"] = "Bearer ${SecurityManager.requireCredential}";
    }
    return _client.send(request);
  }

  @override
  void close() => _client.close();
}

Completer<void>? _completer;

Future<void> _maybeRefreshAuthorization() async {
  Authentication? authentication = SecurityManager.authentication;
  if (authentication == null) return; // 没有认证 跳过
  DateTime expiresDateTime = authentication.token.time.add(Duration(seconds: authentication.token.expiresIn));
  if (expiresDateTime.difference(DateTime.now()) > const Duration(minutes: 5)) return; // 没有过期 跳过
  Completer<void>? completer = _completer;
  if (completer != null) return completer.future; // 正在刷新 合并
  _completer = completer = Completer<void>();
  try {
    ScaffoldLogger.info("Ready to refresh authorization : OldAuthentication = ${SecurityManager.authentication}");
    await AuthorizationService.refreshAuthorization();
    ScaffoldLogger.info("Refresh authorization succeed : NewAuthentication = ${SecurityManager.authentication}");
    completer.complete();
  } catch (e, s) {
    completer.completeError(e, s);
    ScaffoldLogger.error("Refresh authorization failed", e, s);
    rethrow;
  } finally {
    _completer = null;
  }
}
