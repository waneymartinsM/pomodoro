import 'package:dartz/dartz.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pomodoro/app/data/models/pomodoro_task_model.dart';
class TasksDatabase {
  late final Box _tasksBox; // Uma caixa do Hive para armazenar as tarefas

  // Inicializa a caixa de tarefas do Hive
  Future<void> init() async {
    _tasksBox = await Hive.openBox('tasks');
  }

  // Obtém todas as tarefas do Hive e retorna uma lista de objetos `PomodoroTaskModel`
  Future<Either<Exception, List<PomodoroTaskModel>>> getAll() async {
    try {
      final List<PomodoroTaskModel> result = [];
      for (int key in _tasksBox.keys) {
        final Map<dynamic, dynamic>? data = _tasksBox.get(key);  // Obtém os dados da tarefa
        if (data == null) continue;
        final task = PomodoroTaskModel.fromMap(data);  // Converte o mapa de dados em um objeto `PomodoroTaskModel`
        result.add(task.copyWith(id: key));  // Adiciona a tarefa à lista com a chave como ID
      }
      return Right(result);  // Retorna a lista de tarefas
    } catch (e) {
      return Left(Exception(e.toString()));  // Em caso de erro, retorna um objeto `Left` com a exceção
    }
  }

  // Adiciona uma nova tarefa ao Hive e retorna a tarefa com o ID atribuído
  Future<Either<Exception, PomodoroTaskModel>> add(PomodoroTaskModel task) async {
    try {
      int id = await _tasksBox.add(task.toMap()); // Adiciona a tarefa e obtém o ID
      return Right(task.copyWith(id: id));  // Retorna a tarefa com o ID atribuído
    } catch (e) {
      return Left(Exception(e.toString()));  // Em caso de erro, retorna um objeto `Left` com a exceção
    }
  }

  // Atualiza uma tarefa no Hive
  Future<Either<Exception, void>> update(PomodoroTaskModel task) async {
    try {
      await _tasksBox.put(task.id!, task.toMap());  // Atualiza a tarefa com o mesmo ID
      return const Right(null);  // Retorna um objeto `Right` para indicar sucesso
    } catch (e) {
      return Left(Exception(e.toString()));  // Em caso de erro, retorna um objeto `Left` com a exceção
    }
  }

  // Deleta uma tarefa do Hive usando o ID
  Future<Either<Exception, void>> delete(int id) async {
    try {
      await _tasksBox.delete(id);  // Deleta a tarefa com o ID especificado
      return const Right(null);  // Retorna um objeto `Right` para indicar sucesso
    } catch (e) {
      return Left(Exception(e.toString()));  // Em caso de erro, retorna um objeto `Left` com a exceção
    }
  }
}
