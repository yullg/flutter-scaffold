import 'package:get_storage/get_storage.dart';

import '../../scaffold_constants.dart';

class PreferenceSupport {
  static Future<void> initialize() async {
    await GetStorage.init(ScaffoldConstants.kGetStorageNameDefault);
  }

  static Future<void> destroy() async {
    // nothing
  }

  PreferenceSupport._();
}
