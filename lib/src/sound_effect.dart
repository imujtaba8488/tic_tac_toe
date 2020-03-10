import 'package:assets_audio_player/assets_audio_player.dart';

enum SoundEffect { playerMove, aiMove, win, lost, error }

class SoundEffectPlayer {
  static final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();

  void play(SoundEffect soundEffect) {
    switch (soundEffect) {
      case SoundEffect.playerMove:
        audioPlayer.open('assets/audio/move2.mp3');
        audioPlayer.play();
        break;

      case SoundEffect.aiMove:
        audioPlayer.open('assets/audio/move.mp3');
        audioPlayer.play();
        break;

      case SoundEffect.win:
        audioPlayer.open('assets/audio/win.mp3');
        audioPlayer.play();
        break;

      case SoundEffect.lost:
        audioPlayer.open('assets/audio/lost.mp3');
        audioPlayer.play();
        break;

      case SoundEffect.error:
        audioPlayer.open('assets/audio/'); // Todo
        audioPlayer.play();
        break;

      default:
        // Todo: Perhaps play the background sound or decide.
        break;
    }
  }
}