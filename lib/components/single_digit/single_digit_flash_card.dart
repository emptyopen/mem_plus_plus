import 'package:flutter/material.dart';
import 'single_digit_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'dart:convert';
import 'package:mem_plus_plus/components/activities.dart';

class SingleDigitFlashCard extends StatefulWidget {
  final SingleDigitData singleDigitData;
  final Function(int) callback;

  SingleDigitFlashCard({this.singleDigitData, this.callback});

  @override
  _SingleDigitFlashCardState createState() => _SingleDigitFlashCardState();
}

class _SingleDigitFlashCardState extends State<SingleDigitFlashCard> {
  bool done = false;
  bool guessed = true;
  int familiarityIncrease = 40;
  int familiarityDecrease = 25;
  String singleDigitKey = 'singleDigit';
  String levelKey = 'level';
  String activityStatesKey = 'activityStates';
  SharedPreferences sharedPreferences;

  void updateLevel() async {
    // TODO make this universally accessible function?
    SharedPreferences prefs =
      await SharedPreferences.getInstance();
    print('setting level to 2');
    prefs.setInt(levelKey, 2);
    widget.callback(2);


    // update activity state to first time view
    var rawMap = json.decode(prefs.getString(activityStatesKey)) as Map<String, dynamic>;
    Map<String, Activity> activityStates = rawMap.map((k, v) => MapEntry(k, Activity.fromJson(v)));

    // update states for old activites to review
    Activity singleDigitEdit = activityStates['SingleDigitEdit'];
    singleDigitEdit.state = 'review';
    activityStates['SingleDigitEdit'] = singleDigitEdit;
    Activity singleDigitPractice = activityStates['SingleDigitPractice'];
    singleDigitPractice.state = 'review';
    activityStates['SingleDigitPractice'] = singleDigitPractice;

    // add firstView to new activity
    Activity singleDigitMultipleChoiceTest = activityStates['SingleDigitMultipleChoiceTest'];
    singleDigitMultipleChoiceTest.firstView = true;
    activityStates['SingleDigitMultipleChoiceTest'] = singleDigitMultipleChoiceTest;

    prefs.setString(activityStatesKey, json.encode(activityStates.map(
        (k, v) => MapEntry(k, v.toJson())
    ),));
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
            widget.singleDigitData.digits,
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
                widget.singleDigitData.object,
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
                      var singleDigitData = (json.decode(
                        prefs.getString(singleDigitKey))
                      as List)
                        .map((i) => SingleDigitData.fromJson(i))
                        .toList();
                      int currIndex = int.parse(widget.singleDigitData.digits);
                      SingleDigitData updatedSingleDigitEntry =
                      singleDigitData[currIndex];
                      int previousFamiliarity = singleDigitData[currIndex].familiarity;
                      if (updatedSingleDigitEntry.familiarity +
                        familiarityIncrease <=
                        100) {
                        updatedSingleDigitEntry.familiarity +=
                          familiarityIncrease;
                      } else {
                        updatedSingleDigitEntry.familiarity = 100;
                      }
                      singleDigitData[currIndex] =
                        updatedSingleDigitEntry;
                      prefs.setString(singleDigitKey,
                        json.encode(singleDigitData));
                      setState(() {
                        done = true;
                      });

                      // Snackbar
                      Color snackBarColor = Colors.green[200];
                      String snackBarText =
                        'Familiarity for digit ${updatedSingleDigitEntry.digits} increased (now ${updatedSingleDigitEntry.familiarity})!';
                      if (previousFamiliarity < 100 &&
                        updatedSingleDigitEntry.familiarity ==
                          100) {
                        snackBarText =
                        'Familiarity for digit ${updatedSingleDigitEntry.digits} maxed out! Great job!';
                        snackBarColor = Colors.amber[200];

                        // Check for level up!!
                        int familiaritySum = 0;
                        for (SingleDigitData singleDigitEntry in singleDigitData) {
                          familiaritySum += singleDigitEntry.familiarity;
                        }
                        if (familiaritySum == 1000 && prefs.getInt(levelKey) == 1) {
                          levelUp = true;
                          updateLevel();
                        }
                      } else if (updatedSingleDigitEntry
                        .familiarity ==
                        100) {
                        snackBarText =
                        'Familiarity for digit already ${updatedSingleDigitEntry.digits} maxed out!';
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
                        Scaffold.of(context).showSnackBar(snackBar);
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
                      var singleDigitData = (json.decode(
                        prefs.getString(singleDigitKey))
                      as List)
                        .map((i) => SingleDigitData.fromJson(i))
                        .toList();
                      int currIndex = int.parse(
                        widget.singleDigitData.digits);
                      SingleDigitData updatedSingleDigitEntry =
                      singleDigitData[currIndex];
                      if (updatedSingleDigitEntry.familiarity -
                        familiarityDecrease >=
                        0) {
                        updatedSingleDigitEntry.familiarity -=
                          familiarityDecrease;
                      } else {
                        updatedSingleDigitEntry.familiarity = 0;
                      }
                      singleDigitData[currIndex] =
                        updatedSingleDigitEntry;
                      prefs.setString(singleDigitKey,
                        json.encode(singleDigitData));
                      setState(() {
                        done = true;
                      });

                      // Snackbar
                      String snackBarText =
                        'Familiarity for digit ${updatedSingleDigitEntry.digits} decreased by $familiarityDecrease to ${updatedSingleDigitEntry.familiarity}!';
                      if (updatedSingleDigitEntry.familiarity ==
                        0) {
                        snackBarText =
                        'Familiarity for digit ${updatedSingleDigitEntry.digits} can\'t go lower!';
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