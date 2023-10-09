import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomodoro/app/core/utils/custom_colors.dart';
import 'package:pomodoro/app/ui/screens/tasks/tasks_controller.dart';
import 'widgets/custom_tab_bar_view.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen>
    with AutomaticKeepAliveClientMixin {
  late final TasksController controller;

  @override
  void initState() {
    controller = Get.find<TasksController>();
    super.initState();
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
            backgroundColor: CustomColors.white,
            title: buildTextAppBar()),
        body: CustomTabBarView(),
      ),
    );
  }

  Text buildTextAppBar() {
    return Text("Pomodoro",
        style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w400));
  }
}
