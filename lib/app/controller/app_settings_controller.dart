import 'dart:async';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:pomodoro/app/data/databases/app_settings_database.dart';
import 'package:pomodoro/app/data/models/app_settings.dart';

class AppSettingsController extends GetxController {
  final _settingsDatabase = AppSettingsDatabase();
  late bool _isFirstAppRun;
  AppSettings? _appSettings;
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
}
