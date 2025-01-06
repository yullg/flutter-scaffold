import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:scaffold/scaffold_lang.dart';

import '../internal/scaffold_preference.dart';

class LocalizationManager extends ChangeNotifier
    implements ValueListenable<Locale?> {
  static const kSpKeyLanguageCode = "yullg_localization_language_code";
  static const kSpKeyCountryCode = "yullg_localization_country_code";
  static const kSpKeyScriptCode = "yullg_localization_script_code";

  static LocalizationManager? _instance;

  factory LocalizationManager() {
    return _instance ??= LocalizationManager._();
  }

  Locale? _value;

  @override
  Locale? get value => _value;

  Future<Locale?> load() async {
    Locale? locale;
    final languageCode =
        await ScaffoldPreference().getString(kSpKeyLanguageCode);
    final countryCode = await ScaffoldPreference().getString(kSpKeyCountryCode);
    final scriptCode = await ScaffoldPreference().getString(kSpKeyScriptCode);
    if (languageCode != null) {
      locale = Locale.fromSubtags(
          languageCode: languageCode,
          scriptCode: scriptCode,
          countryCode: countryCode);
    }
    if (_value != locale) {
      _value = locale;
      notifyListeners();
    }
    return locale;
  }

  Future<void> save(Locale? locale) async {
    if (locale != null) {
      await ScaffoldPreference()
          .setString(kSpKeyLanguageCode, locale.languageCode);
      await locale.countryCode
          ?.let((it) => ScaffoldPreference().setString(kSpKeyCountryCode, it));
      await locale.scriptCode
          ?.let((it) => ScaffoldPreference().setString(kSpKeyScriptCode, it));
    } else {
      await ScaffoldPreference().remove(kSpKeyLanguageCode);
      await ScaffoldPreference().remove(kSpKeyCountryCode);
      await ScaffoldPreference().remove(kSpKeyScriptCode);
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
