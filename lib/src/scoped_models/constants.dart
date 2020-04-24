part of 'game_model.dart';

/// Describes who's turn it is to play.
enum Turn { player1, player2 }

/// Describes the game status, i.e. whether moves are yet left to play or all moves have been consumed, hence, a draw.
enum _GameStatus { moves_available, draw }

/// Describes the play status, i.e. whether either of the players have won or the game is still on.
enum _PlayStatus { player1_won, player2_won, active }

/// Describes the moves status, i.e. whether a move at a given index is available to be played or not.
enum _MoveStatus { next_move_available, next_move_unavailable }

enum StatusChange {
  draw,
  player1_won,
  player2_won,
  error_next_move_unavailable,
  none,
}