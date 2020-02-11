import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/single_digit/single_digit_data.dart';
import 'package:mem_plus_plus/components/alphabet/alphabet_data.dart';
import 'package:mem_plus_plus/components/pao/pao_data.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'dart:convert';
import 'package:mem_plus_plus/services/services.dart';

class FlashCard extends StatefulWidget {
  final String activityKey;
  final dynamic entry;
  final Function() callback;
  final Function() nextActivityCallback;
  final int familiarityTotal;
  final Color color;

  FlashCard(
      {this.activityKey,
      this.entry,
      this.callback,
      this.nextActivityCallback,
      this.familiarityTotal,
      this.color});

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
    Color snackBarColor = Colors.green[200];
    String snackBarText =
        'Familiarity for $digitLetter $value increased, now at ${updatedEntry.familiarity}%';
    if (previousFamiliarity < 100 && updatedEntry.familiarity == 100) {
      snackBarText =
          'Familiarity for $digitLetter $value maxed out! Great job!';
      snackBarColor = widget.color;

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
      snackBarText = 'Familiarity for letter $value already maxed out!';
      snackBarColor = Colors.green[200];
    }
    showSnackBar(context, snackBarText, Colors.black, snackBarColor, 2);
    if (levelUp) {
      showSnackBar(
          context,
          'Congratulations, you\'ve leveled up! Head to the main menu to see what you\'ve unlocked!',
          Colors.black,
          widget.color,
          10);
    }
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
    showSnackBar(context, snackBarText, Colors.black, Colors.red[200], 2);
  }

  @override
  Widget build(BuildContext context) {
    return done
        ? Container()
        : Container(
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  value,
                  style: TextStyle(fontSize: 34),
                ),
                SizedBox(height: 10,),
                guessed
                    ? BasicFlatButton(
                        text: 'Reveal',
                        color: Theme.of(context).primaryColor,
                        splashColor: widget.color,
                        onPressed: () {
                          setState(() {
                            guessed = false;
                          });
                        },
                        fontSize: 24,
                        padding: 10,
                      )
                    : Container(),
                guessed
                    ? Container()
                    : Column(
                        children: <Widget>[
                          Text(
                            widget.entry.object,
                            style: TextStyle(fontSize: 24),
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              BasicFlatButton(
                                text: 'Next time',
                                color: Colors.red[50],
                                splashColor: Colors.red[300],
                                onPressed: () => didntGotIt(),
                                fontSize: 22,
                                padding: 10,
                              ),
                              SizedBox(width: 30,),
                              BasicFlatButton(
                                text: 'Got it!',
                                color: Colors.green[50],
                                splashColor: Colors.green[300],
                                onPressed: () => gotIt(),
                                fontSize: 22,
                                padding: 10,
                              ),
                            ],
                          ),
                        ],
                      )
              ],
            ),
          );
  }
}
