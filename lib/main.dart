import 'package:cha_cha_games/constants.dart';
import 'package:cha_cha_games/providers/crazy_eights_game_provider.dart';
import 'package:cha_cha_games/providers/thirty_one_game_provider.dart';
import 'package:cha_cha_games/providers/whot_game_provider.dart';
import 'package:cha_cha_games/providers/draughts_game_provider.dart';
import 'package:cha_cha_games/screens/whot_game_screen.dart';
import 'package:cha_cha_games/screens/whot_menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

// Screens
import 'package:cha_cha_games/screens/game_list_screen.dart';
import 'package:cha_cha_games/screens/draughts_menu_screen.dart';
import 'package:cha_cha_games/screens/draughts_game_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CrazyEightsGameProvider()),
        ChangeNotifierProvider(create: (_) => ThirtyOneGameProvider()),
        ChangeNotifierProvider(create: (_) => WhotGameProvider()),
        ChangeNotifierProvider(
            create: (_) =>
                DraughtsGameProvider()), // Added DraughtsGameProvider
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Game',
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'inter',
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: AppBarTheme(
            backgroundColor: chachaAppBarColor(),
            iconTheme: IconThemeData(color: Colors.white)),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const GameListScreen(),
        '/draughtsMenu': (context) =>
            const DraughtsMenuScreen(), // Route to DraughtsMenuScreen
        '/draughtsGame': (context) =>
            const DraughtsGameScreen(), // Route to DraughtsGameScreen
        '/whotMenu': (context) =>
            const WhotMenuScreen(), // Route to DraughtsMenuScreen
        '/whotGame': (context) =>
            const WhotGameScreen(), // Route to DraughtsMenuScreen
      },
    );
  }
}
