import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomodoro/app/data/enums/tones.dart';
import 'package:pomodoro/app/data/models/pomodoro_task_model.dart';

class AddPomodoroTaskScreenController extends GetxController {
  AddPomodoroTaskScreenController(PomodoroTaskModel? task)
      : workDuration = task?.workDuration.inMinutes ?? 25,
        shortBreakDuration = task?.shortBreakDuration.inMinutes ?? 5,
        longBreakDuration = task?.longBreakDuration.inMinutes ?? 15,
        _maxPomodoroRound = task?.maxPomodoroRound ?? 3,
        vibrate = task?.vibrate ?? true,
        toneVolume = task?.toneVolume ?? 0.5,
        tone = (task?.tone ?? Tones.magical).obs,
        statusVolume = task?.statusVolume ?? 0.5,
        readStatusAloud = task?.readStatusAloud ?? true,
        title = task?.title ?? '',
        _id = task?.id,
        _isEditing = task != null,
        _isShortBreakPickerActive = (task?.maxPomodoroRound != 1).obs;

  final formKey = GlobalKey<FormState>();
  final scrollController = ScrollController();
  final titleError = false.obs;
  final RxBool _isShortBreakPickerActive;
  final Rx<Tones> tone;
  final int? _id;
  final bool _isEditing;

  int _maxPomodoroRound;
  String title;
  int workDuration;
  int shortBreakDuration;
  int longBreakDuration;
  bool vibrate;
  double toneVolume;
  double statusVolume;
  bool readStatusAloud;

  // Getters para verificar se o som está mudo ou se a tarefa está em edição
  bool get isReadStatusMuted => statusVolume == 0.0 || readStatusAloud == false;
  bool get isToneMuted => toneVolume == 0.0 || tone.value == Tones.none;
  bool get isEditing => _isEditing;
  bool get isShortBreakPickerActive => _isShortBreakPickerActive.value;
  int get maxPomodoroRound => _maxPomodoroRound;

  // Validador para o campo de título
  String? titleValidator(String? text) {
    if (text == null || text.isEmpty) {
      return "Digite o título da tarefa";
    } else if (text.length > 25) {
      return "O título deve ter no máximo 25 caracteres";
    }
    return null;
  }

  // Método chamado quando o valor de maxPomodoroRound é alterado
  void onMaxPomodoroRoundChange(int value) {
    _maxPomodoroRound = value;
    _isShortBreakPickerActive.value = value != 1;
  }

  // Método para salvar o título da tarefa
  void titleSaver(String? text) {
    title = text!;
  }

  // Método para rolar a tela para o topo
  Future<void> scrollToTop() async {
    await scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  // Método para criar um objeto PomodoroTaskModel a partir dos dados do formulário
  PomodoroTaskModel? addTask() {
    if (!formKey.currentState!.validate()) {
      scrollToTop();
      titleError.value = true;
      return null;
    }
    formKey.currentState!.save();
    titleError.value = false;
    final task = PomodoroTaskModel(
      id: _id,
      title: title,
      workDuration: workDuration.minutes,
      shortBreakDuration: _maxPomodoroRound == 1 ? Duration.zero : shortBreakDuration.minutes,
      longBreakDuration: longBreakDuration.minutes,
      maxPomodoroRound: _maxPomodoroRound,
      tone: tone.value,
      vibrate: vibrate,
      statusVolume: statusVolume,
      toneVolume: toneVolume,
      readStatusAloud: readStatusAloud,
    );
    return task;
  }

  // Método chamado quando o controlador é fechado
  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
