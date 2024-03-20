import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/templates/written_card.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/components/templates/flash_card.dart';
import 'package:mem_plus_plus/components/templates/multiple_choice_card.dart';

class CardTestScreen extends StatefulWidget {
  final List<dynamic> cardData;
  final String cardType;
  final GlobalKey globalKey;
  final Function nextActivity;
  final String systemKey;
  final int familiarityTotal;
  final Color color;
  final Color lighterColor;
  final List<dynamic> shuffledChoices;

  CardTestScreen({
    required this.cardData,
    this.shuffledChoices = const [],
    required this.cardType,
    required this.globalKey,
    required this.nextActivity,
    required this.systemKey,
    required this.familiarityTotal,
    required this.color,
    required this.lighterColor,
  });

  @override
  _CardTestScreenState createState() => _CardTestScreenState();
}

class _CardTestScreenState extends State<CardTestScreen> {
  int numCards = 0;
  int attempts = 0;
  List<bool?> results = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      numCards = widget.cardData.length;
      results = List.filled(numCards, null);
    });
  }

  callback(bool success) {
    if (success) {
      results[attempts] = true;
    } else {
      results[attempts] = false;
    }
    attempts += 1;
    setState(() {});
  }

  Widget getCard() {
    if (widget.cardType == 'FlashCard') {
      return new FlashCard(
        key: UniqueKey(),
        entry: widget.cardData[attempts],
        callback: callback,
        systemKey: widget.systemKey,
        nextActivityCallback: widget.nextActivity,
        familiarityTotal: widget.familiarityTotal,
        color: widget.color,
        lighterColor: widget.lighterColor,
        isLastCard: attempts == numCards - 1,
      );
    } else if (widget.cardType == 'MultipleChoiceCard') {
      return new MultipleChoiceCard(
        key: UniqueKey(),
        entry: widget.cardData[attempts],
        callback: callback,
        systemKey: widget.systemKey,
        nextActivityCallback: widget.nextActivity,
        familiarityTotal: widget.familiarityTotal,
        color: widget.color,
        lighterColor: widget.lighterColor,
        isLastCard: attempts == numCards - 1,
        results: results,
        shuffledChoices: widget.shuffledChoices,
      );
    } else if (widget.cardType == 'WrittenCard') {
      return new WrittenCard(
        key: UniqueKey(),
        entry: widget.cardData[attempts],
        callback: callback,
        systemKey: widget.systemKey,
        nextActivityCallback: widget.nextActivity,
        color: widget.color,
        lighterColor: widget.lighterColor,
        isLastCard: attempts == numCards - 1,
        results: results,
      );
    }
    return Container();
  }

  List<Widget> getProgressTiles() {
    attempts = 0;
    var screenWidth = MediaQuery.of(context).size.width;
    var tileWidth = screenWidth / numCards;
    List<Widget> progressTiles = [];
    results.forEach((e) {
      if (e == null) {
        progressTiles.add(Container(
          height: 40,
          width: tileWidth,
          decoration: BoxDecoration(color: Colors.grey[300]),
        ));
      } else if (e) {
        attempts += 1;
        progressTiles.add(Container(
          height: 40,
          width: tileWidth,
          decoration: BoxDecoration(color: colorCorrect),
        ));
      } else {
        attempts += 1;
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
    return Container(
      decoration: BoxDecoration(color: backgroundColor),
      child: Center(
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
                    child: Text('$attempts/$numCards completed')),
              ))
            ],
          ),
          Expanded(
            child: attempts < numCards ? getCard() : Container(),
          ),
        ],
      )),
    );
  }
}
