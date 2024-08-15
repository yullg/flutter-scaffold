import 'package:flutter/material.dart';

class ThemeModeHolder extends ChangeNotifier {
  static ThemeModeHolder? _instance;

  factory ThemeModeHolder() {
    return _instance ??= ThemeModeHolder._();
  }

  ThemeMode? _themeMode;

  ThemeMode? get themeMode => _themeMode;

  set themeMode(ThemeMode? value) {
    if (_themeMode != value) {
      _themeMode = value;
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
