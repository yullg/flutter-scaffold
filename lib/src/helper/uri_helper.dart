class UriHelper {
  static Uri basic(Uri uri) => Uri(
        scheme: uri.scheme,
        host: uri.host,
        port: uri.port,
        path: uri.path,
      );

  static bool equals(Uri uri,
      {String? scheme,
      String? userInfo,
      String? host,
      int? port,
      String? path,
      Iterable<String>? pathSegments,
      String? query,
      Map<String, dynamic>? queryParameters,
      String? fragment}) {
    return uri ==
        uri.replace(
            scheme: scheme,
            userInfo: userInfo,
            host: host,
            port: port,
            path: path,
            pathSegments: pathSegments,
            query: query,
            queryParameters: queryParameters,
            fragment: fragment);
  }

  UriHelper._();
}
