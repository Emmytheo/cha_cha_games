import 'package:cha_cha_games/models/deck_model.dart';
import 'package:cha_cha_games/models/draw_model.dart';
import 'package:cha_cha_games/models/game_model.dart';
import 'package:cha_cha_games/models/games_model.dart';
import 'package:cha_cha_games/services/api_service.dart';
import 'package:cha_cha_games/services/whot_api_service.dart';

class WhotGameService extends WhotApiService {
  Future<GameModel> newGame({int playerCount = 2}) async {
    final data = await httpPost(
      '/games',
      // params: {'deck_count': deckCount},
      body: {
        'noOfPlayers': playerCount,
      },
    );

    // print(data);
    return GameModel.fromJson(data);
  }

  Future<GamesModel> listGames() async {
    final data = await httpGetList(
      '/games',
      // params: {'deck_count': deckCount},
    );

    return GamesModel.fromJson(data);
  }

  Future<DrawModel> drawCards(DeckModel deck, {int count = 1}) async {
    final data = await httpGet(
      '/deck/${deck.deck_id}/draw',
      params: {'count': count},
    );

    return DrawModel.fromJson(data);
  }
}
