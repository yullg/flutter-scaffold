abstract interface class VisibleError {
  dynamic get visual;
}

class ContextUnmountedError extends Error implements VisibleError {
  final Object? message;
  @override
  final dynamic visual;

  ContextUnmountedError([this.message, this.visual]);

  @override
  String toString() {
    return 'ContextUnmountedError{message: ${Error.safeToString(message)}}';
  }
}

class CancellationError extends Error implements VisibleError {
  final Object? message;
  @override
  final dynamic visual;

  CancellationError([this.message, this.visual]);

  @override
  String toString() {
    return 'CancellationError{message: ${Error.safeToString(message)}}';
  }
}

class AuthenticationNotFoundError extends Error implements VisibleError {
  final Object? message;
  @override
  final dynamic visual;

  AuthenticationNotFoundError([this.message, this.visual]);

  @override
  String toString() {
    return 'AuthenticationNotFoundError{message: ${Error.safeToString(message)}}';
  }
}

class IncorrectResultSizeDatabaseError extends Error implements VisibleError {
  final Object? message;
  final int? expectedSize;
  final int? actualSize;
  @override
  final dynamic visual;

  IncorrectResultSizeDatabaseError({this.message, this.expectedSize, this.actualSize, this.visual});

  @override
  String toString() {
    return 'IncorrectResultSizeDatabaseError{message: ${Error.safeToString(message)}, expectedSize: $expectedSize, actualSize: $actualSize}';
  }
}

class EmptyResultDatabaseError extends IncorrectResultSizeDatabaseError {
  EmptyResultDatabaseError({super.message, super.expectedSize, super.visual});

  @override
  String toString() {
    return 'EmptyResultDatabaseError{message: ${Error.safeToString(message)}, expectedSize: $expectedSize}';
  }
}
