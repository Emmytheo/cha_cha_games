import 'package:cha_cha_games/models/coordinate.dart';

class Men {
  late int player;
  late bool isKing;
  late Coordinate coordinate;

  Men({this.player = 1, this.isKing = false, required this.coordinate});

  Men.of(Men men,{required Coordinate newCoor}){
    player = men.player;
    isKing = men.isKing;
    coordinate = men.coordinate;

    coordinate = newCoor;
    }

  upgradeToKing(){
    isKing = true;
  }
}