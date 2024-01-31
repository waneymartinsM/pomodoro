import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomodoro/app/core/utils/custom_colors.dart';
import 'painters/custom_track_slider.dart';

class VolumePicker extends StatefulWidget {
  const VolumePicker({
    Key? key,
    required this.initialValue,
    required this.onChange,
    required this.active,
  }) : super(key: key);

  final bool active;
  final double initialValue;
  final void Function(double value) onChange;

  @override
  State<VolumePicker> createState() => _VolumePickerState();
}

class _VolumePickerState extends State<VolumePicker> {
  late final Rx<double> sliderValue;
  late final Rx<IconData> icon;
  late ThemeData theme;

  @override
  void initState() {
    sliderValue = widget.initialValue.obs;
    icon = getIcon.obs;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    theme = Theme.of(context);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(VolumePicker oldWidget) {
    if (oldWidget.active != widget.active) icon.value = getIcon;
    super.didUpdateWidget(oldWidget);
  }

  IconData get getIcon {
    if (sliderValue.value >= 0.5) {
      return Icons.volume_up;
    } else if (sliderValue.value == 0.0) {
      return Icons.volume_off;
    } else if (sliderValue.value < 0.5 || (!widget.active)) {
      return Icons.volume_down;
    }
    return Icons.volume_down;
  }

  void setSliderValue(double value) {
    if (widget.active) {
      sliderValue.value = value;
      icon.value = getIcon;
    }
    widget.onChange(value);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            height: 45,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                    color: CustomColors.mediumGrey.withOpacity(0.5),
                    offset: const Offset(0, 0),
                    blurRadius: 10),
              ],
              color: CustomColors.lightGrey,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                RotatedBox(
                  quarterTurns: 0,
                  child: Obx(
                    () => Icon(
                      icon.value,
                      color: widget.active ? Colors.black54 : Colors.black26,
                      size: 30,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      overlayShape:
                         const RoundSliderOverlayShape(overlayRadius: 30),
                      thumbColor: CustomColors.pinkMain,
                      trackShape: const CustomSliderTrack(
                        activeColors: [
                          CustomColors.pinkMain,
                          CustomColors.pinkMain
                        ],
                        inActiveColors: [
                          Colors.black12,
                          Colors.black12
                        ],
                      ),
                      overlayColor: CustomColors.pinkMain.withOpacity(0.4),
                    ),
                    child: Obx(
                      () => Slider(
                        min: 0,
                        max: 1.0,
                        value: sliderValue.value,
                        onChanged: setSliderValue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
