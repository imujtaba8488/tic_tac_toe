import 'dart:math';

import 'package:scoped_model/scoped_model.dart';
import 'package:tic_tac_toe/src/player.dart';
import 'package:tic_tac_toe/src/victory_combinations.dart';
import 'package:tic_tac_toe/src/win_possibilities.dart';

import '../sound_effect.dart';

enum Turn { player1, player2 }

class GameModel extends Model {
  List<String> places = List(9);

  _GameStatus _gameStatus = _GameStatus.moves_available;
  _MoveStatus _moveStatus = _MoveStatus.next_move_available;
  _PlayStatus _playStatus = _PlayStatus.active;

  Player player1, player2;
  Turn turn;
  List<int> winKey = [];
  bool againstAI;

  SoundEffectPlayer _soundEffectPlayer;

  Function onGameStatusChange;

  GameModel(
    this.player1,
    this.player2,
    this.turn, {
    this.againstAI = true,
    this.onGameStatusChange,
  }) {
    // init moves...
    for (int i = 0; i < 9; i++) {
      places[i] = '';
    }

    _soundEffectPlayer = SoundEffectPlayer();
  }

  void playMove(int at) {
    _checkGameStatus();
    _checkMoveStatus(at);

    if (_gameStatus == _GameStatus.moves_available) {
      if (_playStatus == _PlayStatus.active) {
        if (_moveStatus == _MoveStatus.next_move_available) {
          _checkPlayStatus();

          turn == Turn.player1 ? _play(at, player1) : _play(at, player2);
        } else {
          _onStatusChange();
          notifyListeners();
        }
      } else {
        _onStatusChange();
        notifyListeners();
      }
    } else {
      _onStatusChange();
      notifyListeners();
    }
  }

  void _play(int at, Player player) {
    places[at] = player.mark;
    player.movesPlayed.add(at);

    _soundEffectPlayer.play(player.moveSoundEffect);

    _switchTurn();
    _checkPlayStatus();
    _checkGameStatus();

    if (againstAI) {
      if (turn == Turn.player2) {
        Future.delayed(Duration(milliseconds: 500), () {
          _aiPlay();
          notifyListeners();
        });
      }
    }
  }

  void _checkGameStatus() {
    if (places.contains('')) {
      _gameStatus = _GameStatus.moves_available;
    } else {
      _gameStatus = _GameStatus.draw;
      _onStatusChange();
      notifyListeners();
    }
  }

  void _checkPlayStatus() {
    if (hasWon(player1.movesPlayed)) {
      winKey = winningCombination(player1.movesPlayed);
      _playStatus = _PlayStatus.player1_won;
      _onStatusChange();
      notifyListeners();
    } else if (hasWon(player2.movesPlayed)) {
      winKey = winningCombination(player2.movesPlayed);
      _playStatus = _PlayStatus.player2_won;
      _onStatusChange();
      notifyListeners();
    } else {
      _playStatus = _PlayStatus.active;
    }
  }

  void _checkMoveStatus(int at) {
    if (places[at].isEmpty) {
      _moveStatus = _MoveStatus.next_move_available;
    } else {
      _moveStatus = _MoveStatus.next_move_unavailable;
    }
  }

  void _switchTurn() =>
      turn == Turn.player1 ? turn = Turn.player2 : turn = Turn.player1;

  List<int> get movesRemaining {
    List<int> remaining = [];

    for (int i = 0; i < places.length; i++) {
      if (places[i].isEmpty) {
        remaining.add(i);
      }
    }

    return remaining;
  }

  void _reset() {
    player1.movesPlayed.clear();
    player2.movesPlayed.clear();
    _gameStatus = _GameStatus.moves_available;
    _moveStatus = _MoveStatus.next_move_available;
    _playStatus = _PlayStatus.active;
    winKey.clear();

    for (int i = 0; i < places.length; i++) {
      places[i] = '';
    }
    notifyListeners();
  }

  void _onStatusChange() {
    if (_gameStatus == _GameStatus.draw) {
      player1.updateDraw();
      _soundEffectPlayer.play(SoundEffect.draw);
      onGameStatusChange('draw', onPressed: _reset);
    } else if (_playStatus == _PlayStatus.player1_won) {
      _soundEffectPlayer.play(SoundEffect.win);
      onGameStatusChange(player1.name + ' has won.', onPressed: _reset);
    } else if (_playStatus == _PlayStatus.player2_won) {
      _soundEffectPlayer.play(SoundEffect.lost);
      onGameStatusChange(player2.name + ' has won.', onPressed: _reset);
    } else if (_moveStatus == _MoveStatus.next_move_unavailable) {
      _soundEffectPlayer.play(SoundEffect.error);
      onGameStatusChange("error: move not available.", buttonText: 'OK');
    }
  }

  void _aiPlay() {
    if (isWinPossible(player2.movesPlayed, places) >= 0) {
      playMove(isWinPossible(player2.movesPlayed, places));
    } else if (isWinPossible(player1.movesPlayed, places) >= 0) {
      playMove(isWinPossible(player1.movesPlayed, places));
    } else {
      _playRandomMove();
    }
  }

  void _playRandomMove() {
    movesRemaining.shuffle();
    playMove(movesRemaining[Random().nextInt(movesRemaining.length)]);
  }
}

enum _GameStatus { moves_available, draw }

enum _PlayStatus { player1_won, player2_won, active }

enum _MoveStatus { next_move_available, next_move_unavailable }
