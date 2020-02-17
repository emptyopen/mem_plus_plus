import 'package:flutter/material.dart';
import 'package:mem_plus_plus/constants/colors.dart';

class CardTestScreen extends StatefulWidget {
  final List results;
  final Function getCards;
  final int numCards;

  CardTestScreen({
    this.results,
    this.getCards,
    this.numCards,
  });

  @override
  _CardTestScreenState createState() => _CardTestScreenState();
}

class _CardTestScreenState extends State<CardTestScreen> {
  List<Widget> getProgressTiles() {
    var screenWidth = MediaQuery.of(context).size.width;
    var tileWidth = screenWidth / widget.numCards;
    List<Widget> progressTiles = [];
    widget.results.forEach((e) {
      if (e == null) {
        progressTiles.add(Container(
          height: 40,
          width: tileWidth,
          decoration: BoxDecoration(color: Colors.grey),
        ));
      } else if (e) {
        progressTiles.add(Container(
          height: 40,
          width: tileWidth,
          decoration: BoxDecoration(color: colorCorrect),
        ));
      } else {
        progressTiles.add(Container(
            height: 40,
            width: tileWidth,
            decoration: BoxDecoration(color: colorIncorrect)));
      }
    });
    return progressTiles;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: getProgressTiles(),
        ),
        Stack(
          children: widget.getCards(),
        ),
      ],
    ));
  }
}
