import 'preference.dart';

class DefaultPreference extends Preference {
  static DefaultPreference? _instance;

  factory DefaultPreference() {
    return _instance ??= DefaultPreference._();
  }

  DefaultPreference._() : super.instance("yg_preference_default");
}
