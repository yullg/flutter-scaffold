class UriHelper {
  static Uri merge(Uri uri,
          {String? scheme,
          String? userInfo,
          String? host,
          int? port,
          String? path,
          Map<String, dynamic>? queryParameters,
          String? fragment}) =>
      Uri(
        scheme: scheme ?? uri.scheme,
        userInfo: userInfo ?? uri.userInfo,
        host: host ?? uri.host,
        port: port ?? uri.port,
        path: path ?? uri.path,
        queryParameters: {
          ...uri.queryParameters,
          ...?queryParameters,
        },
        fragment: fragment ?? uri.fragment,
      );

  UriHelper._();
}
