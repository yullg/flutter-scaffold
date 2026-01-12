import 'preference.dart';
import 'preference_width_cache.dart';

class DefaultPreference extends Preference {
  static DefaultPreference? _instance;

  factory DefaultPreference() {
    return _instance ??= DefaultPreference._();
  }

  DefaultPreference._() : super.instance("yg_preference_default");
}

class DefaultPreferenceWithCache extends PreferenceWithCache {
  static DefaultPreferenceWithCache? _instance;

  factory DefaultPreferenceWithCache() {
    return _instance ??= DefaultPreferenceWithCache._();
  }

  DefaultPreferenceWithCache._() : super.instance("yg_preference_with_cache_default");
}
