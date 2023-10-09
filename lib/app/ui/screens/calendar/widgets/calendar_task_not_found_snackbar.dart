import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomodoro/app/core/utils/custom_colors.dart';
import 'package:pomodoro/app/utils/overlays/snackbars/alert_base_snackbars.dart';

ScaffoldFeatureController<Widget, SnackBarClosedReason>
    showCalendarTaskNotFoundSnackBar(BuildContext context) {

  return showAlertBaseSnackBar(
    context,
    height: 70,
    text: Text(
      "Não há tarefas cadastradas para a data selecionada.",
      style: GoogleFonts.poppins(
          fontSize: 14, fontWeight: FontWeight.w400, color: CustomColors.black),
    ),
    icon: const Icon(Icons.info_outline,
        color: CustomColors.black, size: 30),
  );
}
