import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomodoro/app/config/routes/routes_name.dart';
import 'package:pomodoro/app/core/utils/custom_colors.dart';
import 'package:pomodoro/app/data/models/pomodoro_task_model.dart';
import 'package:pomodoro/app/ui/screens/calendar/calendar_screen.dart';
import 'package:pomodoro/app/ui/screens/calendar/calendar_screen_controller.dart';
import 'package:pomodoro/app/ui/screens/home/widgets/custom_bottom_navigation_bar.dart';
import 'package:pomodoro/app/ui/screens/tasks/tasks_controller.dart';
import 'package:pomodoro/app/ui/screens/tasks/tasks_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final screens = const [TasksScreen(), CalendarScreen()];
  final PageController pageController = PageController();

  @override
  void initState() {
    Get.put(TasksController());
    Get.put(CalendarScreenController());
    // Future.delayed(const Duration(seconds: 2), () async {
    //   if (await Permission.notification.isGranted == false) {
    //    // await showNotificationPermissionDialog(context);
    //    // await Permission.notification.request();
    //   }
    //   if (await Permission.ignoreBatteryOptimizations.isGranted == false) {
    //     //await Permission.ignoreBatteryOptimizations.request();
    //   }
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.white,
      resizeToAvoidBottomInset: false,
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: screens,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        onChange: (currentIndex) {
          pageController.animateToPage(
            currentIndex,
            duration: const Duration(milliseconds: 250),
            curve: Curves.linear,
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: 70,
        height: 70,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.pushNamed(
                context, RoutesName.addPomodoroTaskScreen);
            if (result == null) return;
            Get.find<TasksController>().addTask(result as PomodoroTaskModel);
          },
          backgroundColor: CustomColors.pinkMain,
          child: const Icon(Icons.add, color: CustomColors.white, size: 30),
        ),
      ),
    );
  }
}
