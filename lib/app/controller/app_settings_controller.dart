import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomodoro/app/data/databases/app_settings_database.dart';
import 'package:pomodoro/app/data/models/app_settings.dart';

class AppSettingsController extends GetxController {
  AppSettingsController() {
    // Inicialize com um valor padrão (ajuste conforme necessário)
    _theme = ThemeData.light();
  }
  final _settingsDatabase = AppSettingsDatabase();
  late ThemeData _theme;
  late bool _isDarkTheme;
  late bool _isFirstAppRun;
  AppSettings? _appSettings;

  ThemeData get theme => _theme;
  bool get isDarkTheme => _isDarkTheme;
  bool get isFirstAppRun => _isFirstAppRun;

  Future<void> init() async {
    await _settingsDatabase.init();
    final settings = await _settingsDatabase.getSettings();
    settings.fold(
      (l) => log(l
          .toString()), // Log de erro se as configurações não puderem ser lidas
      (r) {
        _appSettings = r;
        _appSettings != null ? _isFirstAppRun = false : _isFirstAppRun = true;
      },
    );
  }

  void initializeTheme() {
    if (_appSettings != null) {
      // Inicializa o tema com base nas configurações
      _initTheme(_appSettings!.isDarkTheme);
    } else {
      final brightness = WidgetsBinding.instance.window.platformBrightness;
      _initTheme(brightness == Brightness.dark);
      _saveSettings();
    }
  }

  // Salva as configurações atuais (tema e idioma) no banco de dados
  Future<void> _saveSettings() async {
    await _settingsDatabase.saveSettings(AppSettings(isDarkTheme: isDarkTheme));
  }

  // Inicializa o tema com base no valor booleano
  void _initTheme(bool isDark) {
    _isDarkTheme = isDark;
  }
}
