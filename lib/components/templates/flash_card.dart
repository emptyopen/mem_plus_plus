import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/data/single_digit_data.dart';
import 'package:mem_plus_plus/components/data/alphabet_data.dart';
import 'package:mem_plus_plus/components/data/pao_data.dart';
import 'package:mem_plus_plus/components/data/deck_data.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'dart:convert';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/services.dart';

class FlashCard extends StatefulWidget {
  final Key key;
  final String systemKey;
  final dynamic entry;
  final Function(bool) callback;
  final Function() nextActivityCallback;
  final int familiarityTotal;
  final Color color;
  final Color lighterColor;
  final bool isLastCard;
  final GlobalKey<ScaffoldState> globalKey;

  FlashCard({
    this.key,
    this.systemKey,
    this.entry,
    this.callback,
    this.nextActivityCallback,
    this.familiarityTotal,
    this.color,
    this.lighterColor,
    this.globalKey,
    this.isLastCard = false,
  });

  @override
  _FlashCardState createState() => _FlashCardState();
}

class _FlashCardState extends State<FlashCard> {
  int familiarityIncrease = debugModeEnabled ? 100 : 50;
  int familiarityDecrease = 35;
  String digitLetter = '';
  String value = '';
  Widget valueWidget = Container();
  final prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    switch (widget.systemKey) {
      case (alphabetKey):
        value = (widget.entry as AlphabetData).letter;
        valueWidget = Text(
          value,
          style: TextStyle(fontSize: 50),
        );
        digitLetter = 'letter';
        break;
      case (singleDigitKey):
        value = (widget.entry as SingleDigitData).digits;
        valueWidget = Text(
          value,
          style: TextStyle(fontSize: 50),
        );
        digitLetter = 'digit';
        break;
      case (paoKey):
        value = (widget.entry as PAOData).digits;
        valueWidget = Text(
          value,
          style: TextStyle(fontSize: 50),
        );
        digitLetter = 'digit';
        break;
      case (deckKey):
        value = (widget.entry as DeckData).digitSuit;
        valueWidget = getDeckCard(value, 'big');
        digitLetter = 'card';
        break;
    }
  }

  void gotIt() async {
    HapticFeedback.lightImpact();
    bool levelUp = false;
    List<dynamic> data = await prefs.getSharedPrefs(widget.systemKey);
    int currIndex = widget.entry.index;
    dynamic updatedEntry = data[currIndex];
    int previousFamiliarity = data[currIndex].familiarity;
    if (updatedEntry.familiarity + familiarityIncrease <= 100) {
      updatedEntry.familiarity += familiarityIncrease;
    } else {
      updatedEntry.familiarity = 100;
    }
    data[currIndex] = updatedEntry;
    prefs.setString(widget.systemKey, json.encode(data));

    // Snackbar
    Color snackBarColor = colorCorrect;
    String snackBarText =
        'Familiarity for $digitLetter $value increased, now at ${updatedEntry.familiarity}%';
    if (previousFamiliarity < 100 && updatedEntry.familiarity == 100) {
      snackBarText =
          'Familiarity for $digitLetter $value maxed out! Great job!';
      snackBarColor = colorCorrect;

      // Check for level up!!
      int familiaritySum = 0;
      for (dynamic entry in data) {
        familiaritySum += entry.familiarity;
      }
      if (familiaritySum == widget.familiarityTotal) {
        levelUp = true;
        widget.nextActivityCallback();
      }
    } else if (updatedEntry.familiarity == 100) {
      snackBarText = 'Familiarity for $digitLetter $value maxed out!';
      snackBarColor = colorCorrect;
    }
    showSnackBar(
        scaffoldState: Scaffold.of(context),
        snackBarText: snackBarText,
        backgroundColor: snackBarColor,
        durationSeconds: 1);
    if (levelUp) {
      showSnackBar(
          scaffoldState: widget.globalKey.currentState,
          snackBarText:
              'Congratulations, you\'ve maxed out all familiarities! Next up is a test!',
          backgroundColor: widget.color,
          durationSeconds: 3);
      Navigator.pop(context);
    } else if (widget.isLastCard) {
      int familiaritySum = 0;
      for (dynamic entry in data) {
        familiaritySum += entry.familiarity;
      }
      if (familiaritySum == widget.familiarityTotal) {
        showSnackBar(
          scaffoldState: widget.globalKey.currentState,
          snackBarText:
              'Great job! Come back any time!',
          backgroundColor: widget.color,
          durationSeconds: 3);
      } else {
        showSnackBar(
          scaffoldState: widget.globalKey.currentState,
          snackBarText:
              'Great job! You still have some items for which you need to increase familiarity, pop back here any time!',
          backgroundColor: widget.color,
          durationSeconds: 3);
      }
      Navigator.pop(context);
    }
    widget.callback(true);
  }

  void didntGotIt() async {
    HapticFeedback.lightImpact();
    List<dynamic> dataList = await prefs.getSharedPrefs(widget.systemKey);
    int currIndex = widget.entry.index;
    dynamic updatedEntry = dataList[currIndex];
    if (updatedEntry.familiarity - familiarityDecrease >= 0) {
      updatedEntry.familiarity -= familiarityDecrease;
    } else {
      updatedEntry.familiarity = 0;
    }
    dataList[currIndex] = updatedEntry;
    prefs.setString(widget.systemKey, json.encode(dataList));

    // Snackbar
    String snackBarText =
        'Familiarity for $digitLetter $value decreased by $familiarityDecrease to ${updatedEntry.familiarity}!';
    if (updatedEntry.familiarity == 0) {
      snackBarText = 'Familiarity for $digitLetter $value can\'t go lower!';
    }
    showSnackBar(
        scaffoldState: Scaffold.of(context),
        snackBarText: snackBarText,
        backgroundColor: colorIncorrect,
        durationSeconds: 2);
    if (widget.isLastCard) {
      showSnackBar(
          scaffoldState: widget.globalKey.currentState,
          snackBarText:
              'Great job! You still have some items you need to increase familiarity for, pop back to practice any time!',
          backgroundColor: widget.color,
          durationSeconds: 3);
      Navigator.pop(context);
    }
    widget.callback(false);
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
          decoration: BoxDecoration(color: backgroundColor),
          height: screenHeight * 0.5,
          width: screenWidth * 0.7,
          child: FlipCard(
            speed: 700,
            front: Container(
              decoration: BoxDecoration(
                  color: widget.lighterColor,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  valueWidget,
                  SizedBox(height: 30),
                  Text(
                    '(Tap to flip!)',
                    style: TextStyle(
                        fontSize: 20, color: Colors.grey[500]),
                  )
                ],
              ),
            ),
            back: Container(
              decoration: BoxDecoration(
                  color: widget.lighterColor,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(20)),
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Center(
                      child: widget.systemKey == paoKey ||
                              widget.systemKey == deckKey
                          ? Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    widget.entry.person,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 30),
                                  ),
                                ),
                                Text(
                                  widget.entry.action,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 24),
                                ),
                                Text(
                                  widget.entry.object,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 24),
                                ),
                                SizedBox(
                                  height: 50,
                                )
                              ],
                            )
                          : Text(
                              widget.entry.object,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 40),
                            ),
                    ),
                  ),
                  Positioned(
                    child: Container(
                      height: 60,
                      width: screenWidth * 0.30,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: colorIncorrect,
                          borderRadius: BorderRadius.circular(20)),
                      child: FlatButton(
                        onPressed: () => didntGotIt(),
                        child: Center(
                            child: Text(
                          'Next time!',
                          style: TextStyle(
                              fontSize: 17, color: Colors.black),
                        )),
                      ),
                    ),
                    bottom: 10,
                    left: 10,
                  ),
                  Positioned(
                    child: Container(
                      height: 60,
                      width: screenWidth * 0.30,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: colorCorrect,
                          borderRadius: BorderRadius.circular(20)),
                      child: FlatButton(
                        onPressed: () => gotIt(),
                        child: Center(
                            child: Text(
                          'Got it!',
                          style: TextStyle(
                              fontSize: 20, color: Colors.black),
                        )),
                      ),
                    ),
                    bottom: 10,
                    right: 10,
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
