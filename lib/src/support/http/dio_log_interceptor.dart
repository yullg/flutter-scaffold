import 'dart:convert';

import 'package:dio/dio.dart';

import '../../internal/scaffold_logger.dart';

const _kRequestBeginTime = "ScaffoldRequestBeginTime";

class DioLogInterceptor extends Interceptor {
  final void Function(String log) logPrint;

  final bool requestHeader;
  final bool requestBody;
  final bool responseHeader;
  final bool responseBody;

  const DioLogInterceptor({
    required this.logPrint,
    this.requestHeader = false,
    this.requestBody = true,
    this.responseHeader = false,
    this.responseBody = true,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_kRequestBeginTime] = DateTime.now();
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    try {
      final DateTime? beginTime = response.requestOptions.extra[_kRequestBeginTime];
      final duration = beginTime != null ? DateTime.now().difference(beginTime) : null;
      final sb = StringBuffer();
      sb.writeln(
        "${response.requestOptions.method} ${response.requestOptions.uri} → ${response.statusCode} (${duration?.inMilliseconds ?? '--'}ms)",
      );
      if (requestHeader) {
        sb.writeln("Request-Headers: ${jsonEncode(response.requestOptions.headers, toEncodable: _toJsonEncodable)}");
      }
      if (requestBody) {
        sb.writeln("Request-Body: ${_requestDataToString(response.requestOptions.data)}");
      }
      if (responseHeader) {
        sb.writeln("Response-Headers: ${jsonEncode(response.headers.map, toEncodable: _toJsonEncodable)}");
      }
      if (responseBody) {
        sb.writeln("Response-Body: ${_responseDataToString(response.data)}");
      }
      logPrint(sb.toString());
    } catch (e, s) {
      ScaffoldLogger().error(null, e, s);
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    try {
      final options = err.requestOptions;
      final DateTime? beginTime = options.extra[_kRequestBeginTime];
      final duration = beginTime != null ? DateTime.now().difference(beginTime) : null;
      final sb = StringBuffer();
      sb.writeln(
        "${options.method} ${options.uri} → ${err.response?.statusCode ?? 'ERROR'} (${duration?.inMilliseconds ?? '--'}ms)",
      );
      if (requestHeader) {
        sb.writeln("Request-Headers: ${jsonEncode(options.headers, toEncodable: _toJsonEncodable)}");
      }
      if (requestBody) {
        sb.writeln("Request-Body: ${_requestDataToString(options.data)}");
      }
      final response = err.response;
      if (response != null) {
        if (responseHeader) {
          sb.writeln("Response-Headers: ${jsonEncode(response.headers.map, toEncodable: _toJsonEncodable)}");
        }
        if (responseBody) {
          sb.writeln("Response-Body: ${_responseDataToString(response.data)}");
        }
      }
      sb.writeln("Error: $err");
      logPrint(sb.toString());
    } catch (e, s) {
      ScaffoldLogger().error(null, e, s);
    }
    handler.next(err);
  }

  Object? _toJsonEncodable(Object? nonEncodable) {
    return nonEncodable?.toString();
  }

  String? _requestDataToString(dynamic data) {
    if (data is FormData) {
      return jsonEncode(<String, dynamic>{
        "type": "FormData",
        "fields": <Map<String, String>>[
          ...data.fields.map((e) => <String, String>{e.key: e.value}),
        ],
        "files": <Map<String, dynamic>>[
          ...data.files.map(
            (e) => <String, dynamic>{
              "key": e.key,
              "filename": e.value.filename,
              "contentType": e.value.contentType?.toString(),
            },
          ),
        ],
      });
    }
    return data?.toString();
  }

  String? _responseDataToString(dynamic data) {
    return data?.toString();
  }
}
