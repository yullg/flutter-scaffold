class ContextUnmountedError extends Error {
  final Object? message;

  ContextUnmountedError([this.message]);

  @override
  String toString() {
    return 'ContextUnmountedError{message: ${Error.safeToString(message)}}';
  }
}

class NoConfigurationError extends Error {
  final Object? message;

  NoConfigurationError([this.message]);

  @override
  String toString() {
    return 'NoConfigurationError{message: ${Error.safeToString(message)}}';
  }
}

class NoInitializeError extends Error {
  final Object? message;

  NoInitializeError([this.message]);

  @override
  String toString() {
    return 'NoInitializeError{message: ${Error.safeToString(message)}}';
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

class AuthenticationNotFoundError extends Error {
  final Object? message;

  AuthenticationNotFoundError({this.message});

  @override
  String toString() {
    return 'AuthenticationNotFoundError{message: ${Error.safeToString(message)}}';
  }
}

class IncorrectResultSizeDatabaseError extends Error {
  final Object? message;
  final int? expectedSize;
  final int? actualSize;

  IncorrectResultSizeDatabaseError({this.message, this.expectedSize, this.actualSize});

  @override
  String toString() {
    return 'IncorrectResultSizeDatabaseError{message: ${Error.safeToString(message)}, expectedSize: $expectedSize, actualSize: $actualSize}';
  }
}

class EmptyResultDatabaseError extends IncorrectResultSizeDatabaseError {
  EmptyResultDatabaseError({super.message, super.expectedSize});

  @override
  String toString() {
    return 'EmptyResultDatabaseError{message: ${Error.safeToString(message)}, expectedSize: $expectedSize}';
  }
}
