import 'package:cached_network_image/cached_network_image.dart';
import 'package:cha_cha_games/components/card_back.dart';
import 'package:cha_cha_games/constants.dart';
import 'package:cha_cha_games/models/card_model.dart';
import 'package:cha_cha_games/models/whot_card_model.dart';
import 'package:cha_cha_games/models/whot_player_model.dart';
import 'package:cha_cha_games/models/whot_turn_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PlayerCard extends StatelessWidget {
  // final WhotCardModel card;
  final double size;
  final bool visible;
  final Function(CardModel)? onPlayCard;
  WhotTurn? turn;
  final int index;
  final WhotPlayerModel? player;

  PlayerCard(
      {Key? key,
      // required this.card,
      this.size = 1,
      this.visible = false,
      this.onPlayCard,
      required this.index,
      this.turn,
      this.player})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () {
      //   if (turn!.currentPlayer == player) {
      //     turn!.playCard(index);
      //   }
      // },
      child: Container(
          width: CARD_WIDTH * size,
          height: CARD_HEIGHT * size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 3,
                blurRadius: 5,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
            border: Border.all(
              color: Colors.grey.withOpacity(0.5),
              width: 1.0,
            ),
            color: Colors.white,
          ),
          clipBehavior: Clip.antiAlias,
          // SvgPicture.asset(card.image,
          //                 width: CARD_WIDTH * size / 3,
          //                 height: CARD_HEIGHT * size / 3,
          //                 // colorFilter:
          //                 //     ColorFilter.mode(Colors.red, BlendMode.srcIn),
          //                 semanticsLabel: card.shape),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    backgroundColor: Colors.green,
                    maxRadius: 70,
                    child: Text(
                      "${player?.id}",
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ), //Text
                  ),
                ),
                const Align(
                  alignment: Alignment.topCenter,
                  child: Text("Player"),
                ),
                // Align(
                //   alignment: Alignment.topRight,
                //   child: Text("${card.value}"),
                // ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text("Cards"),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text("${player?.cards.length}"),
                ),
              ],
            ),
          )
          // child: visible
          //     ? CachedNetworkImage(
          //         imageUrl: card.image,
          //         width: CARD_WIDTH * size / 2,
          //         height: CARD_HEIGHT * size / 2,
          //       )
          //     : CardBack(size: size),
          ),
    );
  }
}
