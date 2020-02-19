import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/single_digit/single_digit_data.dart';
import 'package:mem_plus_plus/components/alphabet/alphabet_data.dart';
import 'package:mem_plus_plus/components/pao/pao_data.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'dart:convert';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:flip_card/flip_card.dart';

class FlashCard extends StatefulWidget {
  final String activityKey;
  final dynamic entry;
  final Function(bool) callback;
  final Function() nextActivityCallback;
  final int familiarityTotal;
  final Color color;
  final Color lighterColor;
  final GlobalKey<ScaffoldState> globalKey;

  FlashCard(
      {this.activityKey,
      this.entry,
      this.callback,
      this.nextActivityCallback,
      this.familiarityTotal,
      this.color,
      this.lighterColor,
      this.globalKey});

  @override
  _FlashCardState createState() => _FlashCardState();
}

class _FlashCardState extends State<FlashCard> {
  bool done = false;
  bool guessed = true;
  int familiarityIncrease = 100;
  int familiarityDecrease = 25;
  String activityStatesKey = 'ActivityStates';
  String digitLetter = '';
  String value = '';
  final prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    switch (widget.activityKey) {
      case ('Alphabet'):
        value = (widget.entry as AlphabetData).letter;
        digitLetter = 'letter';
        break;
      case ('SingleDigit'):
        value = (widget.entry as SingleDigitData).digits;
        digitLetter = 'digit';
        break;
      case ('PAO'):
        value = (widget.entry as PAOData).digits;
        digitLetter = 'digit';
        break;
    }
  }

  void gotIt() async {
    bool levelUp = false;
    var prefs = PrefsUpdater();
    List<dynamic> data = await prefs.getSharedPrefs(widget.activityKey);
    int currIndex = widget.entry.index;
    dynamic updatedEntry = data[currIndex];
    int previousFamiliarity = data[currIndex].familiarity;
    if (updatedEntry.familiarity + familiarityIncrease <= 100) {
      updatedEntry.familiarity += familiarityIncrease;
    } else {
      updatedEntry.familiarity = 100;
    }
    data[currIndex] = updatedEntry;
    prefs.setString(widget.activityKey, json.encode(data));

    setState(() {
      done = true;
    });

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
      snackBarText = 'Familiarity for $digitLetter $value already maxed out!';
      snackBarColor = colorCorrect;
    }
    showSnackBar(
        scaffoldState: Scaffold.of(context),
        snackBarText: snackBarText,
        backgroundColor: snackBarColor,
        durationSeconds: 2);
    if (levelUp) {
      showSnackBar(
          scaffoldState: widget.globalKey.currentState,
          snackBarText:
              'Congratulations, you\'ve leveled up! Next up is a test!',
          backgroundColor: widget.color,
          durationSeconds: 5);
      Navigator.pop(context);
    }
    widget.callback(true);
  }

  void didntGotIt() async {
    var prefs = PrefsUpdater();
    List<dynamic> dataList = await prefs.getSharedPrefs(widget.activityKey);
    int currIndex = widget.entry.index;
    dynamic updatedEntry = dataList[currIndex];
    if (updatedEntry.familiarity - familiarityDecrease >= 0) {
      updatedEntry.familiarity -= familiarityDecrease;
    } else {
      updatedEntry.familiarity = 0;
    }
    dataList[currIndex] = updatedEntry;
    prefs.setString(widget.activityKey, json.encode(dataList));

    setState(() {
      done = true;
    });

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
    widget.callback(false);
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return done
        ? Container()
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
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
                            Text(
                              value,
                              style: TextStyle(fontSize: 50),
                            ),
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
                            Center(
                              child: widget.activityKey == 'PAO'
                                  ? Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Text(
                                          widget.entry.person,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 30),
                                        ),
                                        Text(
                                          widget.entry.action,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 30),
                                        ),
                                        Text(
                                          widget.entry.object,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 30),
                                        ),
                                        SizedBox(height: 50,)
                                      ],
                                    )
                                  : Text(
                                      widget.entry.object,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 40),
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
              ),
            ],
          );
  }
}

// Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 Text(
//                   value,
//                   style: TextStyle(fontSize: 34),
//                 ),
//                 SizedBox(
//                   height: 50,
//                 ),
//                 guessed
//                     ? BasicFlatButton(
//                         text: 'Reveal',
//                         color: Theme.of(context).primaryColor,
//                         splashColor: widget.color,
//                         onPressed: () {
//                           setState(() {
//                             guessed = false;
//                           });
//                         },
//                         fontSize: 24,
//                         padding: 10,
//                       )
//                     : Container(),
//                 guessed
//                     ? Container()
//                     : Column(
//                         children: <Widget>[
//                           Text(
//                             widget.entry.object,
//                             style: TextStyle(fontSize: 24),
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: <Widget>[
//                               BasicFlatButton(
//                                 text: 'Next time',
//                                 color: colorIncorrect,
//                                 splashColor: colorIncorrectDarker,
//                                 onPressed: () => didntGotIt(),
//                                 fontSize: 22,
//                                 padding: 10,
//                               ),
//                               SizedBox(
//                                 width: 30,
//                               ),
//                               BasicFlatButton(
//                                 text: 'Got it!',
//                                 color: colorCorrect,
//                                 splashColor: colorCorrectDarker,
//                                 onPressed: () => gotIt(),
//                                 fontSize: 22,
//                                 padding: 10,
//                               ),
//                             ],
//                           ),
//                         ],
//                       )
//               ],
//             ),
