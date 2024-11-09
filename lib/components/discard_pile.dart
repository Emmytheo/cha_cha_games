import 'package:cha_cha_games/components/playing_card.dart';
import 'package:cha_cha_games/constants.dart';
import 'package:cha_cha_games/models/card_model.dart';
import 'package:cha_cha_games/models/whot_card_model.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class DiscardPile extends StatelessWidget {
  final List<WhotCardModel>? cards;
  final double size;
  final Function(CardModel)? onPressed;

  const DiscardPile({
    Key? key,
    required this.cards,
    this.size = 1,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () {
      //   if (onPressed != null) {
      //     onPressed!(cards.last);
      //   }
      // },
      child: Container(
        width: CARD_WIDTH * size,
        height: CARD_HEIGHT * size,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black45, width: 1),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          // border: Border.all(
          //   color: Colors.grey.withOpacity(0.5),
          //   width: 1.0,
          // ),
          color: Colors.white,
        ),
        child: IgnorePointer(
          ignoring: true,
          child: Stack(
            children: cards!
                .mapIndexed((index, card) => PlayingCard(
                      card: card,
                      visible: true, index: index,
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
