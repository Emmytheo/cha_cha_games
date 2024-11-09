import 'package:cha_cha_games/models/block_table.dart';
import 'package:cha_cha_games/models/coordinate.dart';
import 'package:cha_cha_games/models/direction.dart';
import 'package:cha_cha_games/models/killing.dart';
import 'package:cha_cha_games/models/men.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

typedef OnWalkableAfterKilling = bool Function(
    Coordinate newCoor, Killed killed);

class DraughtsGameProvider with ChangeNotifier {
  WebSocketChannel? _channel;
  String? gameId;
  bool yourTurn = false;
  List<List<BlockTable>> board = [];
  List<Men> killedMen = [];
  int? currentPlayerTurn;
  bool _isMenInitialized = false;

  bool get isMenInitialized => _isMenInitialized;
  bool isGameStarted = false;
  bool gameJoined = false;

  List<Coordinate> listTempForKingWalkCalculation = <Coordinate>[];
  static const int MODE_WALK_NORMAL = 1; // walk to empty or walk to first kill.
  static const int MODE_WALK_AFTER_KILLING =
      2; // walk after kill to 2 3 4.. enemy.
  static const int MODE_AFTER_KILLING =
      3; // calculation to future that men can walk.
  // List to hold available games
  List<Map<String, dynamic>> _availableGames = [];

  List<Map<String, dynamic>> get availableGames => _availableGames;

  DraughtsGameProvider() {
    _initializeBoard();
  }

  void _initializeBoard() {
    // Initialize an 8x8 board with empty blocks
    board = List.generate(8, (row) {
      return List.generate(8, (col) {
        return BlockTable(
          row: row,
          col: col,
          men: null, // No men initially, pieces will be added by initMen()
          isHighlight: false,
          isHighlightAfterKilling: false,
          killableMore: false,
        );
      });
    });

    // Call initMen to place the pieces
    // initMen();
  }

  void initMen() {
    print('Initializing Men');
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 8; col++) {
        if ((row + col) % 2 != 0) {
          board[row][col].men = Men(
            player: 1,
            isKing: false,
            coordinate: Coordinate(row: row, col: col),
          );
        }
      }
    }

    for (int row = 5; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        if ((row + col) % 2 != 0) {
          board[row][col].men = Men(
            player: 2,
            isKing: false,
            coordinate: Coordinate(row: row, col: col),
          );
        }
      }
    }

    isGameStarted = true;
    _isMenInitialized = true;
    notifyListeners();
  }

  // Clear highlight and reset possible moves
  void clearHighlightWalkable() {
    for (var row in board) {
      for (var block in row) {
        block.isHighlight = false;
        block.isHighlightAfterKilling = false;
        block.killableMore = false;
        block.victim = Killed.none();
      }
    }
    notifyListeners();
  }

  // // Highlight possible walkable moves
  // void highlightWalkable(Coordinate coor, {bool isKing = false}) {
  //   List<Coordinate> possibleMoves = [];

  //   // Non-King pieces move only forward diagonally
  //   if (!isKing) {
  //     if (coor.row > 0 &&
  //         coor.col > 0 &&
  //         board[coor.row - 1][coor.col - 1].men == null) {
  //       possibleMoves.add(Coordinate.of(coor, addRow: -1, addCol: -1));
  //     }
  //     if (coor.row > 0 &&
  //         coor.col < 7 &&
  //         board[coor.row - 1][coor.col + 1].men == null) {
  //       possibleMoves.add(Coordinate.of(coor, addRow: -1, addCol: 1));
  //     }
  //   }

  //   // King pieces can move both forward and backward
  //   if (isKing || coor.row < 7) {
  //     if (coor.row < 7 &&
  //         coor.col > 0 &&
  //         board[coor.row + 1][coor.col - 1].men == null) {
  //       possibleMoves.add(Coordinate.of(coor, addRow: 1, addCol: -1));
  //     }
  //     if (coor.row < 7 &&
  //         coor.col < 7 &&
  //         board[coor.row + 1][coor.col + 1].men == null) {
  //       possibleMoves.add(Coordinate.of(coor, addRow: 1, addCol: 1));
  //     }
  //   }

  //   // Mark the possible moves as highlighted
  //   for (var move in possibleMoves) {
  //     board[move.row][move.col].isHighlight = true;
  //   }

  //   notifyListeners();
  // }

  void checkWalkableKing(Men men, int mode) {
    // King can move in all four diagonal directions
    checkWalkableKingDirection(
        men.coordinate, Direction(rowDelta: 1, colDelta: 1),
        mode: mode);
    checkWalkableKingDirection(
        men.coordinate, Direction(rowDelta: 1, colDelta: -1),
        mode: mode);
    checkWalkableKingDirection(
        men.coordinate, Direction(rowDelta: -1, colDelta: 1),
        mode: mode);
    checkWalkableKingDirection(
        men.coordinate, Direction(rowDelta: -1, colDelta: -1),
        mode: mode);
  }

