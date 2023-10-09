import 'package:flutter/material.dart';
import 'package:pomodoro/app/core/utils/custom_colors.dart';
import 'package:pomodoro/app/modules/welcome/welcome_page_one.dart';
import 'package:pomodoro/app/modules/welcome/welcome_page_three.dart';
import 'package:pomodoro/app/modules/welcome/welcome_page_two.dart';
import 'package:pomodoro/app/widgets/custom_animated_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final PageController _controller = PageController();
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SharedPreferences.getInstance()
            .then((prefs) => prefs.getString('deviceToken')),
        builder: (context, snapshot) {
          return Scaffold(
            body: Stack(
              alignment: Alignment.center,
              children: [
                PageView(
                  controller: _controller,
                  onPageChanged: (index) {
                    setState(() {
                      onLastPage = (index == 2);
                    });
                  },
                  children: const [
                    WelcomePageOne(),
                    WelcomePageTwo(),
                    WelcomePageThree(),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SmoothPageIndicator(
                        controller: _controller,
                        count: 3,
                        effect: const WormEffect(
                          activeDotColor: CustomColors.pinkMain,
                          dotColor: CustomColors.lightGrey,
                        ),
                      ),
                      const SizedBox(height: 40),
                      onLastPage
                          ? CustomAnimatedButton(
                              onTap: () async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setBool('hasSeenWelcomePage', true);
                                //final currentContext = context;
                                // Future.delayed(Duration.zero, () {
                                //   Navigator.pushReplacement(
                                //     currentContext,
                                //     MaterialPageRoute(
                                //         builder: (_) => const HomePage()),
                                //   );
                                // });
                              },
                              widthMultiply: 1,
                              height: 45,
                              colorText: CustomColors.white,
                              color: CustomColors.pinkMain,
                              text: "INICIAR",
                            )
                          : CustomAnimatedButton(
                              onTap: () {
                                _controller.nextPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeIn);
                              },
                              widthMultiply: 1,
                              height: 45,
                              colorText: CustomColors.white,
                              color: CustomColors.pinkMain,
                              text: "PRÓXIMO",
                            ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
