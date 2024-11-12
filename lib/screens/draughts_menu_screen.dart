import 'package:cha_cha_games/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cha_cha_games/providers/draughts_game_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class DraughtsMenuScreen extends StatefulWidget {
  const DraughtsMenuScreen({Key? key}) : super(key: key);

  @override
  _DraughtsMenuScreenState createState() => _DraughtsMenuScreenState();
}

class _DraughtsMenuScreenState extends State<DraughtsMenuScreen> {
  @override
  void initState() {
    super.initState();

    final draughtsProvider =
        Provider.of<DraughtsGameProvider>(context, listen: false);

    // Connect to the WebSocket server here when the menu screen loads
    draughtsProvider.connectToServer("ws${server_url}/draughts/");

    

    // Request the list of available games
    WidgetsBinding.instance.addPostFrameCallback((_) {
      draughtsProvider.listAvailableGames();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        decoration: chachaBackground(),
        child: Scaffold(
            floatingActionButton: Consumer<DraughtsGameProvider>(
                builder: (context, provider, child) {
              return FloatingActionButton(
                onPressed: () =>
                    {provider.createGame(), provider.listAvailableGames()},
                child: const Icon(Icons.add),
              );
            }),
            appBar: AppBar(
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
                ],
              ),
              title: Text(
                'Draughts Menu',
                style: GoogleFonts.inter(color: Colors.white),
              ),
              backgroundColor: chachaAppBarColor(),
              actions: [
                Consumer<DraughtsGameProvider>(
                    builder: (context, provider, child) {
                  return IconButton(
                    icon: const Icon(
                      Icons.replay_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () => {provider.listAvailableGames()},
                  );
                })
              ],
            ),
            body: Consumer<DraughtsGameProvider>(
                builder: (context, provider, child) {
              var availableGames = provider.availableGames.toList();
              var nowPlaying = provider.availableGames
                  .where((e) => e['gameId']! == provider.gameId)
                  .toList();
              // var all = provider.gameList!.games.toList();
              return TabBarView(
                children: [
                  DraughtsGameList(
                    games: nowPlaying,
                  ),
                  DraughtsGameList(
                    games: availableGames,
                  ),
                ],
              );
            })),
      ),
    );
  }
}

class DraughtsGameList extends StatelessWidget {
  final List<dynamic>? games;
  const DraughtsGameList({Key? key, this.games}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DraughtsGameProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            // SizedBox(
            //   height: 10,
            // ),
            // ElevatedButton(
            //   onPressed: () =>
            //       {provider.createGame(), provider.listAvailableGames()},
            //   child: const Text('Create New Game'),
            // ),
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
                              title: Text(
                                'Game ID: ${game['gameId'].toString().split('-')[0]}',
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    // fontSize: 18,

                                    // height: 0.95,
                                    color: Colors.white),
                              ),
                              subtitle: Text(
                                'Game Type: ${game['gameType']}',
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.normal,
                                    // fontSize: 18,

                                    // height: 0.95,
                                    color: Colors.white),
                              ),
                              trailing: provider.gameId == game['gameId']
                                  ? TextButton(
                                      onPressed: () async {
                                        Navigator.pushNamed(
                                            context, '/draughtsGame');
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
                                  : TextButton(
                                      onPressed: () async {
                                        provider.joinGame(game['gameId']);
                                        Navigator.pushNamed(
                                            context, '/draughtsGame');
                                      },
                                      child: Text(
                                        'Join Game',
                                        style: GoogleFonts.inter(
                                            fontWeight: FontWeight.bold,
                                            // fontSize: 18,

                                            // height: 0.95,
                                            color: Colors.white),
                                      ),
                                    ),
                              // onTap: () {
                              //   if(provider.gameId != game['gameId']){
                              //     provider.joinGame(game['gameId']);
                              //   }
                              //   Navigator.pushNamed(context, '/draughtsGame');
                              // },
                            ),
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
      },
    );
  }
}
