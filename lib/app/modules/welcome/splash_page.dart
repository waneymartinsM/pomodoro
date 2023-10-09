// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:pomodoro/app/core/utils/custom_colors.dart';
// import 'package:pomodoro/app/modules/home/home_page.dart';
// import 'package:pomodoro/app/modules/welcome/welcome_page.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:uuid/uuid.dart';
//
// class SplashPage extends StatefulWidget {
//   const SplashPage({Key? key}) : super(key: key);
//
//   @override
//   _SplashPageState createState() => _SplashPageState();
// }
//
// class _SplashPageState extends State<SplashPage> {
//   bool loading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _loading();
//   }
//
//   Future<void> _loading() async {
//     setState(() {
//       loading = true;
//     });
//
//     final prefs = await SharedPreferences.getInstance();
//     final deviceToken = prefs.getString('deviceToken');
//
//     if (deviceToken == null) {
//       const Uuid uuid = Uuid();
//       final newDeviceToken = uuid.v4();
//       await prefs.setString('deviceToken', newDeviceToken);
//
//       debugPrint("Gerar token: $newDeviceToken");
//
//       final collectionRef = FirebaseFirestore.instance.collection('pomodoro');
//       await collectionRef.doc(newDeviceToken).set({
//         'pomodoro_time': 5,
//         'number_breaks': 2,
//         'time_pause': 1,
//         'color_theme': 'FFc9c9ff',
//       });
//     }
//
//     final hasSeenWelcomePage = prefs.getBool('hasSeenWelcomePage') ?? false;
//
//     await Future.delayed(const Duration(seconds: 3), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) =>
//               hasSeenWelcomePage ? const HomePage() : const WelcomePage(),
//         ),
//       );
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: CustomColors.pinkMain,
//       child: Image.asset('assets/logo/p_image.png', fit: BoxFit.cover),
//     );
//   }
// }
