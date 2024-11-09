class DraughtsGameModel {
  final int gameId;
  final List<Player> players;
  final String status; // e.g. "waiting", "in_progress", "finished"
  final List<List<String>> board; // 2D array representing the game board
  late final String currentPlayer; // Player's ID or name whose turn it is
  String loggedInPlayerId; // The actual player on the device
  

  DraughtsGameModel({
    required this.gameId,
    required this.players,
    required this.status,
    required this.board,
    required this.currentPlayer,
    required this.loggedInPlayerId,
  });

  /// Factory constructor to create a DraughtsGameModel from a JSON object
  factory DraughtsGameModel.fromJson(Map<String, dynamic> json) {
    return DraughtsGameModel(
      gameId: json['game_id'],
      players: (json['players'] as List)
          .map((playerJson) => Player.fromJson(playerJson))
          .toList(),
      status: json['status'],
      board: (json['board'] as List)
          .map((row) => (row as List).map((cell) => cell.toString()).toList())
          .toList(),
      currentPlayer: json['current_player'], loggedInPlayerId: json['loggedInPlayerId'],
    );
  }

  /// Convert the game model to JSON format for sending to the server or storage
  Map<String, dynamic> toJson() {
    return {
      'game_id': gameId,
      'players': players.map((player) => player.toJson()).toList(),
      'status': status,
      'board': board,
      'current_player': currentPlayer,
      'loggedInPlayerId': loggedInPlayerId
    };
  }
}

class Player {
  final String id;
  final String name;
  final bool isHuman;
  final String color; // Example: "black" or "white"

  Player({
    required this.id,
    required this.name,
    required this.isHuman,
    required this.color,
  });

  /// Factory constructor to create a Player from JSON
  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name'],
      isHuman: json['is_human'],
      color: json['color'],
    );
  }

  /// Convert the Player model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_human': isHuman,
      'color': color,
    };
  }
}
