import 'dart:collection';
import 'dart:convert';

import 'package:cha_cha_games/models/player_model.dart';
import 'package:cha_cha_games/models/whot_card_model.dart';
import 'package:cha_cha_games/models/whot_player_model.dart';
import 'package:flutter/material.dart';

class WhotTurn {
  final List<WhotPlayerModel>? players;
  WhotPlayerModel? currentPlayer;
  List<WhotCardModel>? discardz;
  Queue<WhotCardModel> _lastTwoCards = Queue<WhotCardModel>();
  Queue<int> _lastTwoCardsIndices = Queue<int>();
  bool? draggable;

  WhotTurn(
      {required this.players,
      required this.currentPlayer,
      this.discardz,
      this.draggable = false});

  void playCard(int index) {
    WhotCardModel card = currentPlayer!.cards[index];

    if (card.shape == 'Whot' && card.value == 20) {
      // Update the last two cards buffer
      if (_lastTwoCards.length == 2) {
        _lastTwoCards.removeFirst();
        _lastTwoCardsIndices.removeFirst();
      }
      _lastTwoCards.addLast(card);
      _lastTwoCardsIndices.addLast(index);
      print("${currentPlayer!.name}: What do you need?");
    } else {
      if (_lastTwoCards.isNotEmpty &&
          _lastTwoCards.first.shape == 'Whot' &&
          _lastTwoCards.first.value == 20) {
        // Play the previously stored "Whot" card
        int whotCardIndex = _lastTwoCardsIndices.first;
        _lastTwoCards.clear();
        _lastTwoCardsIndices.clear();
        // Send a message to the current player's channel to play the "Whot" card
        currentPlayer!.channel.sink.add(json.encode({
          'message': 'player:play',
          'index': whotCardIndex,
          'iNeed': card.shape
        }).codeUnits);
        // Now play the current card as well
        currentPlayer!.channel.sink.add(json.encode({
          'message': 'player:play',
          'index': index,
          'iNeed': null
        }).codeUnits);
        print(
            "${currentPlayer!.name} needs a ${currentPlayer!.cards[index].shape}");
        currentPlayer = null;
      } else {
        _lastTwoCards.clear();
        _lastTwoCardsIndices.clear();
        print(
            "${currentPlayer!.name} played ${currentPlayer!.cards[index].shape} ${currentPlayer!.cards[index].value}");
        discardz = [currentPlayer!.cards[index]];
        // Send a message to the current player's channel to play the current card
        currentPlayer!.channel.sink.add(json.encode({
          'message': 'player:play',
          'index': index,
          'iNeed': null
        }).codeUnits);
        currentPlayer = null;
      }
    }
  }

  void drawCard() {
    // Send a message to the current player's channel to draw a card
    currentPlayer!.channel.sink
        .add(json.encode({'message': 'market:pick'}).codeUnits);
    currentPlayer = null;
  }

  WhotPlayerModel? get otherPlayer {
    return players!.firstWhere((p) => p != currentPlayer);
  }
}
