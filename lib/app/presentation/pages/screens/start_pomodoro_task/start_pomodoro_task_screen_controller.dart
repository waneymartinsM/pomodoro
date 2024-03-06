import 'dart:async';
import 'package:get/get.dart';
import 'package:pomodoro/app/controller/app_settings_controller.dart';
import 'package:pomodoro/app/data/models/pomodoro_task_model.dart';
import 'package:pomodoro/app/data/timers/pomodoro_task_timer.dart';
import 'package:pomodoro/app/presentation/pages/screens/start_pomodoro_task/screen_notifier_event.dart';
import 'package:pomodoro/app/presentation/pages/screens/start_pomodoro_task/widgets/circle_animated_button/enum.dart';
import 'package:pomodoro/app/presentation/pages/screens/start_pomodoro_task/widgets/countdown_timer/enum.dart';
import 'widgets/circle_animated_button/circle_animated_button_controller.dart';
import 'widgets/countdown_timer/controller/countdown_timer_controller.dart';

class StartPomodoroTaskScreenController extends GetxController {
  // Controladores para a Contagem Regressiva e Botão Animado
  final _countdownTimerController = Get.put(CountdownTimerController());
  final _circleAnimatedButtonController =
      Get.put(CircleAnimatedButtonController());

  // Variáveis observáveis para controlar a cor da tela e texto do Pomodoro
  final _showLinerGradientColors = false.obs;
  final _pomodoroText = ''.obs;

  // Stream para notificar eventos na tela
  final _screenNotifier = StreamController<ScreenNotifierEvent>();

  // Obter configurações do aplicativo para localizações de texto
  final _appText = Get.find<AppSettingsController>();
  late PomodoroTaskTimer _timer;

  // Getters para acessar informações do temporizador e do estado da tela
  bool get showLinerGradientColors => _showLinerGradientColors.value;
  Stream<ScreenNotifierEvent> get screenNotifier => _screenNotifier.stream;
  PomodoroTaskModel get pomodoroTask => _timer.pomodoroTask;
  String get taskTitle => _timer.taskTitle;
  String? get pomodoroText =>
      _pomodoroText.value.isEmpty ? null : _pomodoroText.value;
  bool get isTimerStarted => !(_timer.timerStatus.isCanceled);
  bool get isTimerStopped => _timer.timerStatus.isStopped;

  String get _getPomodoroText {
    if (_timer.pomodoroStatus.isWorkTime) {
      return 'Mantenha o foco por ${_timer.currentMaxDuration.inMinutes} minutos';
    } else if (_timer.pomodoroStatus.isShortBreakTime) {
      return 'Faça uma pequena pausa de ${_timer.currentMaxDuration.inMinutes} minutos';
    } else {
      return 'Faça uma pausa longa de ${_timer.currentMaxDuration.inMinutes} minutos';
    }
  }

  // Método para obter o texto do subtítulo
  String get _getSubtitleText {
    int round =
        _timer.pomodoroRound + (_timer.pomodoroStatus.isLongBreakTime ? 0 : 1);
    return "$round de ${_timer.maxPomodoroRound} sessões";
  }

  // Método chamado quando o controlador é fechado
  @override
  void onClose() {
    _timer.cancel();
    _timer.dispose();
    Get.delete<CountdownTimerController>();
    Get.delete<CircleAnimatedButtonController>();
    _screenNotifier.close();
    super.onClose();
  }

