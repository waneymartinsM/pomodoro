import 'package:flutter/material.dart';

// Classe que cria um widget de texto com transição suave entre dois estilos de texto
class AnimatedTextStyle extends StatefulWidget {
  const AnimatedTextStyle({
    Key? key,
    required this.text,
    required this.textStyle,
    required this.secondTextStyle,
  }) : super(key: key);

  final String? text;
  final TextStyle textStyle;
  final TextStyle secondTextStyle;

  @override
  State<AnimatedTextStyle> createState() => _AnimatedTextStyleState();
}

class _AnimatedTextStyleState extends State<AnimatedTextStyle>
    with SingleTickerProviderStateMixin {
  String? text;
  late final AnimationController controller;

  @override
  void initState() {
    text =
        widget.text; // Inicializa o texto com o valor passado via propriedade
    controller = AnimationController(
      vsync: this,
      value: text != null ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
    );

    super.initState();
  }

  @override
  void didUpdateWidget(covariant AnimatedTextStyle oldWidget) {
    if (widget.text != oldWidget.text) {// Verifica se o texto atual é diferente do texto anterior
      if (widget.text != null) {
        text = widget.text; // Atualiza o texto atual com o novo texto
        controller.forward(); // Inicia a animação para mostrar o novo texto
      } else {
        controller.reverse().then(
            (value) => text = null); // Inicia a animação para esconder o texto
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Text(
          text ?? '',
          style: TextStyle.lerp( // Interpola entre os estilos de texto inicial e secundário com base no valor da animação
            widget.textStyle,
            widget.secondTextStyle,
            controller.value,
          ),
        );
      },
    );
  }
}
