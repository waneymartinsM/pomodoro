import 'package:complete_timer/complete_timer.dart';
import 'package:pomodoro/app/data/databases/tasks_reportage_database.dart';
import 'package:pomodoro/app/data/enums/task_status.dart';
import 'package:pomodoro/app/data/models/pomodoro_app_state_data.dart';
import 'package:pomodoro/app/data/models/pomodoro_task_model.dart';
import 'package:pomodoro/app/data/models/pomodoro_task_reportage_model.dart';
import 'package:pomodoro/app/data/services/pomodoro_sound_player.dart';
import 'package:pomodoro/app/data/timers/pomodoro_timer.dart';

class PomodoroTaskTimer extends PomodoroTimer {
  // Injeta o banco de dados de relatórios de tarefas:
  PomodoroTaskTimer({required TasksReportageDatabase tasksReportageDatabase})
      // Inicializa o banco de dados:
      : _tasksReportageDatabase = tasksReportageDatabase;

  final PomodoroSoundPlayer _soundPlayer = PomodoroSoundPlayer();
  final TasksReportageDatabase _tasksReportageDatabase;
  PomodoroTaskReportageModel? _taskReportageModel;
  CompleteTimer? _timerListener;
  late PomodoroTaskModel _initState;

  String get taskTitle => _initState.title; // Obtém o título da tarefa.
  PomodoroTaskModel get pomodoroTask => _initState.copyWith(
        // Obtém o estado da tarefa do Pomodoro.
        pomodoroRound: super.pomodoroRound,
        currentMaxDuration: super.currentMaxDuration,
        remainingDuration: super.remainingDuration,
        pomodoroStatus: super.pomodoroStatus,
        timerStatus: super.timerStatus,
      );
  PomodoroAppSateData get pomodoroAppSateData => PomodoroAppSateData(
        // Obtém o estado do aplicativo do Pomodoro.
        pomodoroTaskModel: pomodoroTask,
        pomodoroTaskReportageModel: _taskReportageModel,
      );
  PomodoroTaskReportageModel? get taskReportage =>
      _taskReportageModel; // Obtéfm informações sobre o relatório de tarefas atual.
  Future<bool> get isSoundPlayerMuted => _soundPlayer.isSoundPlayerMuted(
      pomodoroTask); // Verifica se o player de som está mudo.

  @override
  Future<void> init({
    required PomodoroTaskModel initState,
    Future<void> Function()? onRoundFinish,
    Future<void> Function()? onFinish,
    bool isForegroundService = false,
    PomodoroTaskReportageModel? taskReportageModel,
  }) async {
    _initState = initState;
    _taskReportageModel = taskReportageModel;
    _soundPlayer.init();
    super.init(
      initState: initState,
      onRoundFinish: () async {
        _timerListener?.cancel();
        _soundPlayer.playPomodoroSound(pomodoroTask);
        await onRoundFinish?.call();
        _timerListener?.start();
      },
      onFinish: () async {
        isForegroundService
            ? await _soundPlayer.playTone(_initState.tone)
            : _soundPlayer.playTone(_initState.tone);
        await onFinish?.call();
        _timerListener?.cancel();
      },
    );
  }

  void listen(Duration intervalTime, void Function() listener) {
    _timerListener?.cancel();
    _timerListener = CompleteTimer(
      duration: intervalTime,
      callback: (_) => listener(),
      autoStart: super.timerStatus.isStarted,
      periodic: true,
    );
  }

  void dispose() {
    _soundPlayer.dispose();
    _timerListener?.cancel();
    _timerListener = null;
  }

  @override
  void start() {
    super.start();
    _timerListener?.start();
    if (_taskReportageModel != null) return;
    _taskReportageModel = PomodoroTaskReportageModel(
      pomodoroTaskId: _initState.id!,
      taskName: _initState.title,
      startDate: DateTime.now(),
      taskStatus: TaskStatus.uncompleted,
    );
  }

  @override
  void stop() {
    super.stop();
    _timerListener?.stop();
  }

  @override
  void cancel() {
    super.cancel();
    _timerListener?.cancel();
  }

  Future<void> saveTaskReport({bool isCompleted = false}) async {
    if (_taskReportageModel == null) return;
    final now = DateTime.now();
    _taskReportageModel = _taskReportageModel!.copyWith(
      endDate: _taskReportageModel!.endDate ?? now,
      taskStatus: isCompleted ? TaskStatus.completed : TaskStatus.uncompleted,
    );
    await _tasksReportageDatabase.add(_taskReportageModel!);
    _taskReportageModel = null;
  }
}
