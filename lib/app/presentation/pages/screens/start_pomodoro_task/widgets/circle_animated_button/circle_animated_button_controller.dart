import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'constant.dart';
import 'enum.dart';

class CircleAnimatedButtonController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<AlignmentGeometry?> animationLeft;
  late final Animation<AlignmentGeometry?> animationRight;
  late CircleAnimatedButtonStatus _circleButtonStatus;

  // Quando [inProgress] é verdadeiro, o botão não responde ao toque do usuário
  bool inProgress = false;
  double _turns = 0.0;

  bool get showPlayIcon => isFinished ? true : isPaused;
  bool get isStarted => _circleButtonStatus.isStarted;
  bool get isPaused => _circleButtonStatus.isPaused;
  bool get isResumed => _circleButtonStatus.isResumed;
  bool get isFinished => _circleButtonStatus.isFinished;
  double get turns => _turns;

  // Inicializa o controlador com um status inicial
  void init(CircleAnimatedButtonStatus status) {
    _circleButtonStatus = status;
    if (isFinished) {
      _animationController.value = 0.0;
    } else {
      _animationController.value = 1.0;
    }
    // Atualiza os componentes de interface do usuário relacionados aos botões
    update([
      kCancelButton_getBuilderKey,
      kRestartButton_getBuilderKey,
      kMainButton_getBuilderKey
    ]);
  }

  @override
  void onInit() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _animationController.addListener(
      () => update([kCancelButton_getBuilderKey, kRestartButton_getBuilderKey]),
    );

    // Configura as animações para a esquerda e direita
    animationLeft = _animationController.drive(
      AlignmentGeometryTween(
        begin: AlignmentDirectional.center,
        end: AlignmentDirectional.centerStart,
      ),
    );
    animationRight = _animationController.drive(
      AlignmentGeometryTween(
        begin: AlignmentDirectional.center,
        end: AlignmentDirectional.centerEnd,
      ),
    );
    super.onInit();
  }

  @override
  void onClose() {
    _animationController.dispose();
    super.onClose();
  }

  // Inicia a animação
  Future<void> startAnimation() async {
    _circleButtonStatus = CircleAnimatedButtonStatus.started;
    update([kMainButton_getBuilderKey]);
    await _startAnimations();
  }

  // Reinicia a animação
  void restartAnimation() {
    _circleButtonStatus = CircleAnimatedButtonStatus.started;
    _turns += 1;
    update([kRestartButton_getBuilderKey, kMainButton_getBuilderKey]);
  }

  // Pausa a animação
  void pauseAnimation() {
    _circleButtonStatus = CircleAnimatedButtonStatus.pause;
    update([kMainButton_getBuilderKey]);
  }

  // Retoma a animação
  void resumeAnimation() {
    _circleButtonStatus = CircleAnimatedButtonStatus.resumed;
    update([kMainButton_getBuilderKey]);
  }

  // Conclui a animação
  Future<void> finishAnimation() async {
    _circleButtonStatus = CircleAnimatedButtonStatus.finished;
    update([kMainButton_getBuilderKey]);
    await _startAnimations();
  }

  // Inicia ou reverte as animações
  Future<void> _startAnimations() async {
    inProgress = true;
    if (isFinished) {
      await _animationController.reverse();
    } else {
      await _animationController.forward();
    }
    inProgress = false;
  }
}
