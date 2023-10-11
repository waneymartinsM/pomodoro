import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'animated_text.dart';

//CountdownTimerText que exibe um texto animado representando o tempo restante
class CountdownTimerText extends StatelessWidget {
  const CountdownTimerText({
    Key? key,
    required this.animateBack,
    required this.remainingDuration,
  }) : super(key: key);

  final bool animateBack; // determina se a animação deve ser revertida
  final Duration remainingDuration; // A duração do tempo restante

  String get text {
    return remainingDuration.toString().substring(2, 8);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i <= 4; i++)
            AnimatedText(
              text: text[i],
              reverse: animateBack,
              animateWhenReverse: true,
            ),
        ],
      ),
    );
  }
}
