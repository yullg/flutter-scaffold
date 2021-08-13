class ClientConfiguration {
  final dynamic data;
  final int? forceLeastClientVersionCode;
  final String? welcomeImage;

  ClientConfiguration(this.data, {this.forceLeastClientVersionCode, this.welcomeImage});

  @override
  String toString() {
    return 'ClientConfiguration{$data}';
  }
}
