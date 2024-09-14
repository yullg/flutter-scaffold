import 'preference.dart';

class DeveloperPreference extends Preference {
  static DeveloperPreference? _instance;

  factory DeveloperPreference() {
    return _instance ??= DeveloperPreference._();
  }

  DeveloperPreference._() : super("yullg_preference_developer");
}
