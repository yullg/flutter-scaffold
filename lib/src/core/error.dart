class ContextUnmountedError extends Error {
  final Object? message;

  ContextUnmountedError([this.message]);

  @override
  String toString() {
    return 'ContextUnmountedError{message: ${Error.safeToString(message)}}';
  }
}

class CancellationError extends Error {
  final Object? message;

  CancellationError([this.message]);

  @override
  String toString() {
    return 'CancellationError{message: ${Error.safeToString(message)}}';
  }
}

class MissingConfigurationError extends Error {
  final Object? message;

  MissingConfigurationError([this.message]);

  @override
  String toString() {
    return 'MissingConfigurationError{message: ${Error.safeToString(message)}}';
  }
}
