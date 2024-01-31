import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pomodoro/app/core/utils/custom_colors.dart';

class WelcomePageOne extends StatelessWidget {
  const WelcomePageOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColors.white,
      padding: const EdgeInsets.all(25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Trabalhar em blocos de tempo é uma estratégia eficaz para gerenciar o tempo de forma inteligente e alcançar melhores resultados. Essa abordagem permite estruturar o processo de trabalho, focar em uma tarefa por vez e evitar distrações e procrastinação. É amplamente utilizada por desenvolvedores, designers, escritores e estudantes em todo o mundo para obter ótimos resultados.",
            style: GoogleFonts.poppins(fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Lottie.asset("assets/lottie/animation_lk9n699j.json",
              height: MediaQuery.of(context).size.height * 0.4),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
