import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomodoro/app/config/localization/app_localization_data.dart';
import 'package:pomodoro/app/config/localization/localizations.dart';
import 'package:pomodoro/app/config/theme/themes.dart';
import 'package:pomodoro/app/data/databases/app_settings_database.dart';
import 'package:pomodoro/app/data/models/app_settings.dart';

class AppSettingsController extends GetxController {
  final _settingsDatabase = AppSettingsDatabase();
  late ThemeData _theme;
  late bool _isDarkTheme;
  late AppLocalizationData _appTexts;
  late bool _isFirstAppRun;
  AppSettings? _appSettings;

  ThemeData get theme => _theme;
  bool get isDarkTheme => _isDarkTheme;
  bool get isEnglish => _appTexts.locale == englishLocale;
  bool get isFirstAppRun => _isFirstAppRun;
  AppLocalizationData get localization => _appTexts;

  Future<void> init() async {
    await _settingsDatabase.init();
    final settings = await _settingsDatabase.getSettings();
    settings.fold(
          (l) => log(l.toString()), // Log de erro se as configurações não puderem ser lidas
      (r) {
        _appSettings = r;
        if (_appSettings != null) {
          _isFirstAppRun = false;
          _initLocale(_appSettings!.isEnglish); // Inicializa a localização com base nas configurações
        } else {
          _isFirstAppRun = true;
          final isEnglishLocale = Platform.localeName.substring(0, 2) == 'en';
          _initLocale(isEnglishLocale); // Define a localização com base no idioma do dispositivo
        }
      },
    );
  }

  void initializeTheme() {
    if (_appSettings != null) {
      _initTheme(_appSettings!.isDarkTheme); // Inicializa o tema com base nas configurações
    } else {
      final brightness = WidgetsBinding.instance.window.platformBrightness;
      _initTheme(brightness == Brightness.dark);
      _saveSettings();
    }
  }

  // Salva as configurações atuais (tema e idioma) no banco de dados
  Future<void> _saveSettings() async {
    await _settingsDatabase.saveSettings(
      AppSettings(isDarkTheme: isDarkTheme, isEnglish: isEnglish),
    );
  }

  // Alterna entre os idiomas (inglês e persa)
  void toggleLocalization() {
    _initLocale(!isEnglish);
    _initTheme(_isDarkTheme);
    update();
    _saveSettings();
  }

  // Alterna entre os temas (claro e escuro)
  void toggleTheme() {
    _initTheme(!_isDarkTheme);
    update();
    _saveSettings();
  }

  // Inicializa o tema com base no valor booleano
  void _initTheme(bool isDark) {
    _isDarkTheme = isDark;
    _theme = isDark ? darkTheme(localization.fontFamily) : lightTheme(localization.fontFamily);
  }

  // Inicializa a localização com base no valor booleano
  void _initLocale(bool isEnglishLocale) {
    _appTexts = isEnglishLocale ? englishLocalization : persianLocalization;
  }
}
