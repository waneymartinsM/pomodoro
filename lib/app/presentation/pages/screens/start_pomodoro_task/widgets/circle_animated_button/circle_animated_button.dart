import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomodoro/app/core/utils/custom_colors.dart';
import 'package:pomodoro/app/presentation/widgets/custom_animated_icon.dart';
import 'constant.dart';
import 'circle_animated_button_controller.dart';

class CircleAnimatedButton extends StatelessWidget {
  const CircleAnimatedButton({
    this.onStart,
    this.onPause,
    this.onResume,
    this.onFinish,
    this.onRestart,
    super.key,
  });

  final VoidCallback? onStart;
  final VoidCallback? onPause;
  final VoidCallback? onResume;
  final VoidCallback? onFinish;
  final VoidCallback? onRestart;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GetBuilder<CircleAnimatedButtonController>(
            id: kCancelButton_getBuilderKey,
            builder: (controller) {
              return InkWell(
                onTap: () {
                  if (controller.inProgress) return;
                  controller.finishAnimation();
                  onFinish?.call();
                },
                child: const CircleAvatar(
                  radius: 40,
                  backgroundColor: CustomColors.lightGrey,
                  child: Icon(Icons.stop,
                      color: CustomColors.mediumGrey, size: 30),
                ),
              );
            },
          ),
          GetBuilder<CircleAnimatedButtonController>(
            id: kMainButton_getBuilderKey,
            builder: (controller) {
              return InkWell(
                onTap: () {
                  if (controller.inProgress) return;
                  controller.inProgress = true;
                  if (controller.isFinished) {
                    controller.startAnimation();
                    onStart?.call();
                    return;
                  }
                  if (controller.isPaused) {
                    controller.resumeAnimation();
                    onResume?.call();
                  } else if (controller.isResumed || controller.isStarted) {
                    controller.pauseAnimation();
                    onPause?.call();
                  }
                },
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: CustomColors.pinkMain,
                  child: CustomAnimatedIcon(
                    showSecondIcon: controller.showPlayIcon,
                    color: Colors.white,
                    icon: AnimatedIcons.pause_play,
                    onAnimationDone: () {
                      controller.inProgress = false;
                    },
                  ),
                ),
              );
            },
          ),
          GetBuilder<CircleAnimatedButtonController>(
            id: kRestartButton_getBuilderKey,
            builder: (controller) {
              return InkWell(
                onTap: () {
                  if (controller.inProgress) return;
                  controller.inProgress = true;
                  controller.restartAnimation();
                  onRestart?.call();
                },
                child: AnimatedRotation(
                  duration: const Duration(milliseconds: 500),
                  turns: controller.turns,
                  onEnd: () {
                    controller.inProgress = false;
                  },
                  child: const CircleAvatar(
                    radius: 40,
                    backgroundColor: CustomColors.lightGrey,
                    child: Icon(Icons.refresh,
                        color: CustomColors.mediumGrey, size: 30),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