// Helper function to handle king movement in a specific direction
  void checkWalkableKingDirection(Coordinate start, Direction direction,
      {required int mode}) {
    Coordinate current = start;
    bool canCapture = false;

    while (true) {
      current = Coordinate(
          row: current.row + direction.rowDelta,
          col: current.col + direction.colDelta);

      if (!isBlockAvailable(current)) break;

      if (hasMen(current)) {
        if (hasMenEnemy(current)) {
          // Check for possible capture
          Coordinate nextAfterCapture = Coordinate(
              row: current.row + direction.rowDelta,
              col: current.col + direction.colDelta);

          if (isBlockAvailable(nextAfterCapture) && !hasMen(nextAfterCapture)) {
            setHighlightWalkableAfterKilling(nextAfterCapture);
            canCapture = true;
            break; // King cannot move past the captured piece
          }
        } else {
          break; // King cannot move past friendly pieces
        }
      } else {
        if (mode == MODE_WALK_NORMAL) {
          setHighlightWalkable(current);
        }
      }

      if (canCapture) break;
    }
  }

  // Highlight walkable moves based on the piece (men) and mode
  void highlightWalkable(Men men, {int mode = MODE_WALK_NORMAL}) {
    if (!isBlockAvailable(men.coordinate)) {
      return;
    }

    if (men.player == 2) {
      if (men.isKing) {
        listTempForKingWalkCalculation.clear();
        checkWalkableKing(men, mode);
      } else {
        checkWalkablePlayer2(men, mode: mode);
      }
    } else if (men.player == 1) {
      if (men.isKing) {
        listTempForKingWalkCalculation.clear();
        checkWalkableKing(men, mode);
      } else {
        checkWalkablePlayer1(men, mode: mode);
      }
    }
  }

  // Check walkable moves for player 1
  bool checkWalkablePlayer1(Men men, {int mode = MODE_WALK_NORMAL}) {
    bool movableLeft = checkWalkablePlayer1Left(men.coordinate, mode: mode,
        onKilling: (newCoor, killed) {
      int newMode = MODE_AFTER_KILLING;
      return checkWalkablePlayer1(Men.of(men, newCoor: newCoor), mode: newMode);
    });

    bool movableRight = checkWalkablePlayer1Right(men.coordinate, mode: mode,
        onKilling: (newCoor, killed) {
      int newMode = MODE_AFTER_KILLING;
      return checkWalkablePlayer1(Men.of(men, newCoor: newCoor), mode: newMode);
    });

    print('Movable Right ${movableRight}, Movable Left ${movableLeft}');
    return movableLeft || movableRight;
  }

  // Check walkable moves for player 2
  bool checkWalkablePlayer2(Men men, {int mode = MODE_WALK_NORMAL}) {
    bool movableLeft = checkWalkablePlayer2Left(men.coordinate, mode: mode,
        onKilling: (newCoor, killed) {
      int newMode = MODE_AFTER_KILLING;
      return checkWalkablePlayer2(Men.of(men, newCoor: newCoor), mode: newMode);
    });

    bool movableRight = checkWalkablePlayer2Right(men.coordinate, mode: mode,
        onKilling: (newCoor, killed) {
      int newMode = MODE_AFTER_KILLING;
      return checkWalkablePlayer2(Men.of(men, newCoor: newCoor), mode: newMode);
    });

    return movableLeft || movableRight;
  }

  // Core movement logic for capturing or normal moves
  bool checkWalkable({
    required int mode,
    required Coordinate next,
    required Coordinate nextIfKilling,
    required OnWalkableAfterKilling onKilling,
  }) {
    if (hasMen(next)) {
      if (hasMenEnemy(next)) {
        if (isBlockAvailable(nextIfKilling) && !hasMen(nextIfKilling)) {
          print("x = $mode");
          if (mode == MODE_WALK_NORMAL || mode == MODE_AFTER_KILLING) {
            setHighlightWalkableAfterKilling(nextIfKilling);
          }

          Killed killed = Killed(isKilled: true, men: getBlock(next).men);
          getBlock(nextIfKilling).victim = killed;

          if (onKilling != null) {
            bool isKillable = onKilling(nextIfKilling, killed);
            getBlock(nextIfKilling).killableMore = isKillable;
          }
          notifyListeners();
          return true;
        }
      }
    } else {
      if (mode == MODE_WALK_NORMAL) {
        print('Coordinate col: ${next.col}, row:  ${next.row}');
        setHighlightWalkable(next);
        return true;
      }
    }
    return false;
  }

  // Movement logic for player 1 left diagonal
  bool checkWalkablePlayer1Left(Coordinate coor,
      {required int mode, required OnWalkableAfterKilling onKilling}) {
    return checkWalkable(
        mode: mode,
        next: Coordinate(row: coor.row + 1, col: coor.col - 1),
        nextIfKilling: Coordinate(row: coor.row + 2, col: coor.col - 2),
        onKilling: onKilling);
  }

  // Movement logic for player 1 right diagonal
  bool checkWalkablePlayer1Right(Coordinate coor,
      {required int mode, required OnWalkableAfterKilling onKilling}) {
    return checkWalkable(
        mode: mode,
        next: Coordinate(row: coor.row + 1, col: coor.col + 1),
        nextIfKilling: Coordinate(row: coor.row + 2, col: coor.col + 2),
        onKilling: onKilling);
  }

  // Movement logic for player 2 left diagonal
  bool checkWalkablePlayer2Left(Coordinate coor,
      {required int mode, required OnWalkableAfterKilling onKilling}) {
    return checkWalkable(
        mode: mode,
        next: Coordinate(row: coor.row - 1, col: coor.col - 1),
        nextIfKilling: Coordinate(row: coor.row - 2, col: coor.col - 2),
        onKilling: onKilling);
  }

  // Movement logic for player 2 right diagonal
  bool checkWalkablePlayer2Right(Coordinate coor,
      {required int mode, required OnWalkableAfterKilling onKilling}) {
    return checkWalkable(
        mode: mode,
        next: Coordinate(row: coor.row - 1, col: coor.col + 1),
        nextIfKilling: Coordinate(row: coor.row - 2, col: coor.col + 2),
        onKilling: onKilling);
  }

  // Highlight a block for normal moves
  void setHighlightWalkable(Coordinate coor) {
    if (isBlockAvailable(coor) && !hasMen(coor)) {
      getBlock(coor).isHighlight = true;
    }
    notifyListeners();
  }

  // Highlight a block for moves after a capture
  void setHighlightWalkableAfterKilling(Coordinate coor) {
    if (isBlockAvailable(coor) && !hasMen(coor)) {
      getBlock(coor).isHighlightAfterKilling = true;
    }
    notifyListeners();
  }

  // Check if a block is available (within bounds)
  bool isBlockAvailable(Coordinate coor) {
    return coor.row >= 0 && coor.row < 8 && coor.col >= 0 && coor.col < 8;
  }

  // Check if a block contains a piece (men)
  bool hasMen(Coordinate coor) {
    if (isBlockAvailable(coor)) {
      return getBlock(coor).men != null;
    }
    return false;
  }

  // Check if a block contains an opponent's piece
  bool hasMenEnemy(Coordinate coor) {
    if (hasMen(coor)) {
      return getBlock(coor).men!.player != currentPlayerTurn;
    }
    return false;
  }

  // Retrieve block from board
  BlockTable getBlock(Coordinate coor) {
    return board[coor.row][coor.col];
  }

  bool isBlockTypeF(Coordinate coor, String blockType) {
    BlockTable block = getBlock(coor);

    if (blockType == 'empty') {
      return block.men == null;
    } else if (blockType == 'your_piece') {
      return block.men != null && block.men!.player == currentPlayerTurn;
    } else if (blockType == 'opponent_piece') {
      return block.men != null && block.men!.player != currentPlayerTurn;
    }

    return false;
  }

  // BlockTable getBlock(Coordinate coor) {
  //   if (coor.row < 0 || coor.row >= 8 || coor.col < 0 || coor.col >= 8) {
  //     throw Exception("Invalid coordinates");
  //   }

  //   return board[coor.row][coor.col];
  // }

  // void makeMove(Coordinate from, Coordinate to) {
  //   BlockTable fromBlock = getBlock(from);
  //   BlockTable toBlock = getBlock(to);

  //   if (fromBlock.men == null || fromBlock.men!.player != currentPlayerTurn) {
  //     print("Invalid move. It's not your piece.");
  //     return;
  //   }

  //   // if ((from.row - to.row).abs() != 1 || (from.col - to.col).abs() != 1) {
  //   //   print("Invalid move. Only one diagonal step allowed.");
  //   //   return;
  //   // }

  //   if (toBlock.men != null) {
  //     print("Invalid move. Target block is occupied.");
  //     return;
  //   }

  //   // Handle killing
  //   int midRow = (from.row + to.row) ~/ 2;
  //   int midCol = (from.col + to.col) ~/ 2;
  //   BlockTable middleBlock = getBlock(Coordinate(row: midRow, col: midCol));

  //   if ((from.row - to.row).abs() == 2 &&
  //       middleBlock.men != null &&
  //       middleBlock.men!.player != currentPlayerTurn) {
  //     killedMen.add(middleBlock.men!);
  //     middleBlock.men = null;
  //   }

  //   toBlock.men = fromBlock.men;
  //   toBlock.men!.coordinate = to;
  //   fromBlock.men = null;

  //   if (toBlock.men!.player == 1 && to.row == 7) {
  //     toBlock.men!.isKing = true;
  //   } else if (toBlock.men!.player == 2 && to.row == 0) {
  //     toBlock.men!.isKing = true;
  //   }

  //   _sendGameStateToServer();
  //   endTurn();
  // }

  void makeMove(Coordinate from, Coordinate to) {
    BlockTable fromBlock = getBlock(from);
    BlockTable toBlock = getBlock(to);
    bool validKill = false;

    if (fromBlock.men == null || fromBlock.men!.player != currentPlayerTurn) {
      print("Invalid move. It's not your piece.");
      return;
    }

    if (toBlock.men != null) {
      print("Invalid move. Target block is occupied.");
      return;
    }

    // Handle killing
    int rowDifference = (from.row - to.row).abs();
    int colDifference = (from.col - to.col).abs();
    if (rowDifference == 2 && colDifference == 2) {
      // Only allow kill moves if there's an enemy piece between the from and to
      int midRow = (from.row + to.row) ~/ 2;
      int midCol = (from.col + to.col) ~/ 2;
      BlockTable middleBlock = getBlock(Coordinate(row: midRow, col: midCol));

      if (middleBlock.men != null &&
          middleBlock.men!.player != currentPlayerTurn) {
        // Kill the enemy piece
        killedMen.add(middleBlock.men!);
        middleBlock.men = null;
        validKill = true;
      } else {
        print("Invalid move. No enemy piece to capture.");
        return;
      }
    } else if (fromBlock.men!.isKing == false && (rowDifference > 2 || colDifference > 2)) {
      print("Invalid move. Only one diagonal step allowed, or a valid jump.");
      return;
    }

    // Move the piece
    toBlock.men = fromBlock.men;
    toBlock.men!.coordinate = to;
    fromBlock.men = null;

    // Promote to king if it reaches the opposite end of the board
    if (toBlock.men!.player == 1 && to.row == 7) {
      toBlock.men!.isKing = true;
      print("Player 1 piece promoted to King!");
    } else if (toBlock.men!.player == 2 && to.row == 0) {
      toBlock.men!.isKing = true;
      print("Player 2 piece promoted to King!");
    }

    // Check for consecutive kill possibility
    if (validKill == true && _canKillAgain(toBlock.men!, to)) {
      print("Consecutive kill available. You must make another move.");
      return; // Don't end the turn, wait for another move
    }

    // Send game state to the server and end the turn if no consecutive kills
    _sendGameStateToServer();
    endTurn();
  }

  bool _canKillAgain(Men men, Coordinate from) {
    List<Coordinate> possibleMoves = _getPossibleKillMoves(men, from);

    for (Coordinate to in possibleMoves) {
      int midRow = (from.row + to.row) ~/ 2;
      int midCol = (from.col + to.col) ~/ 2;
      BlockTable toBlock = getBlock(Coordinate(row: to.row, col: to.col));
      BlockTable middleBlock = getBlock(Coordinate(row: midRow, col: midCol));
      print(
          'New Move = row:${to.row}, column: ${to.col}, Valid move: ${toBlock.men == null}');
      if (toBlock.men == null) {
        if (middleBlock.men != null &&
            middleBlock.men!.player != currentPlayerTurn) {
          return true; // Another kill is possible
        }
      } 
    }
    return false;
  }

  List<Coordinate> _getPossibleKillMoves(Men men, Coordinate from) {
    List<Coordinate> killMoves = [];

    // Get directions based on whether the piece is a king or a regular piece
    List<List<int>> directions = men.isKing
        ? [
            [1, 1],
            [1, -1],
            [-1, 1],
            [-1, -1]
          ] // Kings can move in all diagonal directions
        : men.player == 1
            ? [
                [1, 1],
                [1, -1]
              ] // Player 1 moves "down"
            : [
                [-1, 1],
                [-1, -1]
              ]; // Player 2 moves "up"

    for (List<int> direction in directions) {
      int newRow =
          from.row + 2 * direction[0]; // Check 2 steps ahead for a jump
      int newCol = from.col + 2 * direction[1];

      if (isWithinBounds(newRow, newCol)) {
        killMoves.add(Coordinate(row: newRow, col: newCol));
      }
    }

    return killMoves;
  }

  bool isWithinBounds(int row, int col) {
    return row >= 0 && row < 8 && col >= 0 && col < 8;
  }

  void endTurn() {
    currentPlayerTurn = (currentPlayerTurn == 1) ? 2 : 1;
    yourTurn = !yourTurn;
    notifyListeners();
    _sendGameStateToServer();
  }

  void _sendGameStateToServer() {
    String gameStateJson = _generateGameStateJson();
    Map<String, dynamic> message = {
      'type': 'move',
      'gameState': gameStateJson,
    };
    sendMessage(message);
  }

  String _generateGameStateJson() {
    List<List<Map<String, dynamic>>> boardJson = board.map((row) {
      return row.map((block) {
        return {
          'row': block.row,
          'col': block.col,
          'men': block.men != null
              ? {
                  'player': block.men!.player,
                  'isKing': block.men!.isKing,
                  'coordinate': {
                    'row': block.men!.coordinate.row,
                    'col': block.men!.coordinate.col,
                  },
                }
              : null
        };
      }).toList();
    }).toList();

    return jsonEncode({
      'board': boardJson,
      'killedMen': killedMen.map((men) {
        return {
          'player': men.player,
          'isKing': men.isKing,
          'coordinate': {
            'row': men.coordinate.row,
            'col': men.coordinate.col,
          },
        };
      }).toList(),
      'currentPlayerTurn': currentPlayerTurn,
    });
  }

  // Connect to the WebSocket server
  void connectToServer(String serverUrl) {
    _channel = WebSocketChannel.connect(Uri.parse(serverUrl));

    _channel!.stream.listen((message) {
      handleServerMessages(message);
    });
  }

  // Send messages to the WebSocket server
  void sendMessage(Map<String, dynamic> data) {
    if (_channel != null) {
      _channel!.sink.add(jsonEncode(data));
    }
  }

  // Handle server messages
  void handleServerMessages(String message) {
    final data = jsonDecode(message);

    switch (data['type']) {
      case 'gameCreated':
        gameId = data['gameId'];
        notifyListeners();
        break;
      case 'gameJoined':
        gameJoined = true;
        currentPlayerTurn = data['playerNumber'];
        notifyListeners();
        break;
      case 'start':
        isGameStarted = true;
        yourTurn = data['yourTurn'];
        print('Game Created');
        notifyListeners();
        break;
      case 'availableGames':
        // Update available games when the listGames response is received
        _availableGames = List<Map<String, dynamic>>.from(data['games']);
        notifyListeners();
        break;
      case 'opponentMove':
        // print(data['gameState']);
        applyMove(data['gameState']);
        yourTurn = true;
        notifyListeners();
        break;
      case 'opponentLeft':
        notifyListeners();
        break;
    }
  }

  // Create a new game
  void createGame() {
    sendMessage({
      "type": "createGame",
      "gameType": "draughts",
    });
  }

  // Join an existing game
  void joinGame(String gameId) {
    print(gameJoined);
    sendMessage({
      "type": "joinGame",
      "gameId": gameId,
    });
  }

  // Request available games from the server
  void listAvailableGames() {
    sendMessage({
      "type": "listGames",
    });
  }

  /// Applies the opponent's move using the JSON representation of the board
  void applyMove(String gameStateJson) {
    Map<String, dynamic> gameState = jsonDecode(gameStateJson);

    // Update the board
    for (var row in gameState['board']) {
      for (var block in row) {
        int rowIndex = block['row'];
        int colIndex = block['col'];

        BlockTable currentBlock = board[rowIndex][colIndex];
        if (block['men'] != null) {
          currentBlock.men = Men(
            player: block['men']['player'],
            isKing: block['men']['isKing'],
            coordinate: Coordinate(
              row: block['men']['coordinate']['row'],
              col: block['men']['coordinate']['col'],
            ),
          );
        } else {
          currentBlock.men = null;
        }
      }
    }

    // Update the killed men
    killedMen = (gameState['killedMen'] as List).map((menData) {
      return Men(
        player: menData['player'],
        isKing: menData['isKing'],
        coordinate: Coordinate(
          row: menData['coordinate']['row'],
          col: menData['coordinate']['col'],
        ),
      );
    }).toList();

    // Update the current player's turn
    currentPlayerTurn = gameState['currentPlayerTurn'];

    // Notify UI to rebuild
    notifyListeners();
  }
}
