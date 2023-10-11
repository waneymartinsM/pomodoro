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

  // Variável que indica se o temporizador Pomodoro já está em execução
  final bool _isTimerAlreadyStarted = false;

  // Getter para acessar a variável _isTimerAlreadyStarted
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

  // Método chamado quando o aplicativo está em pausa
  Future<void> onAppPaused() async {
    // Verifica se a tela 'StartPomodoroTaskScreenController' está registrada
    if (!Get.isRegistered<StartPomodoroTaskScreenController>()) return;
    StartPomodoroTaskScreenController controller = Get.find();

    // Verifica se o temporizador está em execução
    if (!controller.isTimerStarted) return;

    // Se o temporizador estiver parado, salva o relatório da tarefa e o estado do aplicativo
    if (controller.isTimerStopped) {
      await _pomodoroTaskTimer.saveTaskReport();
      await _androidNativeChannel.saveState(_pomodoroTaskTimer.pomodoroAppSateData);
    } else {

      // Se o temporizador estiver em execução, para o temporizador e inicia um serviço nativo no Android
      final appState = _pomodoroTaskTimer.pomodoroAppSateData;
      _pomodoroTaskTimer.stop();
      await _androidNativeChannel.startService(appState);
    }
  }

  // Método para iniciar uma tarefa Pomodoro
  void onPomodoroTaskStart(
    PomodoroTaskModel task, {
    PomodoroTaskReportageModel? taskReportageModel,
    bool isAlreadyStarted = false,
  }) {
    final StartPomodoroTaskScreenController controller;

    // Verifica se a tela 'StartPomodoroTaskScreenController' está registrada
    if (Get.isRegistered<StartPomodoroTaskScreenController>()) {
      controller = Get.find();
    } else {

      // Se a tela não estiver registrada, cria uma instância
      controller = Get.put(StartPomodoroTaskScreenController());
    }

    // Inicializa o temporizador com os parâmetros apropriados
    _pomodoroTaskTimer.init(
      initState: task,
      onRoundFinish: controller.onPomodoroRoundFinish,
      onFinish: controller.onPomodoroTimerFinish,
      taskReportageModel: taskReportageModel,
    );

    // Inicializa o controlador da tela 'StartPomodoroTaskScreenController'
    controller.init(_pomodoroTaskTimer, isAlreadyStarted);
  }
}
