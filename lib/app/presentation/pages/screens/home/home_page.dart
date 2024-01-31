import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomodoro/app/config/routes/routes_name.dart';
import 'package:pomodoro/app/core/utils/custom_colors.dart';
import 'package:pomodoro/app/data/models/pomodoro_task_model.dart';
import 'package:pomodoro/app/presentation/pages/screens/tasks/tasks_controller.dart';
import 'package:pomodoro/app/presentation/pages/screens/tasks/widgets/custom_tab_bar_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  late final TasksController controller;

  @override
  void initState() {
    super.initState();
    Get.put(TasksController());
    controller = Get.find<TasksController>();
  }

  @override
  bool get wantKeepAlive => true; // Indicar deseja manter o estado vivo

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: CustomColors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: CustomColors.white,
          title: Text(
            "Pomodoro",
            style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: CustomColors.black),
          ),
        ),
        body: CustomTabBarView(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
      ),
    );
  }
}
