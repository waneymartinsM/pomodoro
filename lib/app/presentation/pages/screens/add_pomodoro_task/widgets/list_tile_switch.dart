import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomodoro/app/core/utils/custom_colors.dart';

class ListTileSwitch extends StatelessWidget {
  const ListTileSwitch({
    Key? key,
    this.defaultValue = true,
    this.titleSuffix,
    required this.title,
    required this.description,
    required this.onChange,
  }) : super(key: key);

  final String title;
  final String description;
  final bool defaultValue;
  final void Function(bool) onChange;
  final Widget? titleSuffix;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                      color: CustomColors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                ),
                if (titleSuffix != null) titleSuffix!
              ],
            ),
            SizedBox(height: 5.h),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 45, maxWidth: 230),
              child: Text(
                description,
                style: GoogleFonts.poppins(
                    color: CustomColors.mediumGrey,
                    fontSize: 13,
                    fontWeight: FontWeight.w300),
                maxLines: 2,
              ),
            ),
          ],
        ),
        ValueBuilder<bool?>(
          initialValue: defaultValue,
          builder: (value, update) {
            return Center(
              child: SizedBox(
                width: 60,
                child: Switch(
                  value: value!,
                  onChanged: (newValue) {
                    update(newValue);
                  },
                  activeTrackColor: CustomColors.pinkMain,
                  inactiveTrackColor: CustomColors.pinkMain,
                  activeColor: CustomColors.white,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
