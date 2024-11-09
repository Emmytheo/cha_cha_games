import 'package:cha_cha_games/constants.dart';
import 'package:cha_cha_games/models/game_model.dart';
import 'package:cha_cha_games/providers/whot_game_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CreateWhotGameModal extends StatefulWidget {
  const CreateWhotGameModal({Key? key}) : super(key: key);

  @override
  _CreateGameModalState createState() => _CreateGameModalState();
}

class _CreateGameModalState extends State<CreateWhotGameModal> {
  final TextEditingController _gameIdController = TextEditingController();
  final TextEditingController _maxPlayersController = TextEditingController();
  bool _isLoading = false;
  late WhotGameProvider _gameProvider;

  @override
  void initState() {
    // _gameProvider = Provider.of<ThirtyOneGameProvider>(context, listen: false);
    // _gameProvider = Provider.of<CrazyEightsGameProvider>(context, listen: false);
    _gameProvider = Provider.of<WhotGameProvider>(context, listen: false);
    super.initState();
  }

  Future<void> _createGame() async {
    final maxPlayers = int.tryParse(_maxPlayersController.text);

    if (maxPlayers == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter valid number of max players')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final game = await _gameProvider.newWhotGame(maxPlayers);
      final response = [game.toJson()];

      if (response.isNotEmpty) {
        await _gameProvider.listGames();
        Navigator.of(context).pop(response);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create game')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: chachaAppBarColor(),
      title: Text(
        'Create New Game',
        style: GoogleFonts.inter(
            fontWeight: FontWeight.normal,
            // fontSize: 18,

            // height: 0.95,
            color: Colors.white),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _maxPlayersController,
            decoration: InputDecoration(
              labelText: 'Max Players',
              labelStyle: GoogleFonts.inter(
                  fontWeight: FontWeight.normal,
                  // fontSize: 18,

                  // height: 0.95,
                  color: Colors.white),
              hoverColor: Colors.white,
              // keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.normal,
                // fontSize: 18,

                // height: 0.95,
                color: Colors.white),
          ),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _createGame,
          child: _isLoading
              ? CircularProgressIndicator()
              : Text(
                  'Create',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.normal,
                    // fontSize: 18,

                    // height: 0.95,
                    // color: Colors.white
                  ),
                ),
        ),
      ],
    );
  }

  httpPost(String s, {required Map<String, Object> body}) {}
}
