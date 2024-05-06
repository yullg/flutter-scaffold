class VisibleError extends Error {
  final Object? message;
  final Object? visual;

  VisibleError({this.message, this.visual});

  @override
  String toString() {
    return '$runtimeType{message: ${Error.safeToString(message)}}';
  }
}

class ContextUnmountedError extends VisibleError {
  ContextUnmountedError({super.message, super.visual});
}

class CancellationError extends VisibleError {
  CancellationError({super.message, super.visual});
}

class AuthenticationNotFoundError extends VisibleError {
  AuthenticationNotFoundError({super.message, super.visual});
}

class IncorrectResultSizeDatabaseError extends VisibleError {
  final int? expectedSize;
  final int? actualSize;

  IncorrectResultSizeDatabaseError({super.message, super.visual, this.expectedSize, this.actualSize});

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
