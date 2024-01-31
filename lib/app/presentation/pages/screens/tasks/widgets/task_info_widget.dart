import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomodoro/app/core/utils/custom_colors.dart';
import 'package:pomodoro/app/data/models/pomodoro_task_model.dart';

class TaskInfoWidget extends StatelessWidget {
  const TaskInfoWidget({
    required this.task,
    this.onCircleButtonPressed,
    this.onEditPressed,
    this.onDeletePressed,
    required this.animation,
    Key? key,
  }) : super(key: key);

  final Animation<double> animation;
  final PomodoroTaskModel task;
  final VoidCallback? onCircleButtonPressed;
  final VoidCallback? onEditPressed;
  final VoidCallback? onDeletePressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sizeCurveTween = CurveTween(curve: Curves.easeOutQuart);
    final tweenOffset =
        Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero);

    return Slidable(
      key: ValueKey(task.id),
      useTextDirection: false,
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          _CustomSlideAction(
            onPressed: (context) {
              onDeletePressed?.call();
              Slidable.of(context)!.close();
            },
            icon: Icons.delete_rounded,
            iconColor: Colors.red,
            backgroundColor: theme.colorScheme.surface,
            label: "Deletar",
            textColor: Colors.red,
          ),
          _CustomSlideAction(
            onPressed: (context) {
              onEditPressed?.call();
              Slidable.of(context)!.close();
            },
            icon: Icons.edit,
            iconColor: Colors.green,
            backgroundColor: theme.colorScheme.surface,
            label: "Editar",
            textColor: Colors.green,
          ),
        ],
      ),
      child: SlideTransition(
        position: tweenOffset.animate(animation),
        child: SizeTransition(
          axis: Axis.vertical,
          sizeFactor: sizeCurveTween.animate(animation),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: SizedBox(
              height: 105,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                decoration: BoxDecoration(
                  color: CustomColors.lightGrey,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                task.title,
                                style: GoogleFonts.poppins(
                                    color: CustomColors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${task.pomodoroRound}/${task.maxPomodoroRound}',
                                style: GoogleFonts.poppins(
                                    color: CustomColors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _TaskInfoLabel(
                                title: 'T', //TRABALHO
                                minutes: task.workDuration.inMinutes,
                              ),
                              _TaskInfoLabel(
                                title: 'IC', //INTERVALO CURTO
                                minutes: task.shortBreakDuration.inMinutes,
                              ),
                              _TaskInfoLabel(
                                title: 'IL', // INTERVALO LONGO
                                minutes: task.longBreakDuration.inMinutes,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 15),
                    InkWell(
                      onTap: onCircleButtonPressed ?? () {},
                      child: const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.green,
                        child: RotatedBox(
                          quarterTurns: 0,
                          child: Icon(Icons.play_arrow,
                              color: CustomColors.white, size: 25),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomSlideAction extends StatelessWidget {
  const _CustomSlideAction({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.textColor,
    required this.backgroundColor,
    required this.iconColor,
  }) : super(key: key);

  final void Function(BuildContext context) onPressed;
  final IconData icon;
  final String label;
  final Color textColor;
  final Color backgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
        child: GestureDetector(
          onTap: () => onPressed(context),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: CustomColors.lightGrey,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(icon, color: iconColor, size: 30),
                const SizedBox(height: 10),
                Text(label, style: GoogleFonts.poppins(color: textColor)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TaskInfoLabel extends StatelessWidget {
  const _TaskInfoLabel({
    Key? key,
    required this.title,
    required this.minutes,
  }) : super(key: key);

  final String title;
  final int minutes;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('$title : ', style: GoogleFonts.poppins()),
        Text('$minutes m', style: GoogleFonts.poppins()),
      ],
    );
  }
}
