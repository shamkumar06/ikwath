import 'package:flutter/material.dart';
import '../l10n/app_strings.dart';

/// Manages the currently selected locale/language for the app.
/// Extends ChangeNotifier so the entire widget tree rebuilds when
/// the user switches language.
class LocaleProvider extends ChangeNotifier {
  String _langCode = 'hi'; // Default: Hindi (government app)

  String get langCode => _langCode;

  AppLocale get currentLocale =>
      supportedLocales.firstWhere((l) => l.code == _langCode,
          orElse: () => supportedLocales.first);

  /// Translate a key using the currently selected language
  String t(String key) => tr(key, _langCode);

  /// Change the active language
  void setLanguage(String code) {
    if (_langCode != code) {
      _langCode = code;
      notifyListeners();
    }
  }
}
