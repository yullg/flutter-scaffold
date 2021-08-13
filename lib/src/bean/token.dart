class Token {
  final int? id;
  final String tokenType;
  final String accessToken;
  final String? refreshToken;
  final int expiresIn;
  final String scope;
  final String jti;
  final DateTime time;

  Token({
    this.id,
    required this.tokenType,
    required this.accessToken,
    this.refreshToken,
    required this.expiresIn,
    required this.scope,
    required this.jti,
    required this.time,
  });

  @override
  String toString() {
    return 'Token{id: $id, tokenType: $tokenType, accessToken: $accessToken, refreshToken: $refreshToken, expiresIn: $expiresIn, scope: $scope, jti: $jti, time: $time}';
  }
}
