import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomodoro/app/core/utils/custom_colors.dart';

class EmptyList extends StatelessWidget {
  const EmptyList({
    Key? key,
    required this.assetIcon,
    required this.title,
    required this.description,
    required this.size,
  }) : super(key: key);

  final double size;
  final String assetIcon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            assetIcon,
            color: CustomColors.mediumGrey,
            height: size,
            width: size,
            fit: BoxFit.fill,
          ),
          const SizedBox(height: 20),
          Text(title, style: GoogleFonts.poppins(color: CustomColors.black)),
          const SizedBox(height: 10),
          Text(
            description,
            style: GoogleFonts.poppins(
                color: CustomColors.black,
                fontWeight: FontWeight.w300,
                fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
