import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:pomodoro/app/config/routes/routes_name.dart';
import 'package:pomodoro/app/core/utils/custom_colors.dart';

class AppIntroductionScreen extends StatelessWidget {
  const AppIntroductionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: CustomColors.white,
      pages: [
        PageViewModel(
          image: Lottie.asset("assets/lottie/animation_lk9n699j.json",
              height: MediaQuery.of(context).size.height * 0.45),
          title: "Gerenciando o Tempo com Eficiência",
          body:
              "Os blocos de tempo são uma estratégia eficaz para maximizar a produtividade, envolvendo organização, foco e minimização de distrações, amplamente adotada por profissionais e estudantes para alcançar resultados superiores.",
          decoration: _pageViewModelDecoration,
        ),
        PageViewModel(
          image: Lottie.asset("assets/lottie/animation_lk9nia7r.json",
              height: MediaQuery.of(context).size.height * 0.4),
          decoration: _pageViewModelDecoration,
          title: "Resultados Surpreendentes com Esta Técnica",
          body:
              "Ao empregar essa técnica, você experimentará resultados surpreendentes. Você se sentirá renovado e, à medida que esse método se tornar uma prática natural para você, sua capacidade de concentração e desempenho aprimorarão.",
        ),
        PageViewModel(
          image: Lottie.asset("assets/lottie/animation_lk9nr1ja.json",
              height: MediaQuery.of(context).size.height * 0.4),
          title: "Potencialize sua produtividade com o Pomodoro!",
          body:
              "Melhore sua eficiência com o temporizador de fluxo e a estratégia de blocos de tempo. Gerencie seu tempo de forma inteligente, concentre-se em tarefas específicas e alcance maior produtividade.",
          decoration: _pageViewModelDecoration,
        ),
      ],
      dotsDecorator: DotsDecorator(
        activeColor: CustomColors.pinkMain,
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        spacing: const EdgeInsets.symmetric(horizontal: 5.0),
        activeShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      ),
      done: _buildTextDone(),
      onDone: () =>
          Navigator.pushReplacementNamed(context, RoutesName.homeScreen),
      onSkip: () =>
          Navigator.pushReplacementNamed(context, RoutesName.homeScreen),
      next: const Icon(Icons.keyboard_arrow_right_rounded,
          color: CustomColors.pinkMain),
      skip: _buildTextSkip(),
      showSkipButton: true,
    );
  }

  Text _buildTextSkip() {
    return Text(
      "Pular",
      style: GoogleFonts.poppins(
        color: CustomColors.pinkMain,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Text _buildTextDone() {
    return Text(
      "Feito",
      style: GoogleFonts.poppins(
        color: CustomColors.pinkMain,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

const _pageViewModelDecoration = PageDecoration(
  bodyAlignment: Alignment.center,
  imageAlignment: Alignment.center,
  imageFlex: 3,
  bodyFlex: 2,
  bodyPadding: EdgeInsets.zero,
  contentMargin: EdgeInsets.symmetric(horizontal: 16),
  titleTextStyle: TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  ),
  bodyTextStyle: TextStyle(
      fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w600),
);
