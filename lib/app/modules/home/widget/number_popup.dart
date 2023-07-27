import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomodoro/app/core/utils/custom_colors.dart';
import 'package:pomodoro/app/widgets/custom_animated_button.dart';

class NumberPopup extends StatefulWidget {
  final int initialNumber;

  const NumberPopup({Key? key, required this.initialNumber}) : super(key: key);

  @override
  _NumberPopupState createState() => _NumberPopupState();
}

class _NumberPopupState extends State<NumberPopup> {
  late int number;

  @override
  void initState() {
    super.initState();
    number = widget.initialNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.1),
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: SizedBox(
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove,
                          color: CustomColors.white, size: 30),
                      onPressed: () {
                        if(number > 1){
                          setState(() {
                            number--;
                          });
                        }
                      },
                    ),
                    Text(number.toString(),
                        style: GoogleFonts.poppins(
                          fontSize: 60,
                          color: CustomColors.white,
                        )),
                    IconButton(
                      icon: const Icon(Icons.add,
                          color: CustomColors.white, size: 30),
                      onPressed: () {
                        setState(() {
                          number++;
                        });
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: CustomAnimatedButton(
                    onTap: () {
                      Navigator.pop(context, number);
                    },
                    widthMultiply: 1,
                    height: 45,
                    colorText: CustomColors.black,
                    color: CustomColors.white,
                    text: "CONFIRMAR",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
