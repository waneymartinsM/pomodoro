import 'package:flutter/material.dart';

// Definição de dois tipos de função que serão usados como parâmetros do widget
// `SimpleStateBuilder`. Um deles é uma função que não retorna nada (`VoidCallback`),
// chamada `SimpleStateBuilderUpdater`, que será usada para atualizar o estado,
// e o outro é uma função que recebe o contexto e a função de atualização e retorna um widget.
typedef SimpleStateBuilderUpdater = void Function();

typedef SimpleStateBuilderBuilderCallBack = Widget Function(
  BuildContext context,
  SimpleStateBuilderUpdater updater,
);

// SimpleStateBuilder é uma interface do usuário que respondem a mudanças de
// estado e permitem a execução de ações personalizadas em momentos específicos
// do ciclo de vida do widget
class SimpleStateBuilder extends StatefulWidget {
  const SimpleStateBuilder({
    Key? key,
    required this.builder,
    this.onInit,
    this.onUpdate,
    this.onDispose,
  }) : super(key: key);

  final SimpleStateBuilderBuilderCallBack builder;
  final VoidCallback? onInit;
  final VoidCallback? onUpdate;
  final VoidCallback? onDispose;
  @override
  State<SimpleStateBuilder> createState() => _SimpleStateBuilderState();
}

class _SimpleStateBuilderState extends State<SimpleStateBuilder> {
  @override
  void initState() {
    widget.onInit?.call();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SimpleStateBuilder oldWidget) {
    widget.onUpdate?.call();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.onDispose?.call();
    super.dispose();
  }

  void updater() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, updater);
  }
}
