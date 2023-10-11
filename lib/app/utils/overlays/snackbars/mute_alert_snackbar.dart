import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomodoro/app/core/utils/custom_colors.dart';
import 'alert_base_snackbars.dart';

ScaffoldFeatureController<Widget, SnackBarClosedReason> showMuteAlertSnackBar(
  BuildContext context,
  String text, {
  double? height,
}) {
  return showAlertBaseSnackBar(
    context,
    height: height,
    text: Text(text, style: GoogleFonts.poppins()),
    icon: const Icon(Icons.volume_off, color: CustomColors.black, size: 40),
  );
}
