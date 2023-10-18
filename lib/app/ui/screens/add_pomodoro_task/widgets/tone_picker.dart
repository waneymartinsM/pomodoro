import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomodoro/app/core/utils/custom_colors.dart';
import 'package:pomodoro/app/data/enums/tones.dart';
import 'package:pomodoro/app/data/services/pomodoro_sound_player.dart';
import 'package:pomodoro/app/ui/screens/add_pomodoro_task/add_pomodoro_task_screen_controller.dart';
import 'package:pomodoro/app/utils/helpers/simple_state_builder.dart';
import 'package:pomodoro/app/utils/overlays/snackbars/mute_alert_snackbar.dart';
import 'volume_picker/volume_picker.dart';

class TonePicker extends StatelessWidget {
  TonePicker({Key? key}) : super(key: key);

  final AddPomodoroTaskScreenController controller = Get.find();

  @override
  Widget build(BuildContext context) {

    return Obx(
      () => ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          "Selecionar som",
          style: GoogleFonts.poppins(
            color: CustomColors.black,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          'Som selecionado: ${controller.tone.value.name}',
          style: GoogleFonts.poppins(
            color: CustomColors.mediumGrey,
            fontSize: 13,
            fontWeight: FontWeight.w300,
          ),
        ),
        onTap: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (context) {
              return const Scaffold(body: _TonePickerBottomSheet());
            },
          );
        },
      ),
    );
  }
}

class _TonePickerBottomSheet extends StatefulWidget {
  const _TonePickerBottomSheet({Key? key}) : super(key: key);

  @override
  State<_TonePickerBottomSheet> createState() => _TonePickerBottomSheetState();
}

class _TonePickerBottomSheetState extends State<_TonePickerBottomSheet> {
  final AddPomodoroTaskScreenController controller = Get.find();
  final scrollController = ScrollController();
  final player = PomodoroSoundPlayer();
  late ThemeData theme;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 200), () {
      scrollController.animateTo(
        controller.tone.value.index * 50.h,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
    player.init();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    theme = Theme.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    scrollController.dispose();
    player.dispose();
    super.dispose();
  }

  Future<void> playTone() async {
    if (controller.isToneMuted) return;
    if (await player.cantPlaySound()) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      showMuteAlertSnackBar(
        context,
       'As configurações de som são definidas para silenciar.',
        height: 60,
      );

      return;
    }

    await player.playTone(controller.tone.value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColors.white,
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsetsDirectional.only(top: 20, start: 20, end: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Selecionar som",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: CustomColors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close_rounded, size: 25),
                ),
              ],
            ),
          ),
          Expanded(
            child: SimpleStateBuilder(
              builder: (context, updater) {
                return ListView.separated(
                  itemCount: Tones.values.length,
                  controller: scrollController,
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  itemBuilder: (context, index) {
                    return RadioListTile<Tones>(
                      activeColor: CustomColors.pinkMain,
                      value: Tones.values[index],
                      groupValue: controller.tone.value,
                      selected: true,
                      onChanged: (value) {
                        controller.tone.value = value!;
                        updater();
                        playTone();
                      },
                      title: Text(
                        Tones.values[index].name,
                        style: GoogleFonts.poppins(
                          color: CustomColors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            color: CustomColors.white,
            padding: const EdgeInsets.all(15),
            child: VolumePicker(
              initialValue: 0.50,
              active: true,
              onChange: (value) {
                controller.toneVolume = value;
                if (value >= 0.1) player.setVolume(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
