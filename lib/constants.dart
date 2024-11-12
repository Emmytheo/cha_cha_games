import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

const CARD_WIDTH = 226 / 2;
const CARD_HEIGHT = 314 / 2;

const GS_LAST_SUIT = 'GS_LAST_SUIT';
const GS_LAST_VALUE = 'GS_LAST_VALUE';

Color chachaAppBarColor() => const Color.fromRGBO(116, 3, 106, 1);

Color chachaBottomAppBarColor() => const Color.fromRGBO(48, 0, 44, 1);

Color chachaLightColor() => const Color.fromRGBO(246, 198, 237, 1);

Color chachaDarkColor() => const Color.fromRGBO(45, 0, 42, 0.52);

Color chachaVeryLightColor() => const Color.fromRGBO(246, 198, 237, 0.32);


String server_url = "s://whot-server-5pyq.onrender.com";


const List<dynamic> Games = [
  {
    'name': "whot",
    'type': 'Multiplayer',
    'route': '/whotMenu',
    'image': 'assets/images/whot.png'
  },
  {
    'name': "Draught",
    'type': 'Multiplayer',
    'route': '/draughtsMenu',
    'image': 'assets/images/draught.png'
  },
  {
    'name': "Ludo",
    'type': 'Multiplayer',
    'route': '/',
    'image': 'assets/images/ludo.png'
  },
  {
    'name': "Snooker",
    'type': 'Multiplayer',
    'route': '/',
    'image': 'assets/images/snooker.png'
  },
];

const List<dynamic> Winnings = [
  {
    'name': "Weekly Jackpot",
    'desc': 'won this week',
    'total': '300k',
    'route': '/',
    'image': 'assets/images/jackport.png'
  },
  {
    'name': "Lucky Spin",
    'desc': 'won this week',
    'total': '550k',
    'route': '/',
    'image': 'assets/images/LuckySpin.png'
  },
];

BoxDecoration chachaBackground() {
  return const BoxDecoration(
    gradient: LinearGradient(
      colors: [Color.fromRGBO(116, 3, 106, 1), Color.fromRGBO(48, 0, 44, 1)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );
}
