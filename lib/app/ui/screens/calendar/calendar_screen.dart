import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomodoro/app/config/localization/app_localization.dart';
import 'package:pomodoro/app/config/localization/app_localization_data.dart';
import 'package:pomodoro/app/core/utils/custom_colors.dart';
import 'package:pomodoro/app/ui/screens/calendar/widgets/calendar_screen_error_snackbar.dart';
import 'package:pomodoro/app/ui/screens/calendar/widgets/calendar_task_not_found_snackbar.dart';
import 'calendar_screen_controller.dart';
import 'widgets/custom_date_picker/custom_date_picker.dart';
import 'widgets/tasks_reportage_list_view/tasks_reportage_list_view.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with AutomaticKeepAliveClientMixin {
  late ThemeData theme;
  late AppLocalizationData localization;
  late final CalendarScreenController controller;

  @override
  void initState() {
    controller = Get.find();
    controller.screenNotifier.listen((event) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (event.isTaskNotFound) {
        showCalendarTaskNotFoundSnackBar(context);
      } else {
        showCalendarScreenErrorSnackbar(context);
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    theme = Theme.of(context);
    localization = AppLocalization.of(context);
    super.didChangeDependencies();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: CustomColors.white,
      appBar: AppBar(
        backgroundColor: CustomColors.white,
        elevation: 0,
        centerTitle: true,
        title: Text("Calendário",
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w400,
            )),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GetBuilder(
              global: false,
              init: controller,
              builder: (_) {
                return CustomDatePicker(
                  controller: controller.datePickerController,
                );
              }),
          const Expanded(child: TasksReportageListView()),
        ],
      ),
    );
  }
}
