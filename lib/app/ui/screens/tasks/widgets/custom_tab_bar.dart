import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pomodoro/app/config/localization/app_localization.dart';
import 'package:pomodoro/app/config/theme/app_colors.dart';
import 'package:pomodoro/app/ui/screens/tasks/tasks_controller.dart';
import 'package:pomodoro/app/utils/extensions/extensions.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = AppLocalization.of(context);
    final TasksController controller = Get.find();
    return Container(
      height: 50.h,
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        gradient: [
          theme.primaryColorLight,
          theme.primaryColorDark,
        ].getLinearGradient,
        boxShadow: [
          BoxShadow(
            offset: const Offset(3, 3),
            blurRadius: 5,
            spreadRadius: 2,
            color: theme.shadowColor.withOpacity(0.2),
          ),
        ],
      ),
      child: TabBar(
        labelStyle: TextStyle(fontSize: 15.sp),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        labelPadding: EdgeInsets.zero,
        indicatorPadding: EdgeInsets.zero,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white30,
        ),
        tabs: [
          Obx(
            () => TabBarLabel(
              label: localization.tasksScreenAll,
              suffix: controller.allTasks.length.toString(),
            ),
          ),
          Obx(
            () => TabBarLabel(
              label: localization.tasksScreenDone,
              suffix: controller.doneTasks.length.toString(),
            ),
          ),
          Obx(
            () => TabBarLabel(
              label: localization.tasksScreenRemain,
              suffix: controller.remainedTasks.length.toString(),
            ),
          ),
        ],
      ),
    );
  }

  Size get preferredSize => Size(0, 50.h);
}

class TabBarLabel extends StatelessWidget {
  const TabBarLabel({
    Key? key,
    required this.label,
    required this.suffix,
  }) : super(key: key);

  final String label;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label),
          5.horizontalSpace,
          Container(
            width: 25.w,
            height: 25.w,
            alignment: AlignmentDirectional.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: AppColors.white.withOpacity(0.3),
            ),
            child: Text(
              localization.convertNumber(suffix),
            ),
          ),
        ],
      ),
    );
  }
}
