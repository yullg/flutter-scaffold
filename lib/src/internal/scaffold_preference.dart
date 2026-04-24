import 'package:meta/meta.dart';

import '../support/preference/preference.dart';

class ScaffoldPreference extends Preference {
  static ScaffoldPreference? _instance;

  factory ScaffoldPreference() {
    return _instance ??= ScaffoldPreference._();
  }

  ScaffoldPreference._() : super.instance("yg_preference_scaffold");
}

enum ScaffoldPreferences with EnumPreferenceMixin {
  guid,
  themeMode,
  localizationLanguageCode,
  localizationCountryCode,
  localizationScriptCode,
  sendCodeKeyDefault;

  @override
  @protected
  Preference get preference => ScaffoldPreference();
}
