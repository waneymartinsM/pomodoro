import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pomodoro/app/data/models/pomodoro_task_model.dart';
import 'package:pomodoro/app/data/models/pomodoro_task_reportage_model.dart';
import 'package:pomodoro/app/utils/extensions/extensions.dart';

class TasksReportageDatabase {
  late LazyBox _tasksBox;  // Uma caixa do Hive para armazenar relatórios de tarefas
  final _onChangesNotifier = StreamController.broadcast();  // Controlador de fluxo para notificar sobre alterações

  // Inicializa a caixa de relatórios de tarefas do Hive
  Future<void> init() async {
    _tasksBox = await Hive.openLazyBox('tasks_reportage');
  }

  int get tasksLength => _tasksBox.length;  // Obtém o número de relatórios de tarefas

  void listen(void Function() listener) {
    _onChangesNotifier.stream.listen((_) => listener());
  }

  // Obtém uma lista de relatórios de tarefas no intervalo especificado
  Future<Either<Exception, List<PomodoroTaskReportageModel>>> getTasks(
      int begin, int end) async {
    try {
      final List<PomodoroTaskReportageModel> result = [];
      final listOfKeys = _tasksBox.keys.toList();
      final selectedKeys = listOfKeys.sublist(begin, end);
      for (int key in selectedKeys) {
        final Map<dynamic, dynamic> data = await _tasksBox.get(key);
        final task = PomodoroTaskReportageModel.fromMap(data);
        result.add(task.copyWith(id: key));
      }
      return Right(result);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  // Obtém todos os relatórios de tarefas em uma data específica
  Future<Either<Exception, List<PomodoroTaskReportageModel>>>
      getAllReportagesInDate(DateTime date) async {
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

  // Obtém um relatório de tarefa com base em um índice específico
  Future<Either<Exception, PomodoroTaskReportageModel>> getByIndex(
      int index) async {
    try {
      final key = _tasksBox.keys.elementAt(index);
      final data = await _tasksBox.get(key);
      final task = PomodoroTaskReportageModel.fromMap(data);
      return Right(task.copyWith(id: key));
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  // Obtém o índice onde uma função de teste é verdadeira
  Future<Either<Exception, int?>> indexWhere(
    bool Function(PomodoroTaskReportageModel t) test,
  ) async {
    try {
      for (int i = _tasksBox.keys.length - 1; i >= 0; i--) {
        final key = _tasksBox.keys.elementAt(i);
        final Map<dynamic, dynamic> data = await _tasksBox.get(key);
        PomodoroTaskReportageModel task =
            PomodoroTaskReportageModel.fromMap(data);
        task = task.copyWith(id: key);
        if (test(task)) {
          return Right(i);
        }
      }
      return const Right(null);
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
