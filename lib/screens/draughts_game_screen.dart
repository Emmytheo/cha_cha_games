import 'package:cha_cha_games/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cha_cha_games/providers/draughts_game_provider.dart';
import 'package:cha_cha_games/models/coordinate.dart';
import 'package:cha_cha_games/models/block_table.dart';
import 'package:cha_cha_games/models/men.dart';
import 'package:google_fonts/google_fonts.dart';

class DraughtsGameScreen extends StatelessWidget {
  const DraughtsGameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DraughtsGameProvider>(context, listen: false);

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
            'Draughts Game',
            style: GoogleFonts.inter(color: Colors.white),
          ),
          backgroundColor: chachaAppBarColor(),
        ),
        body: Consumer<DraughtsGameProvider>(
          builder: (context, provider, child) {
            if (!provider.isGameStarted) {
              return Center(
                child: Text(
                  'Waiting for the game to start...',
                  style: GoogleFonts.inter(color: Colors.white),
                ),
              );
            } else if (provider.isGameStarted) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!provider.isMenInitialized) {
                  provider.initMen(); // Initialize men pieces after the build.
                }
              });
            }

            return Column(
              children: [
                Container(
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text(
                      provider.yourTurn
                          ? "It's your turn"
                          : "Waiting for opponent...",
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Center(
                    child: buildGameTable(context, provider),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: chachaBottomAppBarColor(),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 3),
                            blurRadius: 12)
                      ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      buildCurrentPlayerTurn(
                        context,
                        provider,
                      )
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildGameTable(BuildContext context, DraughtsGameProvider provider) {
    const Color colorBorderTable = Color(0xff6d3935);
    const Color colorAppBar = Color(0xff6d3935);
    const Color colorBackgroundGame = Color(0xffc16c34);

    List<Widget> listCol = [];
    for (int row = 0; row < provider.board.length; row++) {
      List<Widget> listRow = [];
      for (int col = 0; col < provider.board[row].length; col++) {
        listRow.add(buildBlockContainer(
            context, provider, Coordinate(row: row, col: col)));
      }
      listCol.add(Row(mainAxisSize: MainAxisSize.min, children: listRow));
    }
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: colorBorderTable,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: listCol,
      ),
    );
  }

  Widget buildBlockContainer(
      BuildContext context, DraughtsGameProvider provider, Coordinate coor) {
    BlockTable block = provider.getBlock(coor);
    const Color colorBackgroundF = Color(0xffeec295);
    const Color colorBackgroundT = Color(0xff9a6851);
    final Color colorBackgroundHighlight = Colors.blue[500]!;
    final Color colorBackgroundHighlightAfterKilling = Colors.purple[500]!;
    // Alternate color for board cells (checkered pattern)
    Color colorBackground =
        (coor.row + coor.col) % 2 == 0 ? colorBackgroundF : colorBackgroundT;

    // Highlight colors
    if (block.isHighlight) {
      colorBackground = colorBackgroundHighlight;
    } else if (block.isHighlightAfterKilling) {
      colorBackground = colorBackgroundHighlightAfterKilling;
    }

    // Men widget
    Widget menWidget;
    if (block.men != null) {
      Men men = block.men!;
      menWidget = Center(
        child: buildMenWidget(player: men.player, isKing: men.isKing, size: 36),
      );

      // Make draggable only if it's the current player's turn and their piece
      if (provider.yourTurn && men.player == provider.currentPlayerTurn!) {
        menWidget = Draggable<Men>(
          child: menWidget,
          feedback: menWidget,
          childWhenDragging: Container(),
          data: men,
          onDragStarted: () {
            provider.highlightWalkable(men);
          },
          onDragEnd: (details) {
            provider.clearHighlightWalkable();
          },
        );
      }
    } else {
      menWidget = Container(); // Empty block if no Men
    }

    // DragTarget for each block
    return DragTarget<Men>(
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: 38,
          height: 38,
          color: colorBackground,
          margin: const EdgeInsets.all(2),
          child: menWidget,
        );
      },
      onWillAcceptWithDetails: (details) {
        return block.isHighlight || block.isHighlightAfterKilling;
      },
      onAcceptWithDetails: (details) {
        // Extract the source block coordinates (where the piece is being dragged from)
        final fromRow = details.data.coordinate.row;
        final fromCol = details.data.coordinate.col;

        // Extract the destination block coordinates (where the piece is being dragged to)
        final toRow = block.row;
        final toCol = block.col;

        // Print the move information for debugging
        print(
            'Moving player from Block ($fromCol, $fromRow) to Block ($toCol, $toRow)');

        // Validate and execute the move for the logged-in player
        provider.makeMove(
          Coordinate(row: fromRow, col: fromCol),
          Coordinate(row: toRow, col: toCol),
        );
      },
    );
  }

  Widget buildMenWidget(
      {int player = 1, bool isKing = false, double size = 30}) {
    if (isKing) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                  color: Colors.black45, offset: Offset(0, 4), blurRadius: 4)
            ],
            color: player == 1 ? Colors.black54 : Colors.grey[100]),
        child:
            Icon(Icons.star, color: player == 1 ? Colors.white : Colors.black),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
                color: Colors.black45, offset: Offset(0, 4), blurRadius: 4)
          ],
          color: player == 1 ? Colors.black54 : Colors.grey[100]),
    );
  }

  Widget buildCurrentPlayerTurn(
    BuildContext context,
    DraughtsGameProvider provider,
  ) {
    if (provider.currentPlayerTurn != null) {
      return Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Current turn".toUpperCase(),
                    style:
                        GoogleFonts.inter(fontSize: 16, color: Colors.white)),
                Padding(
                    padding: const EdgeInsets.all(6),
                    child: buildMenWidget(
                        player: provider.currentPlayerTurn ?? 1,
                        size: 38 * 1.0))
              ]));
    } else {
      return const SizedBox(
        height: 38,
      );
    }
  }
}
