import 'package:flutter/material.dart';
import 'package:pomodoro/app/core/utils/custom_colors.dart';

class BackgroundContainer extends StatelessWidget {
  const BackgroundContainer({
    Key? key,
    this.height,
    this.width,
    this.padding,
    required this.child,
  }) : super(key: key);

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: CustomColors.lightGrey,
        elevation: 10,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: padding ??
              const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: child,
        ),
      ),
    );
  }
}
