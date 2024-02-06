import 'package:just_audio/just_audio.dart';
import 'package:pomodoro/app/data/enums/pomodoro_status.dart';
import 'package:pomodoro/app/data/enums/tones.dart';
import 'package:pomodoro/app/data/models/pomodoro_task_model.dart';
import 'package:pomodoro/app/utils/constants/assets_path.dart';
import 'package:real_volume/real_volume.dart';
import 'package:vibration/vibration.dart';
import 'package:audio_session/audio_session.dart';

// Configuração de áudio para o toque do celular (ringtone):
const _ringtoneAudioConfig = AudioSessionConfiguration(
  avAudioSessionCategory: AVAudioSessionCategory.playback,
  avAudioSessionMode: AVAudioSessionMode.defaultMode,
  androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
  androidAudioAttributes: AndroidAudioAttributes(
    contentType: AndroidAudioContentType.speech,
    flags: AndroidAudioFlags.none,
    usage: AndroidAudioUsage.notificationRingtone,
  ),
);

class PomodoroSoundPlayer {
  late AudioPlayer _tonePlayer;
  late AudioPlayer _statusPlayer;

  // Inicializa os players de áudio:
  Future<void> init() async {
    _statusPlayer = AudioPlayer();
    _tonePlayer = AudioPlayer();
    (await AudioSession.instance).configure(_ringtoneAudioConfig);
  }

  // Verifica se o player de som está silenciado com base nas configurações da tarefa:
  Future<bool> isSoundPlayerMuted(PomodoroTaskModel task) async {
    if (await canVibrate() && task.vibrate) return false;
    return (task.tone == Tones.none && task.readStatusAloud == false) ||
        await isRingerMuted() ||
        (task.statusVolume == 0.0 && task.toneVolume == 0.0);
  }

  // Verifica se o toque do celular está silenciado:
  Future<bool> isRingerMuted() async {
    return await RealVolume.getRingerMode() == RingerMode.SILENT;
  }

  // Verifica se o som não pode ser reproduzido (por exemplo, quando o modo de toque do celular não é NORMAL):
  Future<bool> cantPlaySound() async {
    return await RealVolume.getRingerMode() != RingerMode.NORMAL;
  }

  // Verifica se o dispositivo pode vibrar:
  Future<bool> canVibrate() async {
    return (await RealVolume.getRingerMode() != RingerMode.SILENT) &&
        ((await Vibration.hasVibrator()) ?? false);
  }

  // Faz o dispositivo vibrar:
  Future<void> vibrate() async {
    if (await canVibrate()) {
      await Vibration.vibrate(pattern: [0, 300, 100, 300]);
    } else {
      await Vibration.vibrate();
    }
  }

  // Define o volume do som do dispositivo:
  Future<void> setVolume(double volume) async {
    if (await cantPlaySound()) return;
    await RealVolume.setVolume(volume,
        showUI: false, streamType: StreamType.RING);
  }

  // Reproduz um toque (som) com um determinado volume:
  Future<void> playTone(Tones tone, [double? volume]) async {
    if (await cantPlaySound()) return;
    if (tone != Tones.none && volume != 0.0) {
      if (volume != null) setVolume(volume);
      final path = '$kTonesBasePath${tone.name}.${tone.type}';
      await _tonePlayer.setAsset(path);
      await _tonePlayer.play();
    }
  }

  // Reproduz o som do Pomodoro com base nas configurações da tarefa:
  Future<void> playPomodoroSound(PomodoroTaskModel task) async {
    if (task.vibrate) {
      vibrate();
    }

    playTone(task.tone, task.toneVolume);

    if (task.readStatusAloud && task.statusVolume != 0.0) {
      await Future.delayed(const Duration(seconds: 1));
      await setVolume(task.toneVolume);
      await readStatusAloud(task.pomodoroStatus);
    }
  }

  // Lê o status do Pomodoro em voz alta:
  Future<void> readStatusAloud(PomodoroStatus status) async {
    if (await cantPlaySound()) return;
    if (status.isWorkTime) {
      await _statusPlayer.setAsset(kWorkTimeSoundPath);
    } else if (status.isShortBreakTime) {
      await _statusPlayer.setAsset(kShortBreakTimeSoundPath);
    } else {
      await _statusPlayer.setAsset(kLongBreakSoundPath);
    }
    await _statusPlayer.play();
  }

  // Libera os recursos dos players de áudio:
  Future<void> dispose() async {
    await _statusPlayer.dispose();
    await _tonePlayer.dispose();
  }
}
