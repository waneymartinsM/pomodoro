import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomodoro/app/core/utils/custom_colors.dart';

class HorizontalNumberPicker extends StatefulWidget {
  const HorizontalNumberPicker({
    Key? key,
    required this.min,
    required this.max,
    required this.initialNumber,
    required this.title,
    required this.suffix,
    required this.height,
    required this.width,
    this.isActive = true,
    this.onSelectedItemChanged,
  }) : super(key: key);

  final int min;
  final int max;
  final int initialNumber;
  final String title;
  final String suffix;
  final double height;
  final double width;
  final bool isActive;
  final void Function(int selectedNumber)? onSelectedItemChanged;

  @override
  State<HorizontalNumberPicker> createState() => _HorizontalNumberPickerState();
}

class _HorizontalNumberPickerState extends State<HorizontalNumberPicker> {
  late final List<int> numbers = List.generate(
    (widget.max + 1) - widget.min,
    (index) => index + widget.min,
  );

  late final FixedExtentScrollController controller =
      FixedExtentScrollController(
    initialItem: numbers.indexOf(widget.initialNumber),
  );

  late ThemeData theme;
  late Color? inActiveColor;
  late TextStyle centerTextStyle;
  late TextStyle minTextStyle;
  late TextStyle mediumTextStyle;
  late int selectedNumber = widget.initialNumber;

  @override
  void didUpdateWidget(covariant HorizontalNumberPicker oldWidget) {
    if (oldWidget.isActive != widget.isActive) initStylesAndColors();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    theme = Theme.of(context);
    initStylesAndColors();
    super.didChangeDependencies();
  }

  void initStylesAndColors() {
    mediumTextStyle = GoogleFonts.poppins(
        textStyle: const TextStyle(
            fontSize: 18, color: CustomColors.pinkMain, inherit: true));
    minTextStyle = GoogleFonts.poppins(
        textStyle: const TextStyle(
            fontSize: 13, color: CustomColors.pinkMain, inherit: true));
    centerTextStyle = GoogleFonts.poppins(
        textStyle:
            const TextStyle(fontSize: 18, color: Colors.white, inherit: true));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: GoogleFonts.poppins(
                  color: CustomColors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
              Text(
                widget.suffix,
                style: GoogleFonts.poppins(
                  color: CustomColors.black,
                  fontWeight: FontWeight.w300,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          Expanded(
            child: Stack(
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: CustomColors.pinkMain,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                RotatedBox(
                  quarterTurns: -1,
                  child: ValueBuilder<dynamic>(
                    builder: (_, update) {
                      return ListWheelScrollView.useDelegate(
                        diameterRatio: 3,
                        controller: controller,
                        itemExtent: widget.width / 5,
                        onSelectedItemChanged: (int index) {
                          selectedNumber = index + widget.min;
                          widget.onSelectedItemChanged?.call(selectedNumber);
                          update(null);
                        },
                        physics: widget.isActive
                            ? const FixedExtentScrollPhysics()
                            : const NeverScrollableScrollPhysics(),
                        childDelegate: ListWheelChildBuilderDelegate(
                          childCount: numbers.length,
                          builder: (context, index) {
                            final item = index + widget.min;
                            TextStyle textStyle;
                            if (item == selectedNumber) {
                              textStyle = centerTextStyle;
                            } else if ((item - selectedNumber).abs() == 2) {
                              textStyle = minTextStyle;
                            } else if ((item - selectedNumber).abs() == 1) {
                              textStyle = mediumTextStyle;
                            } else {
                              textStyle = const TextStyle(
                                  color: Colors.black12, inherit: true);
                            }
                            return RotatedBox(
                              quarterTurns: 1,
                              child: Center(
                                child: AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 150),
                                  style: textStyle,
                                  child: Text(
                                    '${numbers[index]}',
                                    strutStyle:
                                        StrutStyle.fromTextStyle(textStyle),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
