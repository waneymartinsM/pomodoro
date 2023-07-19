import 'package:flutter/material.dart';
import 'package:pomodoro/app/core/utils/custom_colors.dart';
import 'package:pomodoro/app/modules/welcome/welcome_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool loading = false;

  @override
  void initState() {
    _loading();
    super.initState();
  }

  void _loading() async {
    setState(() {
      loading = true;
    });
    await Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const WelcomePage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColors.pinkMain,
      child: Center(
        child: Image.asset("assets/logo/logo.png"),
      ),
    );
  }
}
