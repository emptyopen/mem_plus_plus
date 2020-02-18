import 'package:flutter/material.dart';
import 'package:mem_plus_plus/constants/colors.dart';

class CardTestScreen extends StatefulWidget {
  final List results;
  final List<Widget> cards;

  CardTestScreen({
    this.results,
    this.cards,
  });

  @override
  _CardTestScreenState createState() => _CardTestScreenState();
}

class _CardTestScreenState extends State<CardTestScreen> {
  int numCards = 0;
  int numCompleted = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      numCards = widget.cards.length;
    });
  }

  List<Widget> getProgressTiles() {
    numCards = widget.cards.length;
    numCompleted = 0;
    var screenWidth = MediaQuery.of(context).size.width;
    var tileWidth = screenWidth / numCards;
    List<Widget> progressTiles = [];
    widget.results.forEach((e) {
      if (e == null) {
        progressTiles.add(Container(
          height: 40,
          width: tileWidth,
          decoration: BoxDecoration(color: Colors.grey[300]),
        ));
      } else if (e) {
        numCompleted += 1;
        progressTiles.add(Container(
          height: 40,
          width: tileWidth,
          decoration: BoxDecoration(color: colorCorrect),
        ));
      } else {
        numCompleted += 1;
        progressTiles.add(Container(
            height: 40,
            width: tileWidth,
            decoration: BoxDecoration(color: colorIncorrect)));
      }
    });
    setState(() {});
    return progressTiles;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: getProgressTiles(),
            ),
            Positioned.fill(
                child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text('$numCompleted/$numCards completed')
                ),
            ))
          ],
        ),
        Expanded(
          child: Stack(
            children: widget.cards,
          ),
        ),
      ],
    ));
  }
}
