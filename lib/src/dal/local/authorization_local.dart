import '../../app/database_manager.dart';
import '../../bean/token.dart';

class AuthorizationLocal {
  Future<void> insertToken(Token token) async {
    await DatabaseManager.database.insert("tb_token", {
      "token_type": token.tokenType,
      "access_token": token.accessToken,
      "refresh_token": token.refreshToken,
      "expires_in": token.expiresIn,
      "scope": token.scope,
      "jti": token.jti,
      "time": token.time.millisecondsSinceEpoch,
    });
  }

  Future<void> deleteToken() async {
    await DatabaseManager.database.delete("tb_token");
  }

  Future<Token?> findLatestToken() async {
    var rows = await DatabaseManager.database.query("tb_token", orderBy: "time DESC", limit: 1);
    if (rows.isNotEmpty) {
      var row = rows.first;
      return Token(
          id: row["id"] as int,
          tokenType: row["token_type"] as String,
          accessToken: row["access_token"] as String,
          refreshToken: row["refresh_token"] as String?,
          expiresIn: row["expires_in"] as int,
          scope: row["scope"] as String,
          jti: row["jti"] as String,
          time: DateTime.fromMillisecondsSinceEpoch(row["time"] as int));
    }
    return null;
  }
}
