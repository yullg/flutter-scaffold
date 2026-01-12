import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:scaffold/scaffold_sugar.dart';

import '../internal/scaffold_preference.dart';

class LocalizationManager extends ChangeNotifier implements ValueListenable<Locale?> {
  static LocalizationManager? _instance;

  factory LocalizationManager() {
    return _instance ??= LocalizationManager._();
  }

  Locale? _value;

  @override
  Locale? get value => _value;

  Future<Locale?> load() async {
    Locale? locale;
    final languageCode = await ScaffoldPreferences.localizationLanguageCode.getString();
    final countryCode = await ScaffoldPreferences.localizationCountryCode.getString();
    final scriptCode = await ScaffoldPreferences.localizationScriptCode.getString();
    if (languageCode != null) {
      locale = Locale.fromSubtags(languageCode: languageCode, scriptCode: scriptCode, countryCode: countryCode);
    }
    if (_value != locale) {
      _value = locale;
      notifyListeners();
    }
    return locale;
  }

  Future<void> save(Locale? locale) async {
    if (locale != null) {
      await ScaffoldPreferences.localizationLanguageCode.setString(locale.languageCode);
      await locale.countryCode?.let((it) => ScaffoldPreferences.localizationCountryCode.setString(it));
      await locale.scriptCode?.let((it) => ScaffoldPreferences.localizationScriptCode.setString(it));
    } else {
      await ScaffoldPreferences.localizationLanguageCode.remove();
      await ScaffoldPreferences.localizationCountryCode.remove();
      await ScaffoldPreferences.localizationScriptCode.remove();
    }
    if (_value != locale) {
      _value = locale;
      notifyListeners();
    }
  }

  @override
  // ignore: must_call_super
  void dispose() {
    // 禁用 dispose，防止实例被销毁
    throw UnsupportedError('Singleton instances should not be disposed.');
  }

  LocalizationManager._();
}
