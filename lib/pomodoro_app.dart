import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pomodoro/app/config/routes/app_routes.dart';
import 'package:pomodoro/app/controller/app_settings_controller.dart';
import 'package:pomodoro/app/core/utils/custom_colors.dart';
import 'package:pomodoro/app_life_cycle.dart';

class PomodoroApp extends StatelessWidget {
  const PomodoroApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppLifeCycle(
      child: ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (_, __) {
            return GetBuilder<AppSettingsController>(
              builder: (controller) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  onGenerateInitialRoutes: onGenerateInitialRoutes,
                  onGenerateRoute: onGenerateRoute,
                  initialRoute: getInitialRoute(),
                  builder: (context, widget) {
                    return MediaQuery(
                      data:
                          MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: widget!,
                    );
                  },
                );
              },
            );
          }),
    );
  }
}
