import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ThemeModeHolder extends ChangeNotifier implements ValueListenable<ThemeMode?> {
  static ThemeModeHolder? _instance;

  factory ThemeModeHolder() {
    return _instance ??= ThemeModeHolder._();
  }

  ThemeMode? _themeMode;

  @override
  ThemeMode? get value => _themeMode;

  set value(ThemeMode? newValue) {
    if (_themeMode != newValue) {
      _themeMode = newValue;
      notifyListeners();
    }
  }

  @override
  // ignore: must_call_super
  void dispose() {
    // 禁用 dispose，防止实例被销毁
    throw UnsupportedError('Singleton instances should not be disposed.');
  }

  ThemeModeHolder._();
}
