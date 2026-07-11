import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/app_strings.dart';

/// User settings: a primary language for the whole app, an optional second
/// language shown under color names so kids can learn a new language, and a
/// single sound toggle covering music and effects together. Defaults to
/// English, no second language, sound on.
class SettingsService extends ChangeNotifier {
  static const _primaryKey = 'primary_lang';
  static const _secondaryKey = 'secondary_lang';
  static const _soundEnabledKey = 'sound_enabled';

  String _primaryLang = 'en';
  String? _secondaryLang;
  bool _soundEnabled = true;

  String get primaryLang => _primaryLang;
  String? get secondaryLang => _secondaryLang;
  bool get soundEnabled => _soundEnabled;
  AppStrings get strings => appStringsFor(_primaryLang);

  bool get isRtl =>
      supportedLanguages.any((l) => l.code == _primaryLang && l.rtl);

  static bool _isSupported(String code) =>
      supportedLanguages.any((l) => l.code == code);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final primary = prefs.getString(_primaryKey);
    final secondary = prefs.getString(_secondaryKey);
    if (primary != null && _isSupported(primary)) _primaryLang = primary;
    if (secondary != null && _isSupported(secondary)) {
      _secondaryLang = secondary;
    }
    if (_secondaryLang == _primaryLang) _secondaryLang = null;
    _soundEnabled = prefs.getBool(_soundEnabledKey) ?? true;
    notifyListeners();
  }

  Future<void> setPrimaryLang(String code) async {
    if (!_isSupported(code)) return;
    _primaryLang = code;
    // The second language duplicating the primary teaches nothing — drop it.
    if (_secondaryLang == code) _secondaryLang = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_primaryKey, code);
    if (_secondaryLang == null) await prefs.remove(_secondaryKey);
  }

  Future<void> setSecondaryLang(String? code) async {
    if (code != null && (!_isSupported(code) || code == _primaryLang)) return;
    _secondaryLang = code;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    if (code == null) {
      await prefs.remove(_secondaryKey);
    } else {
      await prefs.setString(_secondaryKey, code);
    }
  }

  Future<void> toggleSound() => setSoundEnabled(!_soundEnabled);

  Future<void> setSoundEnabled(bool enabled) async {
    if (_soundEnabled == enabled) return;
    _soundEnabled = enabled;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundEnabledKey, enabled);
  }
}
