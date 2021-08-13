import 'dart:convert';

import '../scaffold_module.dart';
import 'authorization_http.dart' as http;
import 'exceptions.dart';

mixin RemoteServer {
  Uri serverUri(String path) {
    return Uri.parse(ScaffoldModule.config.server_baseUrl + path);
  }

  Future<dynamic> serverGet(String path, {Map<String, String>? headers, Map<String, dynamic>? queryParameters}) async {
    Uri uri = serverUri(path);
    uri = uri.replace(queryParameters: {
      ...uri.queryParameters,
      ...?queryParameters?.map<String, String>((key, value) => MapEntry(key, value?.toString() ?? "")),
    });
    var response = await http.get(uri, headers: headers);
    return _extractBody(response);
  }

  Future<dynamic> serverPost(String path, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    var response = await http.post(serverUri(path), headers: headers, body: body, encoding: encoding);
    return _extractBody(response);
  }

  Future<dynamic> serverDelete(String path, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    var response = await http.delete(serverUri(path), headers: headers, body: body, encoding: encoding);
    return _extractBody(response);
  }

  Map<String, dynamic> responseToMap(http.Response response) => {
        "statusCode": response.statusCode,
        "reasonPhrase": response.reasonPhrase,
        "body": utf8.decode(response.bodyBytes),
      };

  dynamic _extractBody(http.Response response) {
    if (response.statusCode == 200) {
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      if (json["code"] == 0) {
        return json["data"];
      } else {
        throw RemoteException(json["code"], json["message"], responseToMap(response));
      }
    } else {
      throw RemoteException(null, null, responseToMap(response));
    }
  }
}
