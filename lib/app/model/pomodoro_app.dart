class PomodoroApp {
  int? pomodoroTime;
  int? numberBreaks;
  int? timePause;
  String? colorTheme;

  PomodoroApp({
    this.pomodoroTime,
    this.numberBreaks,
    this.timePause,
    this.colorTheme,
  });

  PomodoroApp.fromJson(Map<String, dynamic> json) {
    pomodoroTime = json['pomodoro_time'];
    numberBreaks = json['number_breaks'];
    timePause = json['time_pause'];
    colorTheme = json['color_theme'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pomodoro_time'] = pomodoroTime;
    data['number_breaks'] = numberBreaks;
    data['time_pause'] = timePause;
    data['color_theme'] = colorTheme;
    return data;
  }
}
