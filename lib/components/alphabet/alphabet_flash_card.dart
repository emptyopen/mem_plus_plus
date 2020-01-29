import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/alphabet/alphabet_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'dart:convert';
import 'package:mem_plus_plus/services/prefs_services.dart';

class AlphabetFlashCard extends StatefulWidget {
  final AlphabetData alphabetData;
  final Function() callback;

  AlphabetFlashCard({this.alphabetData, this.callback});

  @override
  _AlphabetFlashCardState createState() => _AlphabetFlashCardState();
}

class _AlphabetFlashCardState extends State<AlphabetFlashCard> {
  bool done = false;
  bool guessed = true;
  int familiarityIncrease = 40;
  int familiarityDecrease = 25;
  String alphabetKey = 'Alphabet';
  String levelKey = 'Level';
  String activityStatesKey = 'ActivityStates';
  SharedPreferences sharedPreferences;
  final prefs = PrefsUpdater();

  void updateLevel() async {

    await prefs.updateLevel(2);
    await prefs.updateActivityState('AlphabetEdit', 'review');
    await prefs.updateActivityState('AlphabetPractice', 'review');
    await prefs.updateActivityFirstView('AlphabetMultipleChoiceTest', true);

    widget.callback();
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
                  widget.alphabetData.digits,
                  style: TextStyle(fontSize: 34),
                ),
                guessed
                    ? FlatButton(
                        onPressed: () {
                          setState(() {
                            guessed = false;
                          });
                        },
                        child: BasicContainer(
                          text: 'Reveal',
                          color: Colors.amber[50],
                          fontSize: 18,
                        ))
                    : Container(),
                guessed
                    ? Container()
                    : Column(
                        children: <Widget>[
                          Text(
                            widget.alphabetData.object,
                            style: TextStyle(fontSize: 24),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FlatButton(
                                  onPressed: () async {
                                    bool levelUp = false;
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    var alphabetData = (json.decode(
                                                prefs.getString(alphabetKey))
                                            as List)
                                        .map((i) => AlphabetData.fromJson(i))
                                        .toList();
                                    int currIndex = int.parse(
                                        widget.alphabetData.digits);
                                    AlphabetData updatedAlphabetEntry =
                                        alphabetData[currIndex];
                                    int previousFamiliarity =
                                        alphabetData[currIndex].familiarity;
                                    if (updatedAlphabetEntry.familiarity +
                                            familiarityIncrease <=
                                        100) {
                                      updatedAlphabetEntry.familiarity +=
                                          familiarityIncrease;
                                    } else {
                                      updatedAlphabetEntry.familiarity = 100;
                                    }
                                    alphabetData[currIndex] =
                                        updatedAlphabetEntry;
                                    prefs.setString(alphabetKey,
                                        json.encode(alphabetData));
                                    setState(() {
                                      done = true;
                                    });

                                    // Snackbar
                                    Color snackBarColor = Colors.green[200];
                                    String snackBarText =
                                        'Familiarity for digit ${updatedAlphabetEntry.digits} increased (now ${updatedAlphabetEntry.familiarity})!';
                                    if (previousFamiliarity < 100 &&
                                        updatedAlphabetEntry.familiarity ==
                                            100) {
                                      snackBarText =
                                          'Familiarity for digit ${updatedAlphabetEntry.digits} maxed out! Great job!';
                                      snackBarColor = Colors.amber[200];

                                      // Check for level up!!
                                      int familiaritySum = 0;
                                      for (AlphabetData alphabetEntry
                                          in alphabetData) {
                                        familiaritySum +=
                                            alphabetEntry.familiarity;
                                      }
                                      if (familiaritySum == 1000 &&
                                          prefs.getInt(levelKey) == 1) {
                                        levelUp = true;
                                        updateLevel();
                                      }
                                    } else if (updatedAlphabetEntry
                                            .familiarity ==
                                        100) {
                                      snackBarText =
                                          'Familiarity for digit already ${updatedAlphabetEntry.digits} maxed out!';
                                      snackBarColor = Colors.amber[200];
                                    }
                                    final snackBar = SnackBar(
                                      content: Text(
                                        snackBarText,
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      duration: Duration(seconds: 2),
                                      backgroundColor: snackBarColor,
                                    );
                                    Scaffold.of(context).showSnackBar(snackBar);
                                    if (levelUp) {
                                      final snackBar = SnackBar(
                                        content: Text(
                                          'Congratulations, you\'ve leveled up! Head to the main menu to see what you\'ve unlocked!',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        duration: Duration(seconds: 6),
                                        backgroundColor: Colors.black,
                                      );
                                      Scaffold.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  },
                                  child: BasicContainer(
                                    text: 'Got it',
                                    color: Colors.green[50],
                                    fontSize: 18,
                                  )),
                              FlatButton(
                                  onPressed: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    var alphabetData = (json.decode(
                                                prefs.getString(alphabetKey))
                                            as List)
                                        .map((i) => AlphabetData.fromJson(i))
                                        .toList();
                                    int currIndex = int.parse(
                                        widget.alphabetData.digits);
                                    AlphabetData updatedAlphabetEntry =
                                        alphabetData[currIndex];
                                    if (updatedAlphabetEntry.familiarity -
                                            familiarityDecrease >=
                                        0) {
                                      updatedAlphabetEntry.familiarity -=
                                          familiarityDecrease;
                                    } else {
                                      updatedAlphabetEntry.familiarity = 0;
                                    }
                                    alphabetData[currIndex] =
                                        updatedAlphabetEntry;
                                    prefs.setString(alphabetKey,
                                        json.encode(alphabetData));
                                    setState(() {
                                      done = true;
                                    });

                                    // Snackbar
                                    String snackBarText =
                                        'Familiarity for digit ${updatedAlphabetEntry.digits} decreased by $familiarityDecrease to ${updatedAlphabetEntry.familiarity}!';
                                    if (updatedAlphabetEntry.familiarity ==
                                        0) {
                                      snackBarText =
                                          'Familiarity for digit ${updatedAlphabetEntry.digits} can\'t go lower!';
                                    }
                                    final snackBar = SnackBar(
                                      content: Text(
                                        snackBarText,
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      duration: Duration(seconds: 2),
                                      backgroundColor: Colors.red[200],
                                    );
                                    Scaffold.of(context).showSnackBar(snackBar);
                                  },
                                  child: BasicContainer(
                                    text: 'Didn\'t got it',
                                    color: Colors.red[50],
                                    fontSize: 18,
                                  ))
                            ],
                          ),
                        ],
                      )
              ],
            ),
          );
  }
}
