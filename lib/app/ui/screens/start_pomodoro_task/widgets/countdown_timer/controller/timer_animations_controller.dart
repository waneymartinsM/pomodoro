import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants.dart';

class TimerAnimationsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late double _circularLineDeg;
  late Duration _maxDuration;
  late Duration _remainingDuration;
  late Duration _timerDuration;
  bool _animateBack = false;

  // Getters para obter informações
  Duration get remainingDuration => _remainingDuration;
  double get circularLineDeg => _circularLineDeg;
  bool get animateBack => _animateBack;
  double get animationValue =>
      _timerDuration.inMilliseconds /
      _maxDuration
          .inMilliseconds; // Calcula o valor de animação com base na duração do timer

  // Setter para a duração máxima do timer
  set maxDuration(Duration value) {
    _maxDuration = value;
  }

  // Método privado para definir a duração restante e atualizar a interface
  set _setRemainingDuration(Duration value) {
    if (_remainingDuration.inSeconds == value.inSeconds) return;
    _remainingDuration = value;
    update([kCountdownText_getbuilder]);
  }

  // Inicializa o controlador
  void init({
    required Duration maxDuration,
    required Duration timerDuration,
  }) {
    _maxDuration = maxDuration;
    _remainingDuration = timerDuration;
    _timerDuration = timerDuration;
    _circularLineDeg = animationValue * 360;
    update([kCountdownText_getbuilder, kCircularLine_getbuilder]);
  }

  // Define a duração do timer e atualiza a interface
  void setTimerDuration(Duration value) {
    _setRemainingDuration = value;
    _timerDuration = value;
    _circularLineDeg = animationValue * 360;
    update([kCircularLine_getbuilder]);
  }

  // Inicializa o controlador de animação
  @override
  void onInit() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animationController.addListener(_timerAnimationListener);
    super.onInit();
  }

  // Libera recursos quando o controlador é fechado
  @override
  void onClose() {
    _animationController.dispose();
    super.onClose();
  }

  // Listener para a animação do timer
  void _timerAnimationListener() {
    _setRemainingDuration = _maxDuration * _animationController.value;
    _circularLineDeg = _animationController.value * 360;
    update([kCircularLine_getbuilder, kCountdownText_getbuilder]);
  }

  // Método para reiniciar a animação do timer
  Future<void> restart() async {
    _animateBack = true;
    _animationController.value = animationValue;
    await _animationController.animateTo(1.0,
        duration: const Duration(milliseconds: 500));
    _animateBack = false;
  }
}
