import 'dart:io';
import 'dart:typed_data';

sealed class Resource {
  const Resource();

  factory Resource.file(File file) = FileResource;

  factory Resource.uri(Uri uri) = UriResource;

  factory Resource.bytes(Uint8List bytes) = BytesResource;
}

class FileResource extends Resource {
  final File file;

  FileResource(this.file);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is FileResource && runtimeType == other.runtimeType && file == other.file;

  @override
  int get hashCode => file.hashCode;

  @override
  String toString() {
    return 'FileResource{file: $file}';
  }
}

class UriResource extends Resource {
  final Uri uri;

  UriResource(this.uri);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is UriResource && runtimeType == other.runtimeType && uri == other.uri;

  @override
  int get hashCode => uri.hashCode;

  @override
  String toString() {
    return 'UriResource{uri: $uri}';
  }
}

class BytesResource extends Resource {
  final Uint8List bytes;

  const BytesResource(this.bytes);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is BytesResource && runtimeType == other.runtimeType && bytes == other.bytes;

  @override
  int get hashCode => bytes.hashCode;

  @override
  String toString() {
    return 'BytesResource{bytes: $bytes}';
  }
}
