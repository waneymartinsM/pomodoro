import 'dart:async';
import 'package:get/get.dart';
import 'package:pomodoro/app/data/models/pomodoro_task_model.dart';
import 'package:pomodoro/app/data/models/pomodoro_task_reportage_model.dart';
import 'package:pomodoro/app/data/services/android_native_channel.dart';
import 'package:pomodoro/app/data/timers/pomodoro_task_timer.dart';
import 'package:pomodoro/app/ui/screens/start_pomodoro_task/start_pomodoro_task_screen_controller.dart';

class AppController {
  final AndroidNativeChannel _androidNativeChannel = AndroidNativeChannel();
  final PomodoroTaskTimer _pomodoroTaskTimer =
      PomodoroTaskTimer(tasksReportageDatabase: Get.find());

  /// It will be true if the foreground service is running
  final bool _isTimerAlreadyStarted = false;

  bool get isTimerAlreadyStarted => _isTimerAlreadyStarted;

  Future<void> init() async {
    //PomodoroAppSateData? state;

    // if (await _androidNativeChannel.isServiceRunning) {
    //   state = await _androidNativeChannel.stopService();
    // } else {
    //   state = await _androidNativeChannel.getState();
    // }

    ///
    // if (state == null) return;
    // _isTimerAlreadyStarted = true;
    // onPomodoroTaskStart(
    //   state.pomodoroTaskModel,
    //   taskReportageModel: state.pomodoroTaskReportageModel,
    //   isAlreadyStarted: true,
    // );
    ///
  }

  Future<void> onAppPaused() async {
    if (!Get.isRegistered<StartPomodoroTaskScreenController>()) return;
    StartPomodoroTaskScreenController controller = Get.find();
    if (!controller.isTimerStarted) return;
    if (controller.isTimerStopped) {
      await _pomodoroTaskTimer.saveTaskReport();
      await _androidNativeChannel.saveState(_pomodoroTaskTimer.pomodoroAppSateData);
    } else {
      final appState = _pomodoroTaskTimer.pomodoroAppSateData;
      _pomodoroTaskTimer.stop();
      await _androidNativeChannel.startService(appState);
    }
  }

  void onPomodoroTaskStart(
    PomodoroTaskModel task, {
    PomodoroTaskReportageModel? taskReportageModel,
    bool isAlreadyStarted = false,
  }) {
    final StartPomodoroTaskScreenController controller;
    if (Get.isRegistered<StartPomodoroTaskScreenController>()) {
      controller = Get.find();
    } else {
      controller = Get.put(StartPomodoroTaskScreenController());
    }
    _pomodoroTaskTimer.init(
      initState: task,
      onRoundFinish: controller.onPomodoroRoundFinish,
      onFinish: controller.onPomodoroTimerFinish,
      taskReportageModel: taskReportageModel,
    );
    controller.init(_pomodoroTaskTimer, isAlreadyStarted);
  }
}
