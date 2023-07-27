import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomodoro/app/core/utils/custom_colors.dart';
import 'package:pomodoro/app/modules/home/widget/number_popup.dart';
import 'package:pomodoro/app/widgets/custom_animated_button.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  Color backgroundColor = CustomColors.pinkMain;
  int selectedPomodoro = 25;
  int breaks = 1;
  int breakTime = 15;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.keyboard_arrow_left_outlined,
                  color: CustomColors.white,
                ),
              ),
            ),
            Text(
              "DURAÇÕES",
              style: GoogleFonts.poppins(
                  color: CustomColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () async {
                    final int? result = await showDialog<int>(
                      context: context,
                      builder: (context) =>
                          NumberPopup(initialNumber: selectedPomodoro),
                    );
                    if (result != null) {
                      setState(() {
                        selectedPomodoro = result;
                      });
                    }
                  },
                  child: Container(
                    color: CustomColors.white.withOpacity(0.2),
                    height: 110,
                    width: 110,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          child: Text(
                            selectedPomodoro.toString(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: GoogleFonts.poppins(
                                fontSize: 50, color: CustomColors.white),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            "POMODORO",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: CustomColors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    final int? result = await showDialog(
                        context: context,
                        builder: (_) => NumberPopup(initialNumber: breaks));
                    if (result != null) {
                      setState(() {
                        breaks = result;
                      });
                    }
                  },
                  child: Container(
                    color: CustomColors.white.withOpacity(0.2),
                    height: 110,
                    width: 110,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          child: Text(
                            breaks.toString(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: GoogleFonts.poppins(
                                fontSize: 50, color: CustomColors.white),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            "PAUSA",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: CustomColors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    final int? result = await showDialog(
                        context: context,
                        builder: (_) => NumberPopup(initialNumber: breakTime));
                    if (result != null) {
                      setState(() {
                        breakTime = result;
                      });
                    }
                  },
                  child: Container(
                    color: CustomColors.white.withOpacity(0.2),
                    height: 110,
                    width: 110,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          child: Text(
                            breakTime.toString(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: GoogleFonts.poppins(
                                fontSize: 50, color: CustomColors.white),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            "PAUSA LONGA",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: CustomColors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Text(
              "COR DO TEMA",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  color: CustomColors.white,
                  fontSize: 16),
            ),
            const SizedBox(height: 25),
            Container(
              color: CustomColors.white.withOpacity(0.2),
              padding: const EdgeInsets.all(8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: colorOptions.map((color) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        backgroundColor = color;
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 6 - 16,
                      height: MediaQuery.of(context).size.width / 6 - 16,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: color,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 25),
            CustomAnimatedButton(
              onTap: () {},
              widthMultiply: 1,
              height: 45,
              colorText: backgroundColor,
              color: CustomColors.white,
              text: "SALVAR",
            )
          ],
        ),
      ),
    );
  }
}
