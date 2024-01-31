import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomodoro/app/core/utils/custom_colors.dart';
import 'package:pomodoro/app/utils/overlays/snackbars/alert_base_snackbars.dart';

ScaffoldFeatureController<Widget, SnackBarClosedReason>
    showPomodoroFinishSnackBar(BuildContext context) {
  return showAlertBaseSnackBar(
    context,
    height: 90,
    text: Text(
      "Bom trabalho! Sua tarefa pomodoro foi concluída.",
      style: GoogleFonts.poppins(color: CustomColors.pinkMain),
    ),
    icon: const Icon(Icons.done, color: CustomColors.black, size: 30),
  );
}
