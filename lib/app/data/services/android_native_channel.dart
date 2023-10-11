import 'dart:async';
import 'package:flutter/services.dart';
import 'package:pomodoro/app/data/models/pomodoro_app_state_data.dart';

class AndroidNativeChannel {
  static const _platformChannel = MethodChannel('ActivityChannel');

  // Este método verifica se o serviço está em execução na plataforma Android
  // Future<bool> get isServiceRunning async =>
  //     await _platformChannel.invokeMethod('isServiceRunning');

  // Este método inicia um serviço na plataforma Android com base nos dados fornecidos
  Future<bool> startService(PomodoroAppSateData initData) async {
    return (await _platformChannel.invokeMethod('startService', initData.toMap()));
  }

  // Este método para um serviço em execução na plataforma Android
  Future<PomodoroAppSateData?> stopService() async {
    final data = await _platformChannel.invokeMethod('stopService');
    return PomodoroAppSateData.fromMap(data);
  }

  // Este método obtém o estado atual do serviço na plataforma Android
  Future<PomodoroAppSateData?> getState() async {
    final data = await _platformChannel.invokeMethod('getState');
    if (data == null) return null;
    return PomodoroAppSateData.fromMap(data);
  }

  // Este método salva o estado do aplicativo Pomodoro na plataforma Android com base nos dados fornecidos
  Future<void> saveState(PomodoroAppSateData appSateData) async {
    await _platformChannel.invokeMethod('saveState', appSateData.toMap());
  }
}
