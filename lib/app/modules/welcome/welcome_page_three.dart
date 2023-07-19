import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pomodoro/app/core/utils/custom_colors.dart';

class WelcomePageThree extends StatelessWidget {
  const WelcomePageThree({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColors.white,
      padding: const EdgeInsets.all(25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Aproveite os benefícios do temporizador de fluxo e trabalhe com eficiência!\nAo implementar a estratégia de trabalhar em blocos de tempo, você poderá gerenciar seu tempo de maneira mais inteligente, focando em tarefas específicas, evitando distrações e maximizando a produtividade.",
            style: GoogleFonts.poppins(fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Lottie.asset("assets/lottie/animation_lk9nr1ja.json",
              height: MediaQuery.of(context).size.height * 0.3),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
