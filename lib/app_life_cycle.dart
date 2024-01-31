import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomodoro/app/controller/app_controller.dart';

// Um widget que lida com os ciclos de vida do aplicativo.
class AppLifeCycle extends StatefulWidget {
  const AppLifeCycle({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  State<AppLifeCycle> createState() => _AppLifeCycleState();
}

class _AppLifeCycleState extends State<AppLifeCycle>
    with WidgetsBindingObserver {

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Este método é chamado quando o estado do ciclo de vida do aplicativo muda.

    // Se o aplicativo está no estado "paused" (em segundo plano), chama o método onAppPaused() do controlador.
    if (state == AppLifecycleState.paused) {
      Get.find<AppController>().onAppPaused();
    } else if (state == AppLifecycleState.resumed) {
      // Se o aplicativo está no estado "resumed" (em primeiro plano), chama o método init() do controlador.
      Get.find<AppController>().init();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    // Retorna o widget filho que será renderizado.
    return widget.child;
  }
}
