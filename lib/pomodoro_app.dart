import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pomodoro/app/config/localization/app_localization.dart';
import 'package:pomodoro/app/config/localization/localizations.dart';
import 'package:pomodoro/app/config/routes/app_routes.dart';
import 'package:pomodoro/app/controller/app_settings_controller.dart';
import 'package:pomodoro/app_life_cycle.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class PomodoroApp extends StatelessWidget {
  const PomodoroApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppLifeCycle(
      child: ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (_, __) {
            return GetBuilder<AppSettingsController>(
              initState: (_) => Get.find<AppSettingsController>().initializeTheme(),
              builder: (controller) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  // onGenerateTitle: (context) => AppLocalization.of(context).appName,
                  // localizationsDelegates: const [
                  //   GlobalMaterialLocalizations.delegate,
                  //   GlobalWidgetsLocalizations.delegate,
                  //   GlobalCupertinoLocalizations.delegate,
                  // ],
                  //supportedLocales: supportedLocales,
                  // locale: controller.localization.locale,
                  color: controller.theme.colorScheme.background,
                  theme: controller.theme,
                  onGenerateInitialRoutes: onGenerateInitialRoutes,
                  onGenerateRoute: onGenerateRoute,
                  initialRoute: getInitialRoute(),
                  builder: _builder,
                );
              },
            );
          }),
    );
  }

  Widget _builder(context, widget) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: widget!,
    );
  }
}
