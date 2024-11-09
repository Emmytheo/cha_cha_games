import 'package:cha_cha_games/components/card_list.dart';
import 'package:cha_cha_games/components/discard_pile.dart';
import 'package:cha_cha_games/components/player_info.dart';
import 'package:cha_cha_games/components/player_list.dart';
import 'package:cha_cha_games/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cha_cha_games/providers/whot_game_provider.dart';
import 'package:cha_cha_games/models/coordinate.dart';
import 'package:cha_cha_games/models/block_table.dart';
import 'package:cha_cha_games/models/men.dart';
import 'package:google_fonts/google_fonts.dart';

class WhotGameScreen extends StatefulWidget {
  const WhotGameScreen({Key? key}) : super(key: key);

  @override
  State<WhotGameScreen> createState() => _WhotGameScreenState();
}

class _WhotGameScreenState extends State<WhotGameScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WhotGameProvider>(context, listen: false);
    final Color colorBackgroundF = const Color(0xffeec295);
    final Color colorBackgroundT = const Color(0xff9a6851);
    final Color colorBorderTable = const Color(0xff6d3935);
    final Color colorAppBar = const Color(0xff6d3935);
    final Color colorBackgroundGame = const Color(0xffc16c34);
    final Color colorBackgroundHighlight = Colors.blue[500]!;
    final Color colorBackgroundHighlightAfterKilling = Colors.purple[500]!;

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (!provider.isMenInitialized) {
    //     provider.initMen(); // Initialize men pieces after the build.
    //   }
    // });

    return Container(
      decoration: chachaBackground(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Whot Game',
            style: GoogleFonts.inter(color: Colors.white),
          ),
          backgroundColor: chachaAppBarColor(),
        ),
        body: Consumer<WhotGameProvider>(
          builder: (context, provider, child) {
            if (!provider.gameStart) {
              return Center(
                child: Text('Waiting for the game to start...', style: GoogleFonts.inter(color: Colors.white),),
              );
            } else if (provider.gameStart) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                // if (!provider.isMenInitialized) {
                //   provider.initMen(); // Initialize men pieces after the build.
                // }
              });
            }

            return Column(
              children: [
                // Text(
                //   provider.whot_turn.currentPlayer == provider.primaryPlayer
                //       ? "It's your turn"
                //       : "Waiting for opponent...",
                //   style:
                //       const GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
                // ),
                // const SizedBox(height: 10),
                Expanded(
                  child: Center(
                    child: Column(
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // GestureDetector(
                                        //   onTap: () async {
                                        //     await model
                                        //         .drawCards(model.turn.currentPlayer);
                                        //   },
                                        //   child: DeckPile(
                                        //     remaining: model.currentDeck!.remaining,
                                        //   ),
                                        // ),
                                        // const SizedBox(width: 8),
                                        DragTarget<int>(
                                          builder: (
                                            BuildContext context,
                                            List<dynamic> accepted,
                                            List<dynamic> rejected,
                                          ) {
                                            return DiscardPile(
                                              cards:
                                                  provider.whot_turn.discardz,
                                              // onPressed: (card) {
                                              //   model.drawCardsFromDiscard(
                                              //       model.turn.currentPlayer);
                                              // },
                                            );
                                          },
                                          onAcceptWithDetails:
                                              (DragTargetDetails<int> details) {
                                            setState(() {
                                              provider.whot_turn
                                                  .playCard(details.data);
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    if (provider.bottomWidget != null &&
                                        provider.showBottomWidget)
                                      provider.bottomWidget!
                                  ],
                                ),
                              ),
                              Align(
                                  alignment: Alignment.topCenter,
                                  child: provider.playerz!.length > 1
                                      ? Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            PlayerInfo(
                                                turn: provider.whot_turn,
                                                players: provider.playerz, discardz: provider.whot_turn.discardz),
                                            PlayerList(
                                              player: provider
                                                  .whot_turn.currentPlayer,
                                              turn: provider.whot_turn,
                                              botCard: true,
                                              otherPlayers: provider.playerz!
                                                  .where(
                                                      (p) => p.isHuman == false)
                                                  .toList(),
                                            ),
                                          ],
                                        )
                                      : Container()),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: (provider
                                                  .whot_turn.currentPlayer ==
                                              provider.primaryPlayer)
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                ...provider.additionalButtons
                                                    .map((button) => Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 4),
                                                          child: ElevatedButton(
                                                              onPressed: button
                                                                      .enabled
                                                                  ? button
                                                                      .onPressed
                                                                  : null,
                                                              child: Text(button
                                                                  .label)),
                                                        ))
                                                    .toList(),

                                                Row(
                                                  children: [
                                                    provider.whot_turn
                                                            .draggable!
                                                        ? const Icon(
                                                            Icons.swipe_left,
                                                          )
                                                        : const Icon(
                                                            Icons.do_not_touch,
                                                          ),
                                                    Switch(
                                                      // thumb color (round icon)
                                                      activeColor: Colors.cyan,
                                                      activeTrackColor:
                                                          Colors.white,
                                                      inactiveThumbColor: Colors
                                                          .blueGrey.shade600,
                                                      inactiveTrackColor:
                                                          Colors.grey.shade400,
                                                      splashRadius: 50.0,
                                                      // boolean variable value
                                                      value: provider
                                                          .whot_turn.draggable!,
                                                      // changes the state of the switch
                                                      onChanged:
                                                          (bool newValue) {
                                                        setState(() {
                                                          provider.whot_turn
                                                                  .draggable =
                                                              newValue;
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                // const ElevatedButton(
                                                //     onPressed: null,
                                                //     // onPressed: provider.canEndTurn
                                                //     //     ? () {
                                                //     //         provider.endTurn();
                                                //     //       }
                                                //     //     : null,
                                                //     child: Text("Your Turn"))
                                              ],
                                            )
                                          : Container(),
                                    ),
                                    CardList(
                                        player: provider.playerz![0],
                                        turn: provider.whot_turn
                                        // onPlayCard: (CardModel card) {
                                        //   model.playCard(
                                        //       player: model.players[0], card: card);
                                        // },
                                        ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
