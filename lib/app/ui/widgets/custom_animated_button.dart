import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAnimatedButton extends StatefulWidget {
  final double height;
  final double widthMultiply;
  final String text;
  final IconData? icon;
  final bool? iconBool;
  final bool outlined;
  final Color? color;
  final Color? borderColor;
  final Color? colorText;
  final Function? onTap;
  final double fontSize;

  const CustomAnimatedButton(
      {Key? key,
      required this.widthMultiply,
      this.height = 60,
      this.text = "",
      this.outlined = false,
      this.icon,
      this.color,
      this.borderColor,
      this.colorText,
      this.onTap,
      this.iconBool,
      this.fontSize = 18})
      : super(key: key);

  @override
  _CustomAnimatedButtonState createState() => _CustomAnimatedButtonState();
}

class _CustomAnimatedButtonState extends State<CustomAnimatedButton>
    with SingleTickerProviderStateMixin {
  late double _scale;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;

    return Center(
      child: InkWell(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTap: () {
          widget.onTap!();
        },
        child: Transform.scale(
          scale: _scale,
          child: _animatedButtonUI,
        ),
      ),
    );
  }

  Widget get _animatedButtonUI => widget.outlined
      ? OutlinedButton(
          style: ButtonStyle(
            side: MaterialStateProperty.resolveWith<BorderSide>(
              (states) => BorderSide(
                color: widget.borderColor ?? Colors.transparent,
                width: 2,
              ),
            ),
            shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
              (states) => RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13.0),
              ),
            ),
          ),
          onPressed: () {
            widget.onTap!();
          },
          child: SizedBox(
            height: widget.height,
            width: MediaQuery.of(context).size.width * widget.widthMultiply,
            child: Center(
              child: widget.iconBool == true
                  ? Icon(
                      widget.icon,
                      color: Colors.white,
                    )
                  : Text(
                      widget.text,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: widget.colorText,
                      ),
                    ),
            ),
          ),
        )
      : Material(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13.0),
          ),
          child: Container(
            height: widget.height,
            width: MediaQuery.of(context).size.width * widget.widthMultiply,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13.0),
              border: Border.all(
                color: widget.borderColor ?? Colors.transparent,
                width: 2,
              ),
              color: widget.color ?? Colors.transparent,
            ),
            child: Center(
              child: widget.iconBool == true
                  ? Icon(
                      widget.icon,
                      color: Colors.white,
                    )
                  : Text(
                      widget.text,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: widget.colorText,
                      ),
                    ),
            ),
          ),
        );
}
