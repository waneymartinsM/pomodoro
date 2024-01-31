import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pomodoro/app/core/utils/custom_colors.dart';

class WelcomePageTwo extends StatelessWidget {
  const WelcomePageTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColors.white,
      padding: const EdgeInsets.all(25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Ao empregar essa técnica, você experimentará resultados surpreendentes. Você se sentirá renovado e, à medida que esse método se tornar uma prática natural para você, sua capacidade de concentração e desempenho aprimorarão.",
            style: GoogleFonts.poppins(fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Lottie.asset("assets/lottie/animation_lk9nia7r.json",
              height: MediaQuery.of(context).size.height * 0.4),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
