// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

enum Shape {
  Square,
  Star,
  Circle,
  Triangle,
  Cross,
  Whot,
  Other,
}

class WhotCardModel {
  final int value;
  final String shape;
  final String move;
  final int score;
  final String image;
  late String? iNeed;

  WhotCardModel({
    required this.value,
    required this.shape,
    required this.move,
    required this.score,
    required this.image,
    this.iNeed,
  });

  factory WhotCardModel.fromJson(Map<String, dynamic> json) {
    return WhotCardModel(
      image: shapeToImage(stringToShape(json['shape'])),
      value: json['value'],
      shape: json['shape'],
      move: json['move'],
      score: json['score'],
      iNeed: json['iNeed'],
    );
  }

  static Shape stringToShape(String shape) {
    switch (shape.toUpperCase().trim()) {
      case "SQUARE":
        return Shape.Square;
      case "STAR":
        return Shape.Star;
      case "CIRCLE":
        return Shape.Circle;
      case "TRIANGLE":
        return Shape.Triangle;
      case "CROSS":
        return Shape.Cross;
      case "WHOT":
        return Shape.Whot;
      default:
        return Shape.Other;
    }
  }

  static String shapeToString(Shape shape) {
    switch (shape) {
      case Shape.Square:
        return "Square";
      case Shape.Star:
        return "Star";
      case Shape.Circle:
        return "Circle";
      case Shape.Triangle:
        return "Triangle";
      case Shape.Cross:
        return "Cross";
      case Shape.Whot:
        return "Whot";
      case Shape.Other:
        return "Other";
    }
  }

  static String shapeToImage(Shape shape) {
    switch (shape) {
      case Shape.Square:
        return "assets/images/cardSquare.png";
      case Shape.Star:
        return "assets/images/cardStar.png";
      case Shape.Circle:
        return "assets/images/cardCircle.png";
      case Shape.Triangle:
        return "assets/images/cardTriangle.png";
      case Shape.Cross:
        return "assets/images/cardCross.png";
      case Shape.Whot:
        return "assets/images/small/card-whot.svg";
      case Shape.Other:
        return "assets/images/card-other-new.png";
    }
  }

  // static Color suitToColor(Suit suit) {
  //   switch (suit) {
  //     case Suit.Hearts:
  //     case Suit.Diamonds:
  //       return Colors.red;
  //     default:
  //       return Colors.black;
  //   }
  // }
}
