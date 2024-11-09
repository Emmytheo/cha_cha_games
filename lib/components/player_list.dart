import 'package:cha_cha_games/components/dragged_playing_card.dart';
import 'package:cha_cha_games/components/player_card.dart';
import 'package:cha_cha_games/components/playing_card.dart';
import 'package:cha_cha_games/constants.dart';
import 'package:cha_cha_games/models/card_model.dart';
import 'package:cha_cha_games/models/player_model.dart';
import 'package:cha_cha_games/models/whot_card_model.dart';
import 'package:cha_cha_games/models/whot_player_model.dart';
import 'package:cha_cha_games/models/whot_turn_model.dart';
import 'package:flutter/material.dart';

class PlayerList extends StatelessWidget {
  final double size;
  final WhotPlayerModel? player;
  final Function(CardModel)? onPlayCard;
  WhotTurn? turn;
  bool? botCard;
  final List<WhotPlayerModel> otherPlayers;

  PlayerList({
    Key? key,
    required this.player,
    this.size = 1,
    this.onPlayCard,
    this.turn,
    this.botCard = false,
    required this.otherPlayers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(top: 10),
      child: SizedBox(
        height: CARD_HEIGHT * size,
        width: double.infinity,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: otherPlayers.length,
          itemBuilder: (context, index) {
            // final card = player!.cards[index];
            final isDraggable = turn!.currentPlayer == player;
      
            return PlayerCard(
                    // card: card,
                    size: size,
                    // visible: player!.isHuman,
                    visible:  true,
                    onPlayCard: onPlayCard,
                    index: index,
                    turn: turn,
                    player: otherPlayers[index],
                  );
          },
        ),
      ),
    );
  }
}
