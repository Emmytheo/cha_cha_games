import 'package:cha_cha_games/constants.dart';
import 'package:cha_cha_games/game_server.dart';
import 'package:cha_cha_games/models/game_model.dart';
import 'package:cha_cha_games/providers/whot_game_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class WhotMenuScreen extends StatefulWidget {
  const WhotMenuScreen({Key? key}) : super(key: key);

  @override
  _WhotMenuScreenState createState() => _WhotMenuScreenState();
}

class _WhotMenuScreenState extends State<WhotMenuScreen> {
  @override
  void initState() {
    super.initState();

    final whotProvider = Provider.of<WhotGameProvider>(context, listen: false);

    // Connect to the WebSocket server here when the menu screen loads
    // whotProvider.connectToServer("ws://localhost:8080");

    // Request the list of available games
    WidgetsBinding.instance.addPostFrameCallback((_) {
      whotProvider.listGames();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Container(
        decoration: chachaBackground(),
        child: Scaffold(
            floatingActionButton:
                Consumer<WhotGameProvider>(builder: (context, provider, child) {
              return FloatingActionButton(
                onPressed: () =>
                    {provider.createNewGameWithDefaults(), provider.listGames()},
                child: const Icon(Icons.add),
              );
            }),
            appBar: AppBar(
              title: Text(
                'Whot Menu',
                style: GoogleFonts.inter(color: Colors.white),
              ),
              bottom: TabBar(
                indicatorColor: Colors.white,
                tabs: [
                  Tab(
                    child: Text(
                      'Now Playing',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          // fontSize: 18,

                          // height: 0.95,
                          color: Colors.white),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Available',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          // fontSize: 18,

                          // height: 0.95,
                          color: Colors.white),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Others',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          // fontSize: 18,

                          // height: 0.95,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
              backgroundColor: chachaAppBarColor(),
              actions: [
                Consumer<WhotGameProvider>(builder: (context, provider, child) {
                  return IconButton(
                    icon: const Icon(
                      Icons.replay_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () => {provider.listGames()},
                  );
                })
              ],
            ),
            body:
                Consumer<WhotGameProvider>(builder: (context, provider, child) {
              var availableGames = provider.gameList!.games
                  .where((e) => e.players! < e.noOfPlayers!)
                  .toList();
              var FilledGames = provider.gameList!.games
                  .where((e) => e.players! >= e.noOfPlayers!)
                  .toList();
              var joined = provider.currentGame != null
                  ? provider.gameList!.games
                      .where((e) => e.game_id == provider.currentGame!.game_id)
                      .toList()
                  : <GameModel>[];
              // var all = provider.gameList!.games.toList();
              return TabBarView(
                children: [
                  WhotGameList(
                    games: joined,
                  ),
                  WhotGameList(
                    games: availableGames,
                  ),
                  WhotGameList(
                    games: FilledGames,
                  )
                ],
              );
            })),
      ),
    );
  }
}

class WhotGameList extends StatelessWidget {
  final List<GameModel>? games;
  

  const WhotGameList({Key? key, this.games}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WhotGameProvider>(builder: (context, provider, child) {
      return Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Expanded(
              child: games!.isNotEmpty
                  ? ListView.builder(
                      itemCount: games!.length,
                      itemBuilder: (context, index) {
                        final game = games![index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
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
                          child: ListTile(
                              // tileColor: const Color(0xffc16c34),
                              title: Text(
                                // 'Game #${game.game_id} - ${provider.servers[index].serverCountry} - (${game.players} / ${game.noOfPlayers}) Players ',
                                '${provider.servers[index].serverCountry} - (${game.players} / ${game.noOfPlayers}) Players ',
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    // fontSize: 18,

                                    // height: 0.95,
                                    color: Colors.white),
                              ),
                              subtitle: Text(
                                // '(${game.players} / ${game.noOfPlayers}) Players - ${game.listeners} Listeners',
                                'Entry Fee: \$${provider.servers[index].entryFee.toInt()} \nPrize: \$${provider.servers[index].price.toInt()}',
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.normal,
                                    // fontSize: 18,

                                    // height: 0.95,
                                    color: Colors.white),
                              ),
                              trailing: provider.currentGame != null &&
                                      provider.currentGame!.game_id ==
                                          game.game_id
                                  ? TextButton(
                                      onPressed: () async {
                                        Navigator.pushNamed(
                                            context, '/whotGame');
                                      },
                                      child: Text(
                                        'Resume Game',
                                        style: GoogleFonts.inter(
                                            fontWeight: FontWeight.bold,
                                            // fontSize: 18,

                                            // height: 0.95,
                                            color: Colors.white),
                                      ),
                                    )
                                  : game.players! >= game.noOfPlayers!
                                      ? TextButton(
                                          onPressed: () async {
                                            // await provider.setCurrentGame(game);
                                            // // await model.setupListeners(game);
                                            // await provider.setupGame(game);
                                            // print(provider.currentGame);
                                            // print(provider.gameStart);
                                            // Navigator.pushNamed(
                                            //     context, '/whotGame');
                                          },
                                          child: Text(
                                            'Game Full',
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.bold,
                                                // fontSize: 18,

                                                // height: 0.95,
                                                color: Colors.white),
                                          ),
                                        )
                                      : TextButton(
                                          onPressed: () async {
                                            await provider.setCurrentGame(game);
                                            // await model.setupListeners(game);
                                            await provider.setupGame(game);
                                            print(provider.currentGame);
                                            print(provider.gameStart);
                                            Navigator.pushNamed(
                                                context, '/whotGame');
                                          },
                                          child: Text(
                                            'Join Game',
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.bold,
                                                // fontSize: 18,

                                                // height: 0.95,
                                                color: Colors.white),
                                          ),
                                        )),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'No Available Games, Use + icon to create one',
                        style: GoogleFonts.inter(color: Colors.white),
                      ),
                    )),
        ],
      );
    });
  }
}
