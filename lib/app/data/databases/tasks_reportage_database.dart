import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pomodoro/app/data/models/pomodoro_task_model.dart';
import 'package:pomodoro/app/data/models/pomodoro_task_reportage_model.dart';
import 'package:pomodoro/app/utils/extensions/extensions.dart';

class TasksReportageDatabase {
  // Uma caixa do Hive para armazenar relatórios de tarefas:
  late LazyBox _tasksBox;

  // Controlador de fluxo para notificar sobre alterações
  final _onChangesNotifier = StreamController.broadcast();

  // Inicializa a caixa de relatórios de tarefas do Hive
  Future<void> init() async {
    _tasksBox = await Hive.openLazyBox('tasks_reportage');
  }

  void listen(void Function() listener) {
    _onChangesNotifier.stream.listen((_) => listener());
  }

  // Obtém todos os relatórios de tarefas em uma data específica
  Future<Either<Exception, List<PomodoroTaskReportageModel>>>
      getAllReportsUpToDate(DateTime date) async {
    try {
      final List<PomodoroTaskReportageModel> result = [];
      for (int i = _tasksBox.keys.length - 1; i >= 0; i--) {
        final key = _tasksBox.keys.elementAt(i);
        final Map<dynamic, dynamic> data = await _tasksBox.get(key);
        PomodoroTaskReportageModel task =
            PomodoroTaskReportageModel.fromMap(data);
        task = task.copyWith(id: key);
        if (task.startDate.isInSameDay(date)) {
          result.add(task);
        } else if (task.startDate.isBefore(date)) {
          break;
        }
      }
      return Right(result);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  // Adiciona um novo relatório de tarefa ao Hive e notifica sobre a alteração
  Future<Either<Exception, PomodoroTaskReportageModel>> add(
      PomodoroTaskReportageModel task) async {
    try {
      int id = await _tasksBox.add(task.toMap());
      _onChangesNotifier.add(null);
      return Right(task.copyWith(id: id));
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  // Atualiza um relatório de tarefa com base no modelo de tarefa Pomodoro
  Future<Either<Exception, void>> update(
      PomodoroTaskModel pomodoroTaskModel) async {
    try {
      for (var key in _tasksBox.keys) {
        final map = await _tasksBox.get(key);
        final PomodoroTaskReportageModel reportageTask =
            PomodoroTaskReportageModel.fromMap(map);
        if (reportageTask.pomodoroTaskId == pomodoroTaskModel.id!) {
          await _tasksBox.put(
            key,
            reportageTask.copyWith(taskName: pomodoroTaskModel.title).toMap(),
          );
        }
      }
      _onChangesNotifier.add(null);

      return const Right(null);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  // Deleta um relatório de tarefa com base no ID da tarefa Pomodoro
  Future<Either<Exception, void>> delete(int pomodoroTaskId) async {
    try {
      for (var key in _tasksBox.keys) {
        final map = await _tasksBox.get(key);
        final PomodoroTaskReportageModel task =
            PomodoroTaskReportageModel.fromMap(map);
        if (task.pomodoroTaskId == pomodoroTaskId) {
          await _tasksBox.delete(key);
        }
      }
      _onChangesNotifier.add(null);

      return const Right(null);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }
}
