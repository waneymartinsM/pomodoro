import 'package:get/get.dart';
import 'package:pomodoro/app/ui/screens/start_pomodoro_task/widgets/countdown_timer/controller/timer_animations_controller.dart';
import 'package:pomodoro/app/ui/screens/start_pomodoro_task/widgets/countdown_timer/enum.dart';
import 'circular_rotational_lines_controller.dart';
import '../constants.dart';

class CountdownTimerController extends GetxController {
  final _circularRotationalLinesController =
      Get.put(CircularRotationalLinesController());
  final _timerAnimationsController = Get.put(TimerAnimationsController());

  String? _subtitleText;

  String? get subtitleText => _subtitleText;

  set subtitleText(String? text) {
    _subtitleText = text;
    update([kSubtitleText_getbuilder]);
  }

  // Setter para a duração máxima do timer
  set maxDuration(Duration maxDuration) {
    _timerAnimationsController.maxDuration = maxDuration;
  }

  void init({
    String? subtitleText,
    required Duration maxDuration,
    required Duration timerDuration,
    required CountdownTimerStatus status,
  }) {
    _timerAnimationsController.init(
      maxDuration: maxDuration,
      timerDuration: timerDuration,
    );
    _circularRotationalLinesController.init(status);
    _subtitleText = subtitleText;
    update([kSubtitleText_getbuilder]);
  }

  // Remoção dos controladores quando o controlador CountdownTimerController é fechado
  @override
  void onClose() {
    Get.delete<CircularRotationalLinesController>();
    Get.delete<TimerAnimationsController>();
    super.onClose();
  }

  // Método para alterar o status do contador regressivo
  void changeStatus(CountdownTimerStatus status) {
    _circularRotationalLinesController.changeStatus(status);
  }

  // Método para definir a duração do timer
  void setTimerDuration(Duration value) {
    _timerAnimationsController.setTimerDuration(value);
  }

  // Método para reiniciar o timer
  Future<void> restart() async {
    await _timerAnimationsController.restart();
  }
}
