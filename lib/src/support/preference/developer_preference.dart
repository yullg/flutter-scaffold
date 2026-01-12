import 'preference.dart';

class DeveloperPreference extends Preference {
  static DeveloperPreference? _instance;

  factory DeveloperPreference() {
    return _instance ??= DeveloperPreference._();
  }

  DeveloperPreference._() : super.instance("yg_preference_developer");
}
