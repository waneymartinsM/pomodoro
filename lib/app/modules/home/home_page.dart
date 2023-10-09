// import 'package:flutter/material.dart';
// import 'package:pomodoro/app/modules/home/settings_page.dart';
// import 'package:pomodoro/app/modules/home/widget/body_widgets.dart';
// import 'package:pomodoro/app/provider/theme_provider.dart';
// import 'package:pomodoro/app/provider/time_provider.dart';
// import 'package:provider/provider.dart';
//
// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     final timerProvider = Provider.of<TimerProvider>(context);
//
//     void navigateSettingsPage() {
//       Navigator.of(context).push(MaterialPageRoute(
//         builder: (context) => const SettingsPage(),
//       ));
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text("Pomodoro"),
//         actions: [
//           Padding(
//             padding: EdgeInsets.only(right: 10),
//             child: IconButton(
//                 onPressed: timerProvider.isEqual ? navigateSettingsPage : null,
//                 icon: const Icon(Icons.settings)),
//           )
//         ],
//         leading: Padding(
//           padding: const EdgeInsets.only(left: 10),
//           child: IconButton(
//               onPressed: () {
//                 themeProvider.switchTheme();
//               },
//               icon: Icon(
//                 themeProvider.isDarkMode ? Icons.nights_stay : Icons.light_mode,
//               )),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             SizedBox(
//               height: MediaQuery.of(context).size.height * 0.3,
//               width: MediaQuery.of(context).size.width * 0.5,
//               child: const Stack(
//                 fit: StackFit.expand,
//                 children: [
//                   TimeIndicatorWidget(),
//                   StudyBreakWidget(),
//                 ],
//               ),
//             ),
//             const MediaButtons(),
//             const RoundsWidget(),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // import 'dart:async';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:pomodoro/app/core/utils/custom_colors.dart';
// // import 'package:pomodoro/app/modules/home/settings_page.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// //
// // class HomePage extends StatefulWidget {
// //   const HomePage({Key? key}) : super(key: key);
// //
// //   @override
// //   State<HomePage> createState() => _HomePageState();
// // }
// //
// // class _HomePageState extends State<HomePage> {
// //   Duration _timerDuration = const Duration(minutes: 25);
// //   bool _isLoading = true;
// //   Color _backgroundColor = CustomColors.pinkMain;
// //   int _pomodoro = 0; //tempo do pomodoro
// //   int _pauseValue = 0; //quantidade de pausas
// //   int _timePause = 0; //quantidade de pausas
// //   int _totalSessions = 0;
// //   int _currentSession = 0;
// //   bool _isRunning = false;
// //   Timer? _timer;
// //
// //   Future<void> _fetchUserData() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     final deviceToken = prefs.getString('deviceToken');
// //
// //     if (deviceToken != null) {
// //       final collectionRef = FirebaseFirestore.instance.collection('pomodoro');
// //       final userDoc = await collectionRef.doc(deviceToken).get();
// //
// //       if (userDoc.exists) {
// //         final userData = userDoc.data();
// //         setState(() {
// //           _backgroundColor =
// //               Color(int.parse(userData?['colorTheme'], radix: 16));
// //           _pomodoro = userData?['pomodoro'];
// //           _timerDuration = Duration(minutes: _pomodoro);
// //           _pauseValue = userData?['pause'];
// //           _timePause = userData?['timePause'];
// //           _totalSessions = (_pomodoro + _pauseValue) * (_pauseValue + 1);
// //           _isLoading = false;
// //         });
// //         debugPrint("Dados do usuário: $userData");
// //       }
// //     } else {
// //       print("Ocorreu um erro ao carregar os dados!");
// //     }
// //   }
// //
// //   void _startTimer() {
// //     if (_timer != null) {
// //       _timer!.cancel();
// //     }
// //     setState(() {
// //       _isRunning = true;
// //     });
// //     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
// //       setState(() {
// //         if (_timerDuration.inSeconds > 0) {
// //           _timerDuration = _timerDuration - const Duration(seconds: 1);
// //         } else {
// //           if (_currentSession < _totalSessions - 1) {
// //             _currentSession++;
// //             if (_currentSession % 2 == 0) {
// //               _timerDuration = Duration(minutes: _pomodoro);
// //             } else {
// //               _timerDuration = Duration(minutes: _timePause);
// //             }
// //           } else {
// //             _stopTimer();
// //             _currentSession = 0;
// //             _timerDuration = Duration(minutes: _pomodoro);
// //           }
// //         }
// //       });
// //     });
// //   }
// //
// //   void _stopTimer() {
// //     _timer?.cancel();
// //     setState(() {
// //       _isRunning = false;
// //     });
// //   }
// //
// //   void _restartTimer() {
// //     _stopTimer();
// //     _currentSession = 0;
// //     _timerDuration = Duration(minutes: _pomodoro);
// //   }
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _fetchUserData();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: _backgroundColor,
// //       body: Padding(
// //         padding: const EdgeInsets.symmetric(vertical: 30),
// //         child: _isLoading
// //             ? _buildLoading()
// //             : Column(
// //                 children: [
// //                   _buildSettings(),
// //                   const SizedBox(height: 50),
// //                   _buildPomodoro(),
// //                   const Spacer(),
// //                   _buildAmountOfSession(),
// //                   const Spacer(),
// //                   _buildButtons(),
// //                   const SizedBox(height: 35),
// //                 ],
// //               ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildSettings() {
// //     return Align(
// //       alignment: Alignment.topRight,
// //       child: IconButton(
// //         onPressed: () {
// //           Navigator.push(
// //               context, MaterialPageRoute(builder: (_) => const SettingsPage()));
// //         },
// //         icon: const Icon(Icons.menu, color: CustomColors.white),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildPomodoro() {
// //     return Stack(
// //       children: [
// //         SizedBox(
// //           width: 300,
// //           height: 300,
// //           child: CircularProgressIndicator(
// //             value: _timerDuration.inSeconds / (_pomodoro * 60),
// //             color: CustomColors.white,
// //             backgroundColor: Colors.grey,
// //             strokeWidth: 4,
// //           ),
// //         ),
// //         Positioned(
// //           top: 100,
// //           left: 70,
// //           child: Text(
// //             '${_timerDuration.inMinutes.toString().padLeft(2, '0')}:${(_timerDuration.inSeconds % 60).toString().padLeft(2, '0')}',
// //             style: GoogleFonts.poppins(fontSize: 60, color: CustomColors.white),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildAmountOfSession() {
// //     int totalSessions = _pomodoro ~/ (_pauseValue + 1);
// //     int completedPomodoros = (_currentSession ~/ 2) + 1;
// //     String sessionText = '$completedPomodoros/$totalSessions';
// //     return Text(
// //       sessionText,
// //       style: GoogleFonts.poppins(
// //         fontSize: 18,
// //         color: CustomColors.white,
// //         fontWeight: FontWeight.w400,
// //       ),
// //     );
// //   }
// //
// //   Widget _buildButtons() {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.center,
// //       children: [
// //         CircleAvatar(
// //           radius: 30,
// //           backgroundColor: Colors.grey.shade200,
// //           child: GestureDetector(
// //             onTap: () {
// //               setState(() {
// //                 _timerDuration = const Duration(minutes: 2);
// //               });
// //             },
// //             child: const Icon(Icons.restart_alt, size: 30, color: Colors.grey),
// //           ),
// //         ),
// //         const SizedBox(width: 10),
// //         GestureDetector(
// //           onTap: () {
// //             if (_isRunning) {
// //               _stopTimer();
// //             } else {
// //               _startTimer();
// //             }
// //           },
// //           child: CircleAvatar(
// //             radius: 45,
// //             backgroundColor: CustomColors.white,
// //             child: _isRunning
// //                 ? Icon(Icons.pause, size: 35, color: _backgroundColor)
// //                 : Icon(Icons.play_arrow, size: 35, color: _backgroundColor),
// //           ),
// //         ),
// //         const SizedBox(width: 10),
// //         CircleAvatar(
// //           radius: 30,
// //           backgroundColor: Colors.grey.shade200,
// //           child: GestureDetector(
// //             onTap: _restartTimer,
// //             child: const Icon(Icons.remove, size: 30, color: Colors.grey),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildLoading() {
// //     return const Center(
// //         child: CircularProgressIndicator(color: CustomColors.white));
// //   }
// // }
// //
// // // void _startTimer() {
// // //   if (_timer != null) {
// // //     _timer!.cancel();
// // //   }
// // //   setState(() {
// // //     _isRunning = true;
// // //   });
// // //   _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
// // //     setState(() {
// // //       if (_timerDuration.inSeconds > 0) {
// // //         _timerDuration = _timerDuration - const Duration(seconds: 1);
// // //       } else {
// // //         if (_currentSession < _totalSessions - 1) {
// // //           _currentSession++;
// // //           if (_currentSession % (_pomodoro + _pauseValue) == 0) {
// // //             //_timerDuration = Duration(minutes: _pauseDuration);
// // //           } else if (_currentSession % (_pomodoro + _pauseValue) <= _pomodoro) {
// // //             _timerDuration = Duration(minutes: _pomodoro);
// // //           } else {
// // //             _timerDuration = Duration(minutes: _pomodoro);
// // //           }
// // //         } else {
// // //           _stopTimer();
// // //           _currentSession = 0;
// // //           _timerDuration = Duration(minutes: _pomodoro);
// // //           //_timerDuration = _sessions[_currentSession];
// // //         }
// // //       }
// // //     });
// // //   });
// // // }
