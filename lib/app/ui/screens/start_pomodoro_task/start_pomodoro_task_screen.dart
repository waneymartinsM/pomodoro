import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomodoro/app/controller/app_controller.dart';
import 'package:pomodoro/app/core/utils/custom_colors.dart';
import 'package:pomodoro/app/ui/screens/start_pomodoro_task/widgets/gradient_text.dart';
import 'package:pomodoro/app/utils/overlays/snackbars/mute_alert_snackbar.dart';
import 'start_pomodoro_task_screen_controller.dart';
import 'widgets/animated_text_style.dart';
import 'widgets/circle_animated_button/circle_animated_button.dart';
import 'widgets/countdown_timer/countdown_timer.dart';

import 'widgets/pomodoro_finish_snackbar.dart';

class StartPomodoroTaskScreen extends StatefulWidget {
  const StartPomodoroTaskScreen({Key? key}) : super(key: key);

  @override
  State<StartPomodoroTaskScreen> createState() =>
      _StartPomodoroTaskScreenState();
}

class _StartPomodoroTaskScreenState extends State<StartPomodoroTaskScreen> {
  late ThemeData theme;
  @override
  void initState() {
    final controller = Get.find<StartPomodoroTaskScreenController>();
    controller.screenNotifier.listen((event) {
      Future.delayed(
        const Duration(milliseconds: 700),
        () {
          if (!mounted) return; // Verifica se o widget ainda está montado.
          ScaffoldMessenger.of(context)
              .clearSnackBars(); // Remove barras de aviso.
          if (event.isShowPomodoroFinishSnackbar) {
            showPomodoroFinishSnackBar(
                context); // Exibe uma barra de aviso de término do Pomodoro.
          } else {
            showMuteAlertSnackBar(
                context, "As configurações de som estão no modo silencioso.",
                height: 60); // Exibe um aviso de som desligado.
          }
        },
      );
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    theme = Theme.of(context); // Obtém o tema atual do contexto.
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    Get.delete<StartPomodoroTaskScreenController>(); // Remove o controlador da tela.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StartPomodoroTaskScreenController>();

    return WillPopScope(
      onWillPop: () async {
        if (controller.isTimerStarted) {
          await Get.find<AppController>().onAppPaused(); // Pausa a aplicação.
          SystemNavigator.pop();
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: Obx(() {
          return AnimatedContainer(
            duration: const Duration(seconds: 1),
            padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 20),
            height: ScreenUtil().screenHeight,
            width: ScreenUtil().screenWidth,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: AlignmentDirectional.topCenter,
                end: AlignmentDirectional.bottomCenter,
                colors: [
                  controller.showLinerGradientColors
                      ? CustomColors.pinkMain
                      : const Color(0xFFFFBDC2),
                  CustomColors.white,
                ],
                stops: const [0.1, 0.7],
              ),
            ),
            child: const _Body(),
          );
        }),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StartPomodoroTaskScreenController controller = Get.find();
    final theme = Theme.of(context);

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const _AppBar(),
          const SizedBox(height: 5),
          CountdownTimer(),
          const SizedBox(),
          Container(
            alignment: AlignmentDirectional.center,
            height: 50,
            child: Obx(
              () => GradientText(
                colors: const [CustomColors.mediumGrey, CustomColors.black],
                text: AnimatedTextStyle(
                  text: controller.pomodoroText,
                  textStyle: const TextStyle(
                      fontFamily: 'Poppins', fontSize: 0, inherit: false),
                  secondTextStyle: theme.primaryTextTheme.bodyLarge!,
                ),
              ),
            ),
          ),
          CircleAnimatedButton(
            onStart: controller.start,
            onPause: controller.pause,
            onResume: controller.resume,
            onFinish: () {
              controller.cancel();
              Navigator.pop(context);
            },
            onRestart: controller.onRestart,
          ),
        ],
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StartPomodoroTaskScreenController controller = Get.find();
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Text(
        controller.taskTitle,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: CustomColors.white),
        overflow: TextOverflow.ellipsis,
      ),
      centerTitle: true,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.keyboard_arrow_left_rounded,
            size: 27, color: CustomColors.white),
        onPressed: () {
          if (!controller.isTimerStarted) return Navigator.pop(context);
          showBackAlertDialog(
            context,
            onContinue: () {
              Navigator.pop(context);
            },
            onCancel: () {
              controller.cancel();
              Navigator.pop(context);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}

void showBackAlertDialog(
  BuildContext context, {
  VoidCallback? onCancel,
  VoidCallback? onContinue,
}) {
  showDialog(
    context: context,
    builder: (_) => Center(
      child: Container(
        height: 200,
        width: 300,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: CustomColors.white, borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Deseja mesmo encerrar a sessão?",
              style: GoogleFonts.poppins(
                color: CustomColors.black,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    onCancel?.call();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.mediumGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Text("Cancelar",
                      style: GoogleFonts.poppins(
                          color: CustomColors.white, fontSize: 14)),
                ),
                ElevatedButton(
                  onPressed: () {
                    onContinue?.call();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.pinkMain,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text("Continuar",
                      style: GoogleFonts.poppins(
                          color: CustomColors.white, fontSize: 14)),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
