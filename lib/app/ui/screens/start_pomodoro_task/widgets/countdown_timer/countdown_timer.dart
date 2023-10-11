import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pomodoro/app/controller/app_settings_controller.dart';
import 'package:pomodoro/app/core/utils/custom_colors.dart';
import 'package:pomodoro/app/ui/screens/start_pomodoro_task/widgets/countdown_timer/controller/circular_rotational_lines_controller.dart';
import 'package:pomodoro/app/ui/screens/start_pomodoro_task/widgets/countdown_timer/controller/timer_animations_controller.dart';
import 'controller/countdown_timer_controller.dart';
import 'constants.dart';
import 'custom_painters/circular_line_painter.dart';
import 'custom_painters/clock_lines_painter.dart';
import 'custom_painters/circular_background_line_painter.dart';
import 'custom_painters/circular_rotational_lines_painter.dart';
import '../animated_text_style.dart';
import 'widgets/countdown_timer_text.dart';

class CountdownTimer extends StatelessWidget {
  CountdownTimer({
    Key? key,
  }) : super(key: key);

  final appSettings = Get.find<AppSettingsController>();

  @override
  Widget build(BuildContext context) {
    const double radius = 95;
    const double strokeWidth = 30;
    const double areaSize = radius * 2 + strokeWidth;
    const Size customPaintSize = Size.square(areaSize);
    final theme = Theme.of(context);
    final colors = [const Color(0xFFCC6F76), const Color(0xFFA0575D)];

    return SizedBox(
      width: areaSize,
      height: areaSize,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          // Cria uma pintura de fundo circular com sombra
          RepaintBoundary(
            child: CustomPaint(
              painter: CircularBackgroundLinePainter(
                radius: radius,
                strokeWidth: strokeWidth,
                backgroundColor: CustomColors.white.withOpacity(0.1),
                shadowColor: CustomColors.pinkMain.withOpacity(0.5),
              ),
            ),
          ),

          // Cria linhas do relógio quando o temporizador não está ativo
          RepaintBoundary(
            child: GetBuilder<CircularRotationalLinesController>(
              id: kClockLines_getbuilder,
              builder: (controller) => CustomPaint(
                painter: ClockLinesPainter(
                  hide: controller.isStarted,
                  radius: radius + strokeWidth + 10,
                  colors: colors,
                ),
              ),
            ),
          ),

          // Cria a linha circular de contagem regressiva animada
          RepaintBoundary(
            child: GetBuilder<TimerAnimationsController>(
              id: kCircularLine_getbuilder,
              builder: (controller) => CustomPaint(
                size: customPaintSize,
                painter: CircularLinePainter(
                  radius: radius,
                  strokeWidth: strokeWidth,
                  currentDeg: controller.circularLineDeg,
                  colors: colors,
                ),
              ),
            ),
          ),

          // Cria linhas circulares rotacionais animadas
          RepaintBoundary(
            child: GetBuilder<CircularRotationalLinesController>(
              id: kCircularRotationalLines_getbuilder,
              builder: (controller) => CustomPaint(
                size: customPaintSize,
                painter: CircularRotationalLinesPainter(
                  showRotationalLines: controller.isStarted,
                  radius: radius,
                  strokeWidth: strokeWidth,
                  spaceBetweenRotationalLines:
                      controller.spaceBetweenRotationalLines * 10.r,
                  rotationalLinesDeg: controller.circularLinesDeg,
                  colors: colors,
                ),
              ),
            ),
          ),

          // Cria um círculo central com texto animado
          RepaintBoundary(
            child: Container(
              alignment: AlignmentDirectional.center,
              width: areaSize,
              height: areaSize,
              child: CircleAvatar(
                radius: radius,
                backgroundColor: CustomColors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Cria o texto animado para a contagem regressiva
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: GetBuilder<TimerAnimationsController>(
                        id: kCountdownText_getbuilder,
                        builder: (controller) {
                          return CountdownTimerText(
                            remainingDuration: controller.remainingDuration,
                            animateBack: controller.animateBack,
                          );
                        },
                      ),
                    ),

                    // Cria o subtítulo animado
                    GetBuilder<CountdownTimerController>(
                      id: kSubtitleText_getbuilder,
                      builder: (controller) {
                        return AnimatedTextStyle(
                          text: controller.subtitleText,
                          textStyle: const TextStyle(
                              fontSize: 0,
                              inherit: false,
                              color: Colors.deepPurple),
                          secondTextStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: CustomColors.pinkMain,
                            inherit: false,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
