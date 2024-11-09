import 'dart:convert';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:cha_cha_games/components/create_whot_game_modal.dart';
import 'package:cha_cha_games/components/suit_chooser_modal.dart';
import 'package:cha_cha_games/constants.dart';
import 'package:cha_cha_games/main.dart';
import 'package:cha_cha_games/models/card_model.dart';
import 'package:cha_cha_games/models/deck_model.dart';
import 'package:cha_cha_games/models/game_model.dart';
import 'package:cha_cha_games/models/games_model.dart';
import 'package:cha_cha_games/models/player_model.dart';
import 'package:cha_cha_games/models/turn_model.dart';
import 'package:cha_cha_games/models/whot_card_model.dart';
import 'package:cha_cha_games/models/whot_player_model.dart';
import 'package:cha_cha_games/models/whot_turn_model.dart';
import 'package:cha_cha_games/providers/game_provider.dart';
import 'package:cha_cha_games/services/whot_game_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WhotGameProvider extends GameProvider {
  final WhotGameService _service = WhotGameService();
  late WebSocketChannel _channel;

  final String junk = "Booyahhhh";

  GamesModel? gameList = GamesModel.fromJson([]);

  GameModel? currentGame;

  WhotPlayerModel? primaryPlayer;

  DeckModel? _currentDeck;
  DeckModel? get currentDeck => _currentDeck;

  List<WhotPlayerModel>? playerz = [];
  // @override
  // List<WhotPlayerModel>? get playerz => _playerz;

  late final WhotTurn whot_turn =
      WhotTurn(players: playerz, currentPlayer: null);
  // @override
  // WhotTurn get whot_turn => _whot_turn;

  List<WhotCardModel>? _discardz = [];
  @override
  List<WhotCardModel>? get discardz => _discardz;
  @override
  WhotCardModel? get discardTopp => _discardz!.isEmpty ? null : _discardz?.last;

  bool gameStart = false;

  // Function to create a player and set up its channel listener
  Future<void> createPlayer(
      String name, bool isHuman, WebSocketChannel channel) async {
    WhotPlayerModel player = WhotPlayerModel(
      name: name,
      isHuman: isHuman,
      channel: channel,
      id: null,
    );
    playerz!.add(player);
    int idx = playerz!.indexWhere((p) => p.name == name);
    playerz![idx].channel.stream.listen((message) async {
      Map<String, dynamic> _message =
          Map<String, dynamic>.from(jsonDecode(message) as Map);
      WhotPlayerModel player = playerz![idx];
      primaryPlayer = playerz![idx];
      switch (_message['message']) {
        case 'game:create':
          print('Creating ${name}');
          player.id = _message['playerId'];
          final games = await _service.listGames();
          gameList = games;
          if (currentGame!.game_id == _message['id']) {
            currentGame!.players = _message['players'];
            currentGame!.listeners = _message['listeners'];
          }
          var oPlyrIds = [];
          for (int i = 1; i <= currentGame!.noOfPlayers!; i++) {
            if (i != player.id) {
              oPlyrIds.add(i);
            }
          }
          for (int i = 0; i < currentGame!.noOfPlayers!; i++) {
            if (i != idx) {
              var otherPlyer = WhotPlayerModel(
                  name: 'player $i',
                  isHuman: false,
                  channel: channel,
                  id: oPlyrIds[i - 1],
                  cards: []);
              playerz!.add(otherPlyer);
            }
          }
          print('Initial playerz ${playerz!.length}');
          // game.players = [player];
          break;

        case 'game:start':
          print("Game Started");
          print(_message);
          gameStart = true;
          WhotCardModel discardd = WhotCardModel.fromJson(_message['pile']);
          whot_turn.discardz = [discardd];
          print(playerz!.length);
          break;

        case 'player:hand':
          player.cards = List<WhotCardModel>.from(_message['hand']
              .map((cardJson) => WhotCardModel.fromJson(cardJson)));
          break;

        case 'turn:switch':
          whot_turn.currentPlayer = player;
          break;

        case 'pile:top':
          // Handle pile:top message if needed
          print('Pile Top');
          print(_message);
          WhotCardModel discardd = WhotCardModel.fromJson(_message['card']);
          whot_turn.discardz = [discardd];
          break;

        case 'player:play':
          // Handle pile:top message if needed
          print('Player ${_message['id']} Played');
          print(_message);
          int idx = playerz!.indexWhere((p) => p.id == _message['id']);
          for (int i = 0; i < playerz!.length; i++) {
            if (idx == i) {
              playerz![idx].lastPlayed = true;
            } else {
              playerz![idx].lastPlayed = false;
            }
          }
          WhotCardModel discardd = WhotCardModel.fromJson(_message['card']);
          whot_turn.discardz = [discardd];
          break;

        case 'current:player':
          var activePlayerId = _message['playerId'];
          if (playerz!.length > 1) {
            for (int i = 0; i < currentGame!.noOfPlayers!; i++) {
              if (activePlayerId != playerz![i].id) {
                playerz![i].nowPlaying = false;
              } else {
                playerz![i].nowPlaying = true;
              }
            }
          }

          break;

        default:
          // Handle any other messages if needed
          print("Other Message");
          print(_message);
      }

      notifyListeners();
    });
  }

  // Function to create a player and set up its channel listener
  Future<void> createBot(
      String name, bool isHuman, WebSocketChannel channel) async {
    WhotPlayerModel player = WhotPlayerModel(
      name: name,
      isHuman: isHuman,
      channel: channel,
      id: null,
    );
    playerz!.add(player);
    int idx = playerz!.indexWhere((p) => p.name == name);
    playerz![idx].channel.stream.listen((message) async {
      Map<String, dynamic> _message =
          Map<String, dynamic>.from(jsonDecode(message) as Map);
      WhotPlayerModel player = playerz![idx];
      switch (_message['message']) {
        case 'game:create':
          print('Creating ${name}');
          player.id = _message['playerId'];
          final games = await _service.listGames();
          gameList = games;
          if (currentGame!.game_id == _message['id']) {
            currentGame!.players = _message['players'];
            currentGame!.listeners = _message['listeners'];
          }
          // game.players = [player];
          break;

        case 'game:start':
          // gameStart = true;
          WhotCardModel discardd = WhotCardModel.fromJson(_message['pile']);
          whot_turn.discardz = [discardd];
          break;

        case 'player:hand':
          player.cards = List<WhotCardModel>.from(_message['hand']
              .map((cardJson) => WhotCardModel.fromJson(cardJson)));
          break;

        case 'turn:switch':
          whot_turn.currentPlayer = player;
          break;

        case 'pile:top':
          // Handle pile:top message if needed
          WhotCardModel discardd = WhotCardModel.fromJson(_message['card']);
          whot_turn.discardz = [discardd];
          break;

        default:
        // Handle any other messages if needed
      }

      notifyListeners();
    });
  }

  Future<void> setupGame(GameModel game) async {
    // Set up the main player (human)
    WebSocketChannel mainChannel = WebSocketChannel.connect(
        Uri.parse('ws://${server_url}:8800/game/${game.game_id}'));
    await mainChannel.ready;
    await createPlayer('You', true, mainChannel);
  }

  Future<void> setupGameWithBots(GameModel game, {int? maxPlayers = 4}) async {
    // Create bot players
    for (int i = 1; i < maxPlayers!; i++) {
      WebSocketChannel botChannel = WebSocketChannel.connect(
          Uri.parse('ws://${server_url}:8800/game/${game.game_id}'));
      await botChannel.ready;
      await createBot('Bot $i', false, botChannel);
    }
  }

  Future<void> listGames() async {
    final games = await _service.listGames();
    // print(games.toJson());
    gameList = games;
    notifyListeners();
  }

  Future<void> setCurrentGame(GameModel game) async {
    currentGame = game;
    notifyListeners();
  }

  Future<GameModel> newWhotGame(int maxPlayers) async {
    final new_game = await _service.newGame(playerCount: maxPlayers);
    // notifyListeners();
    return new_game;
  }

  @override
  Future<void> setupBoard() async {
    for (var p in players) {
      await drawCards(p, count: 8, allowAnyTime: true);
    }

    await drawCardToDiscardPile();

    setLastPlayed(discardTop!);

    turn.drawCount = 0;
    turn.actionCount = 0;
  }

  @override
  bool get canEndTurn {
    if (turn.drawCount > 0 || turn.actionCount > 0) {
      return true;
    }

    return false;
  }

  @override
  bool canPlayCard(CardModel card) {
    bool canPlay = false;

    if (gameState[GS_LAST_SUIT] == null || gameState[GS_LAST_VALUE] == null) {
      return false;
    }

    if (gameState[GS_LAST_SUIT] == card.suit) {
      canPlay = true;
    }

    if (gameState[GS_LAST_VALUE] == card.value) {
      canPlay = true;
    }

    if (card.value == "8") {
      canPlay = true;
    }

    return canPlay;
  }

  @override
  Future<void> applyCardSideEffects(CardModel card) async {
    if (card.value == "8") {
      Suit suit;

      if (turn.currentPlayer.isHuman) {
        suit = await showDialog(
          context: navigatorKey.currentContext!,
          builder: (_) => const SuitChooserModal(),
          barrierDismissible: false,
        );
      } else {
        suit = turn.currentPlayer.cards.first.suit;
      }

      gameState[GS_LAST_SUIT] = suit;
      setTrump(suit);
      showToast(
          "${turn.currentPlayer.name} has changed it to ${CardModel.suitToString(suit)}");
    } else if (card.value == "2") {
      await drawCards(turn.otherPlayer, count: 2, allowAnyTime: true);
      showToast("${turn.otherPlayer.name} has to draw 2 cards!");
    } else if (card.value == "QUEEN" && card.suit == Suit.Spades) {
      await drawCards(turn.otherPlayer, count: 5, allowAnyTime: true);
      showToast("${turn.otherPlayer.name} has to draw 5 cards!");
    } else if (card.value == "JACK") {
      showToast("${turn.otherPlayer.name} misses a turn!");
      skipTurn();
    }

    notifyListeners();
  }

  @override
  bool get gameIsOver {
    if (turn.currentPlayer.cards.isEmpty) {
      return true;
    }

    return false;
  }

  @override
  void finishGame() {
    showToast("Game over! ${turn.currentPlayer.name} WINS!");
    notifyListeners();
  }

  Future<void> createNewGame() async {
    // showToast("Create new game!");
    await showDialog(
      context: navigatorKey.currentContext!,
      builder: (_) => const CreateWhotGameModal(),
      barrierDismissible: true,
    );
    notifyListeners();
  }

  @override
  Future<void> botTurn() async {
    final p = turn.currentPlayer;

    await Future.delayed(const Duration(milliseconds: 500));

    for (final c in p.cards) {
      if (canPlayCard(c)) {
        await playCard(player: p, card: c);
        endTurn();
        return;
      }
    }

    await Future.delayed(const Duration(milliseconds: 500));
    await drawCards(p);
    await Future.delayed(const Duration(milliseconds: 500));

    if (canPlayCard(p.cards.last)) {
      await playCard(player: p, card: p.cards.last);
    }

    endTurn();
  }

  List<dynamic> get moreButtons {
    return [
      AnimatedToggleSwitch<bool>.dual(
        current: whot_turn.draggable!,
        first: false,
        second: true,
        spacing: 10.0,
        indicatorSize: const Size.fromWidth(40.0),
        // Size.zero,
        style: const ToggleStyle(
          borderColor: Color.fromARGB(0, 211, 179, 179),
          backgroundColor: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        // borderWidth: 10.0,
        height: 30,
        loadingIconBuilder: (context, global) =>
            const CupertinoActivityIndicator(color: Colors.white),
        // onChanged: (b) {
        //   setState(() =>
        //       model.whot_turn.draggable = b);
        //   return Future<dynamic>.delayed(
        //       const Duration(seconds: 1));
        // },
        styleBuilder: (b) =>
            ToggleStyle(indicatorColor: b ? Colors.green : Colors.grey),
        iconBuilder: (value) => value
            ? const Icon(
                Icons.swipe_left,
              )
            : const Icon(
                Icons.do_not_touch,
              ),
        textBuilder: (value) => value
            ? const Center(
                child: Text(
                'On',
                // style: const TextStyle(
                //     fontSize: 12.0)
              ))
            : const Center(
                child: Text(
                'Off',
                // style: const TextStyle(
                //     fontSize: 12.0)
              )),
        // textBuilder: (value) => {return null}
      )
    ];
  }

  @override
  // TODO: implement additionalButtons
  List<ActionButton> get additionalButtons {
    return [
      ActionButton(
        label: "Pick from Market",
        onPressed: () {
          whot_turn.drawCard();
        },
      ),
      // ActionButton(
      //   label: "Drag",
      //   onPressed: () {
      //     whot_turn.drawCard();
      //   },
      // ),
    ];
  }
}
