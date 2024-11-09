import 'package:cha_cha_games/models/card_model.dart';
import 'package:cha_cha_games/models/turn_model.dart';
import 'package:cha_cha_games/models/whot_card_model.dart';
import 'package:cha_cha_games/models/whot_player_model.dart';
import 'package:cha_cha_games/models/whot_turn_model.dart';
import 'package:flutter/material.dart';
import 'package:cha_cha_games/constants.dart';

class PlayerInfo extends StatelessWidget {
  final WhotTurn? turn;
  final List<WhotPlayerModel>? players;
  late List<WhotCardModel>? discardz;
  PlayerInfo(
      {Key? key,
      required this.turn,
      required this.players, this.discardz,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.black87,
      margin: EdgeInsetsDirectional.only(top: 4),
      decoration: BoxDecoration(
        color: chachaVeryLightColor(),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      // width: double.minPositive,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                players!.length > 1 &&
                        players!.indexWhere(
                                (plyr) => plyr.nowPlaying == true) !=
                            -1
                    ? (players!.indexWhere((plyr) => plyr.nowPlaying == true) ==
                            0
                        ? ("Your turn" '${players!.indexWhere((plyr) => plyr.lastPlayed == true) != -1 && discardz!.isNotEmpty && discardz![0].iNeed != null ? ' - Player ${players![players!.indexWhere((plyr) => plyr.lastPlayed == true)].id} needs a ${discardz![0].iNeed}' : ' '}'  )
                        : ("Player ${players![players!.indexWhere((plyr) => plyr.nowPlaying == true)].id}'s turn"))
                    : turn!.currentPlayer == players![0]
                        ? ("Your turn")
                        : ('Loading Players...'),
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ]

            // turn!.players!.map((p) {
            //   final isCurrent = turn!.currentPlayer == p;
            //   return Container(
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(3),
            //       color: isCurrent ? Colors.white : Colors.transparent,
            //     ),
            //     child: Padding(
            //       padding: const EdgeInsets.all(3.0),
            //       child: Text(
            //         "${p!.name} (${p.cards.length})",
            //         style: TextStyle(
            //             color: isCurrent ? Colors.black : Colors.white,
            //             fontWeight: FontWeight.w700),
            //       ),
            //     ),
            //   );
            // }).toList(),
            ),
      ),
    );
  }
}
