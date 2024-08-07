import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/data/single_digit_data.dart';
import 'package:mem_plus_plus/components/data/alphabet_data.dart';
import 'package:mem_plus_plus/components/data/pao_data.dart';
import 'package:mem_plus_plus/components/data/deck_data.dart';
import 'package:mem_plus_plus/components/data/triple_digit_data.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'dart:convert';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/services.dart';

class FlashCard extends StatefulWidget {
  final Key key;
  final String systemKey;
  final dynamic entry;
  final Function callback;
  final Function nextActivityCallback;
  final int familiarityTotal;
  final Color color;
  final Color lighterColor;
  final bool isLastCard;

  FlashCard({
    required this.key,
    required this.systemKey,
    required this.entry,
    required this.callback,
    required this.nextActivityCallback,
    required this.familiarityTotal,
    required this.color,
    required this.lighterColor,
    this.isLastCard = false,
  });

  @override
  _FlashCardState createState() => _FlashCardState();
}

class _FlashCardState extends State<FlashCard> {
  int familiarityIncrease = debugModeEnabled ? 100 : 35;
  int familiarityDecrease = 50;
  String digitLetter = '';
  String value = '';
  Widget valueWidget = Container();
  PrefsUpdater prefs = PrefsUpdater();

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
      case (tripleDigitKey):
        value = (widget.entry as TripleDigitData).digits;
        valueWidget = Text(
          value,
          style: TextStyle(fontSize: 50),
        );
        digitLetter = 'digit';
        break;
    }
  }

  void gotIt() {
    HapticFeedback.lightImpact();
    bool levelUp = false;
    List<dynamic> data = prefs.getSharedPrefs(widget.systemKey) as List;
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

    // need to fix this so that current % shown largely in special case

    if (updatedEntry.familiarity < 100) {
      final snackBar = SnackBar(
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$digitLetter $value - ${[
                alphabetKey,
                singleDigitKey
              ].contains(widget.systemKey) ? updatedEntry.object : updatedEntry.person}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'now ${updatedEntry.familiarity}% familiar',
              style: TextStyle(
                color: Colors.black,
                fontSize: 26,
              ),
            ),
          ],
        ),
        duration: Duration(seconds: 2),
        backgroundColor: colorCorrect,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      if (previousFamiliarity < 100 && updatedEntry.familiarity == 100) {
        snackBarText =
            'Familiarity for $digitLetter $value maxed out! Great job!';
        snackBarColor = colorCorrect;

        // Check for level up!!
        int familiaritySum = 0;
        for (dynamic entry in data) {
          familiaritySum += entry.familiarity as int;
        }
        if (familiaritySum == widget.familiarityTotal
            // || (debugModeEnabled && familiaritySum > 500)
            ) {
          levelUp = true;
          widget.nextActivityCallback();
        }
      } else if (updatedEntry.familiarity == 100) {
        snackBarText = 'Familiarity for $digitLetter $value maxed out!';
        snackBarColor = colorCorrect;
      }
      showSnackBar(
          context: context,
          snackBarText: snackBarText,
          backgroundColor: snackBarColor,
          durationSeconds: 1);
    }
    if (levelUp) {
      showSnackBar(
          context: context,
          snackBarText:
              'Congratulations, you\'ve maxed out all familiarities! Next up is a test!',
          backgroundColor: widget.color,
          durationSeconds: 3);
      Navigator.pop(context);
    } else if (widget.isLastCard) {
      int familiaritySum = 0;
      for (dynamic entry in data) {
        familiaritySum += entry.familiarity as int;
      }
      if (familiaritySum == widget.familiarityTotal) {
        showSnackBar(
            context: context,
            snackBarText: 'Great job! Come back any time!',
            backgroundColor: widget.color,
            durationSeconds: 3);
      } else {
        showSnackBar(
            context: context,
            snackBarText:
                'Great job! You still have some items for which you need to increase familiarity, pop back here any time!',
            backgroundColor: widget.color,
            durationSeconds: 3);
      }
      Navigator.pop(context);
    }
    widget.callback(true);
  }

  void didntGotIt() {
    HapticFeedback.lightImpact();
    List<dynamic> dataList = prefs.getSharedPrefs(widget.systemKey) as List;
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
    final snackBar = SnackBar(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$digitLetter $value - ${[
              alphabetKey,
              singleDigitKey
            ].contains(widget.systemKey) ? updatedEntry.object : updatedEntry.person}',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'now ${updatedEntry.familiarity}% familiar',
            style: TextStyle(
              color: Colors.black,
              fontSize: 26,
            ),
          ),
        ],
      ),
      duration: Duration(seconds: 2),
      backgroundColor: colorIncorrect,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    if (widget.isLastCard) {
      showSnackBar(
          context: context,
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
            speed: 300,
            front: Container(
              decoration: BoxDecoration(
                color: widget.lighterColor,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: Offset(3, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  valueWidget,
                  SizedBox(height: 30),
                  Text(
                    '(Tap to flip!)',
                    style: TextStyle(fontSize: 20, color: Colors.grey[500]),
                  )
                ],
              ),
            ),
            back: Container(
              decoration: BoxDecoration(
                color: widget.lighterColor,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: Offset(3, 4),
                  ),
                ],
              ),
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Center(
                      child: widget.systemKey == paoKey ||
                              widget.systemKey == deckKey ||
                              widget.systemKey == tripleDigitKey
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        // border: Border.all(color: Colors.grey),
                        color: colorIncorrect,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(2, 3),
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () => didntGotIt(),
                        child: Container(
                          decoration: BoxDecoration(),
                          child: Center(
                            child: Text(
                              'Next time!',
                              style:
                                  TextStyle(fontSize: 17, color: Colors.black),
                            ),
                          ),
                        ),
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
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(2, 3),
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () => gotIt(),
                        child: Container(
                          decoration: BoxDecoration(),
                          child: Center(
                            child: Text(
                              'Got it!',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black),
                            ),
                          ),
                        ),
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
