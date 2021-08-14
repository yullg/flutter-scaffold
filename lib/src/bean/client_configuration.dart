class ClientConfiguration {
  final dynamic data;
  final String? welcomeImage;

  ClientConfiguration(this.data, {this.welcomeImage});

  @override
  String toString() {
    return 'ClientConfiguration{$data}';
  }
}
