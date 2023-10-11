import 'package:dartz/dartz.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pomodoro/app/data/models/app_settings.dart';

const _settingsKey = '_settingsKey';  // Chave para identificar as configurações no Hive

class AppSettingsDatabase {
  late Box _settingsBox;  // Uma caixa do Hive para armazenar as configurações

  // Inicializa a caixa de configurações do Hive
  Future<void> init() async {
    _settingsBox = await Hive.openBox('settingsBox');
  }

  // Obtém as configurações do Hive e retorna um objeto `AppSettings` (ou `null` se não existir)
  Future<Either<Exception, AppSettings?>> getSettings() async {
    try {
      final map = _settingsBox.get(_settingsKey);  // Obtém o mapa de configurações
      final settings = map != null ? AppSettings.fromMap(map) : null;  // Converte o mapa em um objeto `AppSettings`
      return Right(settings);  // Retorna as configurações ou `null`
    } catch (e) {
      return Left(Exception(e.toString()));  // Em caso de erro, retorna um objeto `Left` com a exceção
    }
  }

  // Salva as configurações no Hive
  Future<Either<Exception, bool>> saveSettings(AppSettings settings) async {
    try {
      await _settingsBox.put(_settingsKey, settings.toMap());  // Armazena as configurações como um mapa no Hive
      return const Right(true);  // Retorna um objeto `Right` para indicar que as configurações foram salvas com sucesso
    } catch (e) {
      return Left(Exception(e.toString()));  // Em caso de erro, retorna um objeto `Left` com a exceção
    }
  }
}
