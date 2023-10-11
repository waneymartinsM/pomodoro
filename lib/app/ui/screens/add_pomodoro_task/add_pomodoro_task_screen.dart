import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomodoro/app/config/localization/app_localization.dart';
import 'package:pomodoro/app/config/localization/app_localization_data.dart';
import 'package:pomodoro/app/core/utils/custom_colors.dart';
import 'package:pomodoro/app/data/models/pomodoro_task_model.dart';
import 'package:pomodoro/app/ui/screens/add_pomodoro_task/add_pomodoro_task_screen_controller.dart';
import 'package:pomodoro/app/ui/screens/add_pomodoro_task/widgets/animated_slide_visibility.dart';
import 'package:pomodoro/app/ui/screens/add_pomodoro_task/widgets/list_tile_switch.dart';
import 'package:pomodoro/app/ui/widgets/background_container.dart';
import 'package:pomodoro/app/utils/helpers/value_state_builder.dart';
import 'widgets/horizontal_number_picker.dart';
import 'widgets/tone_picker.dart';
import 'widgets/volume_picker/volume_picker.dart';

class AddPomodoroTaskScreen extends StatefulWidget {
  const AddPomodoroTaskScreen({Key? key, this.task}) : super(key: key);
  final PomodoroTaskModel? task;
  @override
  State<AddPomodoroTaskScreen> createState() => _AddPomodoroTaskScreenState();
}

class _AddPomodoroTaskScreenState extends State<AddPomodoroTaskScreen> {
  late final AddPomodoroTaskScreenController controller;
  late ThemeData theme;
  late AppLocalizationData localization;
  @override
  void initState() {
    controller = Get.put(AddPomodoroTaskScreenController(widget.task));
    super.initState();
  }

  // Obtém o tema e localização da aplicação
  @override
  void didChangeDependencies() {
    theme = Theme.of(context);
    localization = AppLocalization.of(context);
    super.didChangeDependencies();
  }

  // Remove o controlador quando a tela é fechada
  @override
  void dispose() {
    Get.delete<AddPomodoroTaskScreenController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CustomColors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          splashRadius: 30.r,
          icon: const Icon(
            Icons.keyboard_arrow_left_rounded,
            size: 27,
            color: CustomColors.mediumGrey,
          ),
        ),
        title: Text(
          "Adicionar nova tarefa",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            controller: controller.scrollController,
            padding: const EdgeInsetsDirectional.fromSTEB(10, 15, 10, 80),
            children: [
              _buildTaskTitle(),
              const SizedBox(height: 30),
              _buildPomodoroSettings(),
              const SizedBox(height: 30),
              _buildSoundSettings(),
            ],
          ),
          _buildAddTask(),
        ],
      ),
    );
  }

  // Constrói o campo de título da tarefa
  Widget _buildTaskTitle() {
    return Obx(
      () => BackgroundContainer(
        padding: EdgeInsetsDirectional.fromSTEB(
            15, 0, 15, controller.titleError.value ? 10 : 0),
        child: Form(
          key: controller.formKey,
          child: TextFormField(
            initialValue: controller.title,
            validator: (text) => controller.titleValidator(text),
            cursorColor: CustomColors.mediumGrey,
            onSaved: controller.titleSaver,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Título da Tarefa",
              hintStyle: GoogleFonts.poppins(
                  color: CustomColors.mediumGrey,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ),
    );
  }

  // Constrói as configurações do Pomodoro (número de rounds, durações)
  Widget _buildPomodoroSettings() {
    return BackgroundContainer(
      height: 450,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HorizontalNumberPicker(
                min: 1,
                max: 10,
                title: "Rounds",
                suffix: "Intervalos",
                height: 80,
                width: constraints.maxWidth,
                initialNumber: controller.maxPomodoroRound,
                onSelectedItemChanged: controller.onMaxPomodoroRoundChange,
              ),
              HorizontalNumberPicker(
                min: 15,
                max: 90,
                title: "Intervalo de Trabalho",
                suffix: "Minutos",
                initialNumber: controller.workDuration,
                height: 80,
                width: constraints.maxWidth,
                onSelectedItemChanged: (int selectedNumber) {
                  controller.workDuration = selectedNumber;
                },
              ),
              Obx(
                () => HorizontalNumberPicker(
                  min: 1,
                  max: 15,
                  isActive: controller.isShortBreakPickerActive,
                  title: "Intervalo Curto",
                  suffix: "Minutos",
                  height: 80,
                  width: constraints.maxWidth,
                  initialNumber: controller.shortBreakDuration,
                  onSelectedItemChanged: (int selectedNumber) {
                    controller.shortBreakDuration = selectedNumber;
                  },
                ),
              ),
              HorizontalNumberPicker(
                min: 0,
                max: 30,
                title: "Intervalo Longo",
                suffix: "Minutos",
                height: 80,
                width: constraints.maxWidth,
                initialNumber: controller.longBreakDuration,
                onSelectedItemChanged: (int selectedNumber) {
                  controller.longBreakDuration = selectedNumber;
                },
              ),
            ],
          );
        },
      ),
    );
  }

  // Constrói as configurações de som (vibração, tom, volume)
  Widget _buildSoundSettings() {
    return BackgroundContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTileSwitch(
            defaultValue: controller.vibrate,
            title: "Vibração",
            description: "Adicione vibração quando um evento acontecer.",
            onChange: (bool value) {
              controller.vibrate = value;
            },
          ),
          const SizedBox(height: 20),
          //valueStateBuilder(),
          TonePicker(),
        ],
      ),
    );
  }

  // Constrói o botão para adicionar a tarefa
  Widget _buildAddTask() {
    return Align(
      alignment: AlignmentDirectional.bottomCenter,
      child: Padding(
        padding: EdgeInsets.all(8.r),
        child: SizedBox(
          height: 50,
          width: 300,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.pinkMain,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            onPressed: () {
              final result = controller.addTask();
              if ((result != null)) {
                Navigator.pop(context, result);
              }
            },
            child: Text("Adicionar", style: GoogleFonts.poppins()),
          ),
        ),
      ),
    );
  }

  ValueStateBuilder<bool> valueStateBuilder() {
    return ValueStateBuilder<bool>(
      initialValue: false,
      builder: (context, show, updater) {
        return AnimatedSlideVisibility(
          show: show,
          maxHeight: 110,
          minHeight: 60,
          childHeight: 60,
          title: Container(
            color: CustomColors.lightGrey,
            child: ListTileSwitch(
              defaultValue: controller.readStatusAloud,
              title: localization.addPomodoroScreenReadStatusTitle,
              description: localization.addPomodoroScreenReadStatusDescription,
              onChange: (bool value) {
                controller.readStatusAloud = value;
              },
              titleSuffix: GestureDetector(
                onTap: () {
                  updater(!show);
                },
                child: Icon(show ? Icons.arrow_drop_up : Icons.arrow_drop_down),
              ),
            ),
          ),
          child: VolumePicker(
            initialValue: controller.statusVolume,
            active: true,
            onChange: (value) {
              controller.statusVolume = value;
            },
          ),
        );
      },
    );
  }
}
