import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pomodoro/app/core/utils/custom_colors.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    Key? key,
    required this.onChange,
  }) : super(key: key);

  final void Function(int currentIndex) onChange;

  @override
  Widget build(BuildContext context) {
    final models = [
      const CustomBottomNavigationBarItemModel(
        icon: Icons.home_rounded,
        alignment: AlignmentDirectional.centerStart,
        index: 0,
        height: 45,
        width: 110,
      ),
      const CustomBottomNavigationBarItemModel(
        icon: Icons.calendar_month_rounded,
        alignment: AlignmentDirectional.centerEnd,
        index: 1,
        height: 45,
        width: 120,
      ),
    ];
    return SizedBox(
      height: 60,
      child: BottomAppBar(
        color: CustomColors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: ValueBuilder<int?>(
            initialValue: 0,
            builder: (currentIndex, updater) {
              return Stack(
                children: models
                    .map(
                      (model) => CustomBottomNavigationBarItem(
                        model: model,
                        active: model.index == currentIndex,
                        onTap: (index) {
                          updater(index);
                          onChange(index);
                        },
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}

class CustomBottomNavigationBarItem extends StatefulWidget {
  const CustomBottomNavigationBarItem({
    Key? key,
    required this.model,
    required this.active,
    required this.onTap,
  }) : super(key: key);

  final CustomBottomNavigationBarItemModel model;
  final bool active;
  final void Function(int index) onTap;

  @override
  State<CustomBottomNavigationBarItem> createState() =>
      _CustomBottomNavigationBarItemState();
}

class _CustomBottomNavigationBarItemState
    extends State<CustomBottomNavigationBarItem>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: widget.active ? 1.0 : 0.0,
    );
  }

  @override
  void didUpdateWidget(covariant CustomBottomNavigationBarItem oldWidget) {
    if (widget.active) {
      controller.forward();
    } else {
      controller.reverse();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.model.alignment,
      child: InkWell(
        onTap: () {
          widget.onTap(widget.model.index);
        },
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: AnimatedBuilder(
          animation: controller,
          child: 5.horizontalSpace,
          builder: (BuildContext context, Widget? child) {

            final textColor = Color.lerp(
              CustomColors.mediumGrey,
              CustomColors.pinkMain,
              controller.value,
            );

            return Container(
              width: widget.model.width,
              height: widget.model.height,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Icon(widget.model.icon, color: textColor, size: 30),
            );
          },
        ),
      ),
    );
  }
}

class CustomBottomNavigationBarItemModel {
  const CustomBottomNavigationBarItemModel({
    required this.icon,
    required this.index,
    required this.alignment,
    this.height,
    this.width,
  });

  final IconData icon;
  final int index;
  final AlignmentGeometry alignment;
  final double? height;
  final double? width;
}
