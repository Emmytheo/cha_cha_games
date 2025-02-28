import 'package:cha_cha_games/models/player_model.dart';

class Turn {
  final List<PlayerModel> players;
  int index;
  PlayerModel currentPlayer;
  int drawCount;
  int actionCount;

  Turn({
    required this.players,
    required this.currentPlayer,
    this.index = 0,
    this.drawCount = 0,
    this.actionCount = 0,
  });

  void nextTurn() {
    index += 1;
    currentPlayer = index % 2 == 0 ? players[0] : players[1];
    drawCount = 0;
    actionCount = 0;
  }

  PlayerModel get otherPlayer {
    return players.firstWhere((p) => p != currentPlayer);
  }
}
