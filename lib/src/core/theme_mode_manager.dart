import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scaffold/scaffold_lang.dart';

import '../internal/scaffold_preference.dart';

class ThemeModeManager extends ChangeNotifier
    implements ValueListenable<ThemeMode?> {
  static const kSpKey = "yg_theme_mode";

  static ThemeModeManager? _instance;

  factory ThemeModeManager() {
    return _instance ??= ThemeModeManager._();
  }

  ThemeMode? _value;

  @override
  ThemeMode? get value => _value;

  Future<ThemeMode?> load() async {
    ThemeMode? themeMode;
    final themeModeName = await ScaffoldPreference().getString(kSpKey);
    if (themeModeName != null) {
      themeMode =
          ThemeMode.values.firstWhereOrNull((it) => it.name == themeModeName);
    }
    if (_value != themeMode) {
      _value = themeMode;
      notifyListeners();
    }
    return themeMode;
  }

  Future<void> save(ThemeMode? themeMode) async {
    if (themeMode != null) {
      await ScaffoldPreference().setString(kSpKey, themeMode.name);
    } else {
      await ScaffoldPreference().remove(kSpKey);
    }
    if (_value != themeMode) {
      _value = themeMode;
      notifyListeners();
    }
  }

  @override
  // ignore: must_call_super
  void dispose() {
    // 禁用 dispose，防止实例被销毁
    throw UnsupportedError('Singleton instances should not be disposed.');
  }

  ThemeModeManager._();
}
