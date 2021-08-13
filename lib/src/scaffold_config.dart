class ScaffoldConfig {
  final String database_name;
  final int database_version;
  final String server_baseUrl;
  final String server_clientId;
  final String server_clientSecret;
  final String server_scope;

  ScaffoldConfig(
      {required this.database_name,
      required this.database_version,
      required this.server_baseUrl,
      required this.server_clientId,
      required this.server_clientSecret,
      required this.server_scope});

  ScaffoldConfig.map(Map<String, dynamic> map)
      : this.database_name = map["database"]["name"],
        this.database_version = map["database"]["version"],
        this.server_baseUrl = map["server"]["baseUrl"],
        this.server_clientId = map["server"]["clientId"],
        this.server_clientSecret = map["server"]["clientSecret"],
        this.server_scope = map["server"]["scope"];
}
