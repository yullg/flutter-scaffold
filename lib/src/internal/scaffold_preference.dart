import '../support/preference/preference.dart';

class ScaffoldPreference extends Preference {
  static ScaffoldPreference? _instance;

  factory ScaffoldPreference() {
    return _instance ??= ScaffoldPreference._();
  }

  ScaffoldPreference._() : super("yullg_preference_scaffold");
}
