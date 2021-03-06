import 'package:assets_audio_player/assets_audio_player.dart';

enum SoundEffect { userMove, aiMove, win, lost, draw, background, error }

class SoundEffectPlayer {
  static final AssetsAudioPlayer _audioPlayer = AssetsAudioPlayer();

  void play(SoundEffect soundEffect) {
    switch (soundEffect) {
      case SoundEffect.userMove:
        _audioPlayer.open('assets/audio/move2.mp3');
        _audioPlayer.play();
        break;

      case SoundEffect.aiMove:
        _audioPlayer.open('assets/audio/move.mp3');
        _audioPlayer.play();
        break;

      case SoundEffect.win:
        _audioPlayer.open('assets/audio/won.mp3');
        _audioPlayer.play();
        break;

      case SoundEffect.lost:
        _audioPlayer.open('assets/audio/lost.mp3');
        _audioPlayer.play();
        break;

      case SoundEffect.draw:
        _audioPlayer.open('assets/audio/draw.mp3');
        break;

      case SoundEffect.error:
        _audioPlayer.open('assets/audio/error.mp3');
        _audioPlayer.play();
        break;

      case SoundEffect.background:
        _audioPlayer.open('assets/audio/background.mp3');
        _audioPlayer.play();
        break;

      default:
        // Todo: Perhaps play the background sound or decide.
        break;
    }
  }

  /// Stops the sound effect from playing.
  void stop() {
    _audioPlayer.stop();
  }
}
