import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pomodoro/app/controller/app_controller.dart';
import 'package:pomodoro/app/controller/app_settings_controller.dart';
import 'package:pomodoro/app/data/databases/tasks_reportage_database.dart';
import 'package:pomodoro/pomodoro_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Get.put(AppSettingsController()).init();
  await Get.put(TasksReportageDatabase()).init();
  await Get.put(AppController()).init();
  runApp(const PomodoroApp());
}