  // Método para inicializar o controlador
  void init(PomodoroTaskTimer timer, [bool isAlreadyStarted = false]) async {
    _timer = timer;
    final initState = timer.pomodoroTask;
    _timer.listen(const Duration(milliseconds: 16), () {
      _countdownTimerController.setTimerDuration(_timer.remainingDuration);
    });
    checkSoundSettings();
    if (isAlreadyStarted) {
      // Configurar a tela e iniciar o temporizador com base no estado inicial
      _countdownTimerController.init(
        maxDuration: _timer.currentMaxDuration,
        timerDuration: _timer.remainingDuration,
        subtitleText: _getSubtitleText,
        status: initState.timerStatus.isStopped
            ? CountdownTimerStatus.pause
            : CountdownTimerStatus.resume,
      );
      _circleAnimatedButtonController.init(
        initState.timerStatus.isStopped
            ? CircleAnimatedButtonStatus.pause
            : CircleAnimatedButtonStatus.started,
      );
      _showLinerGradientColors.value = true;
      _pomodoroText.value = _getPomodoroText;
      if (initState.timerStatus.isStarted) {
        _timer.start();
      } else if (initState.timerStatus.isCanceled) {
        await Future.delayed(300.milliseconds);
        onPomodoroTimerFinish();
      }
    } else {
      // Iniciar animações e o temporizador
      _countdownTimerController.init(
        maxDuration: _timer.currentMaxDuration,
        timerDuration: _timer.remainingDuration,
        status: CountdownTimerStatus.cancel,
      );
      _circleAnimatedButtonController.init(CircleAnimatedButtonStatus.finished);

      await Future.delayed(500.milliseconds);
      _startAnimations();
      _timer.start();
    }
  }

  void _startAnimations() {
    _showLinerGradientColors.value = true;
    _circleAnimatedButtonController.startAnimation();
    _countdownTimerController.changeStatus(CountdownTimerStatus.start);
    _countdownTimerController.subtitleText = _getSubtitleText;
    _pomodoroText.value = _getPomodoroText;
  }

  Future<void> onRestart() async {
    await _timer.saveTaskReport();
    _timer.cancel();
    _countdownTimerController.maxDuration = _timer.currentMaxDuration;
    _countdownTimerController.changeStatus(CountdownTimerStatus.cancel);
    _circleAnimatedButtonController.inProgress = true;
    await _countdownTimerController.restart();
    _countdownTimerController.changeStatus(CountdownTimerStatus.start);
    _circleAnimatedButtonController.inProgress = false;
    _countdownTimerController.subtitleText = _getSubtitleText;
    _pomodoroText.value = _getPomodoroText;
    _timer.start();
  }

  void start() {
    checkSoundSettings();
    _startAnimations();
    _timer.start();
  }

  void pause() {
    _timer.stop();
    _countdownTimerController.changeStatus(CountdownTimerStatus.pause);
  }

  void resume() {
    _timer.start();
    _countdownTimerController.changeStatus(CountdownTimerStatus.resume);
  }

  void cancel() {
    _timer.saveTaskReport();
    _timer.cancel();
  }

  // Método chamado quando o temporizador Pomodoro é concluído
  Future<void> onPomodoroTimerFinish() async {
    _timer.saveTaskReport(isCompleted: true);
    _countdownTimerController.maxDuration = _timer.currentMaxDuration;
    _countdownTimerController.restart();
    _countdownTimerController.changeStatus(CountdownTimerStatus.cancel);
    _circleAnimatedButtonController.finishAnimation();
    _showLinerGradientColors.value = false;
    _countdownTimerController.subtitleText = null;
    _pomodoroText.value = '';
    _screenNotifier.add(ScreenNotifierEvent.showPomodoroFinishSnackBar);
  }

  // Método chamado quando uma rodada Pomodoro é concluída
  Future<void> onPomodoroRoundFinish() async {
    checkSoundSettings();
    _circleAnimatedButtonController.inProgress = true;
    _countdownTimerController.maxDuration = _timer.currentMaxDuration;
    await _countdownTimerController.restart();
    _circleAnimatedButtonController.inProgress = false;
    _countdownTimerController.subtitleText = _getSubtitleText;
    _pomodoroText.value = _getPomodoroText;
  }

  // Método para verificar as configurações de som
  Future<void> checkSoundSettings() async {
    if (await _timer.isSoundPlayerMuted) {
      _screenNotifier.add(ScreenNotifierEvent.showMuteAlertSnackBar);
    }
  }
}
