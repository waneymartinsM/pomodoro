import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomodoro/app/core/utils/custom_colors.dart';
import 'package:pomodoro/app/data/models/pomodoro_task_reportage_model.dart';
import 'package:pomodoro/app/utils/extensions/extensions.dart';

class TaskReportageWidget extends StatelessWidget {
  const TaskReportageWidget({
    Key? key,
    required this.task,
    required this.height,
  }) : super(key: key);

  final PomodoroTaskReportageModel task;
  final double height;

  String convertDateToString(DateTime date) {
    final hour = date.hour > 12
        ? (date.hour - 12).toString().padLeft(2, '0')
        : date.hour.toString().padLeft(2, '0');
    final min = date.minute.toString().padLeft(2, '0');
    final amPm = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$min $amPm';
  }

  List<Color> getColors(ThemeData theme) {
    if (task.taskStatus.isCompleted) {
      return [
        const Color(0xFFA4CB6E),
        const Color(0xFFB6D58B),
      ];
    } else {
      return [
        const Color(0xFFFFD0D4),
        CustomColors.pinkMain,
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: height,
      alignment: AlignmentDirectional.center,
      padding: const EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            convertDateToString(task.startDate),
            style: GoogleFonts.poppins(
                fontSize: 14, color: CustomColors.mediumGrey),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Container(
              alignment: AlignmentDirectional.centerStart,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: getColors(theme).getLinearGradient,
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 3,
                    spreadRadius: 1,
                    color: Color.fromARGB(24, 0, 0, 0),
                    offset: Offset(3, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          task.taskName,
                          style: GoogleFonts.poppins(
                            color: CustomColors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 5.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Text(
                          task.taskStatus.isCompleted
                              ? "Concluído"
                              : "Incompleto",
                          style: GoogleFonts.poppins(
                            color: CustomColors.mediumGrey,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${convertDateToString(task.startDate)} - ${convertDateToString(task.endDate!)}',
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: CustomColors.white,
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
