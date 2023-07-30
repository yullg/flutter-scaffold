class UriHelper {
  static bool equals(Uri uri,
          {String? scheme,
          String? userInfo,
          String? host,
          int? port,
          String? path,
          Iterable<String>? pathSegments,
          String? query,
          Map<String, dynamic>? queryParameters,
          String? fragment}) =>
      uri ==
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

  UriHelper._();
}
