import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomodoro/app/core/utils/custom_colors.dart';
import 'package:pomodoro/app/modules/home/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Duration _timerDuration = const Duration(minutes: 1);
  bool _isRunning = false;
  Timer? _timer;
  int _currentSession = 0;

  // void _startTimer() {
  //   if (_timer != null) {
  //     _timer!.cancel();
  //   }
  //   setState(() {
  //     _isRunning = true;
  //   });
  //   _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     setState(() {
  //       if (_timerDuration.inSeconds > 0) {
  //         _timerDuration = _timerDuration - const Duration(seconds: 1);
  //       } else {
  //         if (_currentSession % 2 == 0) {
  //           _currentSession++;
  //           _timerDuration = _sessions[_currentSession];
  //           //reinicia o timer para a proxima sessao
  //         } else {
  //           _currentSession++;
  //           _currentSession %= _sessions.length;
  //           _timerDuration = _sessions[_currentSession];
  //           // Passa para a próxima sessão ou volta para a primeira sessão
  //         }
  //       }
  //     });
  //   });
  // }

  void _startTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    setState(() {
      _isRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerDuration.inSeconds > 0) {
          _timerDuration = _timerDuration - const Duration(seconds: 1);
        } else {
          if (_currentSession >= _sessions.length) {
            _stopTimer();
          } else {
            _currentSession++;
            _timerDuration = _sessions[_currentSession];
          }
        }
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _timerDuration = const Duration(minutes: 1);
    });
  }

  // void _resetTimerDuration(){
  //   _timerDuration = _sessions[0];
  //
  // }

  void _restartTimer(){
    _stopTimer();
    _currentSession = 0;
    _timerDuration = _sessions[_currentSession];
  }

  final List<Duration> _sessions = [
    const Duration(minutes: 1), // Duração da sessão 1 (1 minutos)
    const Duration(minutes: 1), // Duração da pausa 1 (5 minutos)
    const Duration(minutes: 1), // Duração da sessão 2 (1 minutos)
    const Duration(minutes: 1), // Duração da pausa 2 (5 minutos)
    // Adicione mais sessões e pausas conforme necessário
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.pinkMain,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const SettingsPage()));
                },
                icon: const Icon(Icons.menu, color: CustomColors.white),
              ),
            ),
            const SizedBox(height: 50),
            Stack(
              children: [
                SizedBox(
                  width: 300,
                  height: 300,
                  child: CircularProgressIndicator(
                    value: _timerDuration.inSeconds /
                        const Duration(minutes: 1).inSeconds,
                    color: CustomColors.white,
                    backgroundColor: Colors.grey,
                    strokeWidth: 4,
                  ),
                ),
                Positioned(
                  top: 100,
                  left: 70,
                  child: Text(
                    '${_timerDuration.inMinutes.toString().padLeft(2, '0')}:${(_timerDuration.inSeconds % 60).toString().padLeft(2, '0')}',
                    style: GoogleFonts.poppins(
                        fontSize: 60, color: CustomColors.white),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text("${_currentSession + 1} de ${_sessions.length} sessões",
                style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: CustomColors.white,
                    fontWeight: FontWeight.w400)),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.grey.shade200,
                  child: GestureDetector(
                    onTap: _stopTimer,
                    child: const Icon(Icons.restart_alt,
                        size: 30, color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    if (_isRunning) {
                      _stopTimer();
                    } else {
                      _startTimer();
                    }
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: CustomColors.white,
                    child: _isRunning
                        ? const Icon(Icons.pause,
                            size: 35, color: CustomColors.pinkMain)
                        : const Icon(Icons.play_arrow,
                            size: 35, color: CustomColors.pinkMain),
                  ),
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.grey.shade200,
                  child: GestureDetector(
                    onTap: _restartTimer,
                    child:
                        const Icon(Icons.remove, size: 30, color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }
}
