import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomodoro/app/config/localization/app_localization.dart';
import 'package:pomodoro/app/config/routes/routes_name.dart';
import 'package:pomodoro/app/controller/app_controller.dart';
import 'package:pomodoro/app/core/utils/custom_colors.dart';
import 'package:pomodoro/app/data/models/pomodoro_task_model.dart';
import 'package:pomodoro/app/ui/screens/tasks/tasks_controller.dart';
import 'package:pomodoro/app/ui/widgets/empty_list.dart';
import 'task_info_widget.dart';

class CustomTabBarView extends StatelessWidget {
  CustomTabBarView({Key? key}) : super(key: key);

  final TasksController controller = Get.find();

  void startPomodoroTask(PomodoroTaskModel task, BuildContext context) {
    Get.find<AppController>().onPomodoroTaskStart(task);
    Navigator.pushNamed(
      context,
      RoutesName.startPomodoroTaskScreen,
    );
  }

  void editTask(PomodoroTaskModel task, BuildContext context) async {
    final result = await Navigator.pushNamed(
      context,
      RoutesName.addPomodoroTaskScreen,
      arguments: task,
    );
    if (result == null) return;
    controller.updateTask(result as PomodoroTaskModel);
  }

  Widget taskWidgetBuilder(
    BuildContext context,
    int index,
    List<PomodoroTaskModel> tasks,
    Animation<double> animation,
  ) {
    final task = tasks[index];
    return TaskInfoWidget(
      task: task,
      animation: animation,
      onCircleButtonPressed: () => startPomodoroTask(task, context),
      onDeletePressed: () => controller.deleteTask(task.id!),
      onEditPressed: () => editTask(task, context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    return TabBarView(
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Stack(
          children: [
            Obx(
              () => AnimatedList(
                key: controller.allTasksListKey,
                initialItemCount: controller.allTasks.length,
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemBuilder: (context, index, animation) => taskWidgetBuilder(
                    context, index, controller.allTasks, animation),
              ),
            ),
            Obx(
              () {
                if (controller.allTasksListStatus.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (controller.allTasksListStatus.isError) {
                  return Center(
                      child: Text("Ocorreu um erro!",
                          style: GoogleFonts.poppins()));
                } else if (controller.allTasks.isEmpty &&
                    controller.isAnimatingInitialValues == false) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/business.svg',
                          color: CustomColors.mediumGrey,
                          height: 150,
                          width: 150,
                          fit: BoxFit.fill,
                        ),
                        const SizedBox(height: 20),
                        Text("Nenhuma tarefa disponível",
                            style:
                                GoogleFonts.poppins(color: CustomColors.black)),
                        const SizedBox(height: 10),
                        Text(
                          "Adicione alguma tarefa usando o botão 'Adicionar' abaixo.",
                          style: GoogleFonts.poppins(
                              color: CustomColors.black,
                              fontWeight: FontWeight.w300,
                              fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
        Stack(
          children: [
            Obx(
              () => AnimatedList(
                key: controller.doneTasksListKey,
                initialItemCount: controller.doneTasks.length,
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemBuilder: (context, index, animation) => taskWidgetBuilder(
                    context, index, controller.doneTasks, animation),
              ),
            ),
            Obx(
              () {
                if (controller.doneTasksListStatus.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (controller.doneTasksListStatus.isError) {
                  return Center(
                      child: Text("Ocorreu um erro!",
                          style: GoogleFonts.poppins()));
                } else if (controller.doneTasks.isEmpty) {
                  return EmptyList(
                    size: 180,
                    assetIcon: 'assets/icons/business.svg',
                    title: localization.tasksScreenNoDoneTasksTitle,
                    description: localization.tasksScreenNoDoneTasksDescription,
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
        Stack(
          children: [
            Obx(
              () => AnimatedList(
                key: controller.remainedTasksListKey,
                initialItemCount: controller.remainedTasks.length,
                padding: EdgeInsets.symmetric(vertical: 10.h),
                itemBuilder: (context, index, animation) => taskWidgetBuilder(
                    context, index, controller.remainedTasks, animation),
              ),
            ),
            Obx(
              () {
                if (controller.remainedTasksListStatus.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (controller.remainedTasksListStatus.isError) {
                  return Center(
                      child: Text("Ocorreu um erro!",
                          style: GoogleFonts.poppins()));
                } else if (controller.remainedTasks.isEmpty) {
                  return EmptyList(
                    size: 180.h,
                    assetIcon: 'assets/icons/business.svg',
                    title: localization.tasksScreenNoRemainedTasksTitle,
                    description:
                        localization.tasksScreenNoRemainedTasksDescription,
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ],
    );
  }
}
