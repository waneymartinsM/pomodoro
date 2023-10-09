import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomodoro/app/core/utils/custom_colors.dart';
import 'package:pomodoro/app/ui/widgets/horizontal_animated_slide.dart';

class MonthOfYear extends StatefulWidget {
  const MonthOfYear({
    Key? key,
    required this.onDecrement,
    required this.onIncrement,
    required this.year,
    required this.month,
    required this.monthsNames,
  }) : super(key: key);

  final int year;
  final int month;
  final void Function() onIncrement;
  final void Function() onDecrement;
  final List<String> monthsNames;

  @override
  State<MonthOfYear> createState() => _MonthOfYearState();
}

class _MonthOfYearState extends State<MonthOfYear>
    with SingleTickerProviderStateMixin {
  final Tween<Offset> tweenOffset =
      Tween(begin: const Offset(-1.5, 0.0), end: const Offset(1.5, 0.0));

  final width = ScreenUtil().screenWidth * 0.6;
  late ThemeData theme;
  late TextStyle textStyle;
  bool reverse = false;
  bool shouldAnimate = false;

  @override
  void didUpdateWidget(covariant MonthOfYear oldWidget) {
    if (oldWidget.year != widget.year) {
      reverse = oldWidget.year < widget.year;
      shouldAnimate = true;
    } else if (oldWidget.month != widget.month) {
      reverse = oldWidget.month < widget.month;
      shouldAnimate = true;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    theme = Theme.of(context);
    textStyle = theme.textTheme.titleLarge!;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: IconButton(
              onPressed: widget.onDecrement,
              splashRadius: 20,
              icon: const Icon(
                Icons.keyboard_arrow_left_rounded,
                color: CustomColors.mediumGrey,
                size: 27,
              ),
            ),
          ),
          ClipRRect(
            child: HorizontalAnimatedSlide(
              width: width,
              reverse: reverse,
              tween: tweenOffset,
              duration: const Duration(milliseconds: 500),
              animate: shouldAnimate,
              onDone: () => shouldAnimate = false,
              child: SizedBox(
                width: width,
                child: Center(
                  child: Text(
                    '${widget.monthsNames[widget.month - 1]} ${widget.year}',
                    style: GoogleFonts.poppins(
                        color: CustomColors.black, fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: IconButton(
              onPressed: widget.onIncrement,
              splashRadius: 20,
              icon: const Icon(
                Icons.keyboard_arrow_right_rounded,
                color: CustomColors.mediumGrey,
                size: 27,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
