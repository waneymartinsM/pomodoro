enum ScreenNotifierEvent {
  showPomodoroFinishSnackBar,
  showMuteAlertSnackBar;

  bool get isShowPomodoroFinishSnackBar => this == showPomodoroFinishSnackBar;
  bool get isShowMuteAlertSnackBar => this == showMuteAlertSnackBar;
}
