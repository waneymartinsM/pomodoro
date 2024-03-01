import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomodoro/app/config/routes/routes_name.dart';
import 'package:pomodoro/app/controller/app_controller.dart';
import 'package:pomodoro/app/controller/app_settings_controller.dart';
import 'package:pomodoro/app/data/models/pomodoro_task_model.dart';
import 'package:pomodoro/app/presentation/pages/screens/add_pomodoro_task/add_pomodoro_task_screen.dart';
import 'package:pomodoro/app/presentation/pages/screens/home/home_page.dart';
import 'package:pomodoro/app/presentation/pages/screens/introduction/app_introduction_screen.dart';
import 'package:pomodoro/app/presentation/pages/screens/start_pomodoro_task/start_pomodoro_task_screen.dart';

// Um mapa de rotas associando nomes de rota a construtores de widgets:
final Map<String, WidgetBuilder> appRoutes = {
  RoutesName.appIntroductionScreen: (context) => const AppIntroductionScreen(),
  RoutesName.homeScreen: (context) => const HomePage(),
  RoutesName.startPomodoroTaskScreen: (context) =>
      const StartPomodoroTaskScreen(),
  RoutesName.addPomodoroTaskScreen: (context) => AddPomodoroTaskScreen(
      task: ModalRoute.of(context)!.settings.arguments as PomodoroTaskModel?),
};

// Função que é chamada quando a rota é gerada. Ela cria uma transição de slide entre as telas.
Route onGenerateRoute(RouteSettings settings) {
  final curveTween = CurveTween(curve: Curves.ease);
  final tweenOffset = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
      .chain(curveTween);
  return PageRouteBuilder(
    settings: settings,
    pageBuilder: (context, animation, secondaryAnimation) {
      return appRoutes[settings.name]!(context);
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: animation.drive(tweenOffset),
        child: child,
      );
    },
  );
}

// Função que determina as rotas iniciais ao iniciar a aplicação.
List<Route> onGenerateInitialRoutes(String initRoute) {
  if (initRoute == RoutesName.appIntroductionScreen) {
    return [
      MaterialPageRoute(builder: appRoutes[RoutesName.appIntroductionScreen]!),
    ];
  }
  return [
    MaterialPageRoute(builder: appRoutes[RoutesName.homeScreen]!),
    if (initRoute != RoutesName.homeScreen)
      MaterialPageRoute(
          builder: appRoutes[RoutesName.startPomodoroTaskScreen]!),
  ];
}

// Função que determina a rota inicial com base no estado da aplicação.
String getInitialRoute() {
  if (Get.find<AppController>().isTimerAlreadyStarted) {
    return '${RoutesName.homeScreen}/${RoutesName.startPomodoroTaskScreen}';
  }
  if (Get.find<AppSettingsController>().isFirstAppRun) {
    return RoutesName.appIntroductionScreen;
  }
  return RoutesName.homeScreen;
}
