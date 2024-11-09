import 'package:cha_cha_games/components/dragged_playing_card.dart';
import 'package:cha_cha_games/components/playing_card.dart';
import 'package:cha_cha_games/constants.dart';
import 'package:cha_cha_games/models/card_model.dart';
import 'package:cha_cha_games/models/player_model.dart';
import 'package:cha_cha_games/models/whot_card_model.dart';
import 'package:cha_cha_games/models/whot_player_model.dart';
import 'package:cha_cha_games/models/whot_turn_model.dart';
import 'package:flutter/material.dart';

class CardList extends StatelessWidget {
  final double size;
  final WhotPlayerModel? player;
  final Function(CardModel)? onPlayCard;
  WhotTurn? turn;
  bool? botCard;

  CardList({
    Key? key,
    required this.player,
    this.size = 1,
    this.onPlayCard,
    this.turn,
    this.botCard = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: CARD_HEIGHT * size,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: player!.cards.length,
        itemBuilder: (context, index) {
          final card = player!.cards[index];
          final isDraggable = turn!.currentPlayer == player;

          return isDraggable && turn!.draggable!
              ? Draggable<int>(
                  // Data is the value this Draggable stores.
                  data: index,
                  childWhenDragging: PlayingCard(
                    card: card,
                    size: size,
                    // visible: player!.isHuman,
                    visible: player!.isHuman && botCard == false ? true : false,
                    onPlayCard: onPlayCard,
                    index: index,
                    turn: turn,
                    player: player,
                  ),
                  feedback: DraggedPlayingCard(
                    card: card,
                    size: size,
                    // visible: player!.isHuman,
                    visible: player!.isHuman && botCard == false ? true : false,
                    onPlayCard: onPlayCard,
                    index: index,
                    turn: turn,
                    player: player,
                  ),
                  child: PlayingCard(
                    card: card,
                    size: size,
                    // visible: player!.isHuman,
                    visible: player!.isHuman && botCard == false ? true : false,
                    onPlayCard: onPlayCard,
                    index: index,
                    turn: turn,
                    player: player,
                  ),
                )
              : PlayingCard(
                  card: card,
                  size: size,
                  // visible: player!.isHuman,
                  visible: player!.isHuman && botCard == false ? true : false,
                  onPlayCard: onPlayCard,
                  index: index,
                  turn: turn,
                  player: player,
                );
        },
      ),
    );
  }
}
