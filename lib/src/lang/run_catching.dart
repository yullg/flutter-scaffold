import 'package:async/async.dart';

Result<T> runCatching<T>(T Function() block) => Result<T>(block);
