class ClientVersion {
  final String versionName;
  final int versionCode;
  final List<String> changelog;
  final String? downloadLink;
  final DateTime time;
  final bool ignorable;

  ClientVersion(
      {required this.versionName,
      required this.versionCode,
      required this.changelog,
      this.downloadLink,
      required this.time,
      required this.ignorable});

  @override
  String toString() {
    return 'ClientVersion{versionName: $versionName, versionCode: $versionCode, changelog: $changelog, downloadLink: $downloadLink, time: $time, ignorable: $ignorable}';
  }
}
