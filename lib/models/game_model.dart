// ignore_for_file: non_constant_identifier_names

class GameModel {
  final int? game_id;
  late final int? players;
  late final int? listeners;
  late final int? noOfPlayers;

  GameModel(
      {required this.game_id,
      required this.players,
      required this.listeners,
      this.noOfPlayers});

  factory GameModel.fromJson(Map<String, dynamic> json) {
    // print(json);
    return GameModel(
      game_id: json['id'],
      players: json['players'],
      listeners: json['listeners'],
      noOfPlayers: json['noOfPlayers'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': game_id,
      'players': players,
      'listeners': listeners,
      'noOfPlayers': noOfPlayers
    };
  }
}
