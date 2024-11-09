// ignore_for_file: non_constant_identifier_names

import 'package:cha_cha_games/models/game_model.dart';

class GamesModel {
  final List<GameModel> games;

  GamesModel({
    required this.games,
  });

  factory GamesModel.fromJson(List<dynamic> json) {
    List<GameModel> games = json.map((gameJson) {
      if (gameJson is Map<String, dynamic>) {
        return GameModel.fromJson(gameJson);
      } else {
        throw Exception('Invalid JSON format');
      }
    }).toList();
    return GamesModel(games: games);
  }

  get isNotEmpty => games.isNotEmpty;

  get isEmpty => games.isEmpty;

  List<Map<String, dynamic>> toJson() {
    return games.map((game) => game.toJson()).toList();
  }

  // Add operator [] to enable index-based access
  GameModel operator [](int index) => games[index];

  // Add length getter to get the number of games
  int get length => games.length;
}
