import 'package:flutter/material.dart';
import 'package:pomodoro/app/core/utils/custom_colors.dart';

ScaffoldFeatureController<Widget, SnackBarClosedReason> showAlertBaseSnackBar(
  BuildContext context, {
  required Widget text,
  Widget? icon,
  List<Color>? colors,
  double? height,
}) {
  final snackBar = SnackBar(
    dismissDirection: DismissDirection.horizontal,
    backgroundColor: Colors.transparent,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.all(10),
    padding: EdgeInsets.zero,
    duration: const Duration(seconds: 5),
    elevation: 0.0,
    content: Container(
      height: height,
      padding: const EdgeInsets.all(10),
      alignment: AlignmentDirectional.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: CustomColors.white,
        boxShadow: const [
          BoxShadow(
            blurRadius: 5,
            offset: Offset(2, 3),
            spreadRadius: 2,
            color: Colors.black26,
          ),
        ],
      ),
      child: Row(
        children: [
          if (icon != null) icon,
          const SizedBox(width: 10),
          Expanded(child: text),
        ],
      ),
    ),
  );
  return ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
