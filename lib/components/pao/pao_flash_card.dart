import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pao_data.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'dart:convert';
import 'package:mem_plus_plus/services/prefs_services.dart';

class PAOFlashCard extends StatefulWidget {
  final PAOData paoData;
  final Function() callback;

  PAOFlashCard({this.paoData, this.callback});

  @override
  _PAOFlashCardState createState() => _PAOFlashCardState();
}

class _PAOFlashCardState extends State<PAOFlashCard> {
  bool done = false;
  bool guessed = true;
  int familiarityIncrease = 40;
  int familiarityDecrease = 25;
  String paoKey = 'PAO';
  String levelKey = 'Level';
  final prefs = PrefsUpdater();

  void updateLevel() async {

    await prefs.updateLevel(8);
    await prefs.updateActivityState('PAOEdit', 'review');
    await prefs.updateActivityState('PAOPractice', 'review');
    await prefs.updateActivityFirstView('PAOMultipleChoiceTest', true);
    await prefs.updateActivityVisible('PAOMultipleChoiceTest', true);

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
                  widget.paoData.digits,
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
                            widget.paoData.person,
                            style: TextStyle(fontSize: 24),
                          ),
                          Text(
                            '${widget.paoData.action} • ${widget.paoData.object}',
                            style: TextStyle(fontSize: 22),
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
                                    prefs.getString(paoKey))
                                  as List)
                                    .map((i) => PAOData.fromJson(i))
                                    .toList();
                                  int currIndex = int.parse(
                                    widget.paoData.digits);
                                  PAOData updatedSingleDigitEntry =
                                  singleDigitData[currIndex];
                                  int previousFamiliarity =
                                    singleDigitData[currIndex].familiarity;
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
                                  prefs.setString(paoKey,
                                    json.encode(singleDigitData));
                                  setState(() {
                                    done = true;
                                  });

                                  // Snackbar
                                  Color snackBarColor = Colors.green[200];
                                  String snackBarText =
                                    'Familiarity for digits ${updatedSingleDigitEntry.digits} increased (now ${updatedSingleDigitEntry.familiarity})!';
                                  if (previousFamiliarity < 100 &&
                                    updatedSingleDigitEntry.familiarity ==
                                      100) {
                                    snackBarText =
                                    'Familiarity for digits ${updatedSingleDigitEntry.digits} maxed out! Great job!';
                                    snackBarColor = Colors.amber[200];

                                    // Check for level up!!
                                    int familiaritySum = 0;
                                    for (PAOData singleDigitEntry
                                    in singleDigitData) {
                                      familiaritySum +=
                                        singleDigitEntry.familiarity;
                                    }
                                    if (familiaritySum == 10000 &&
                                      prefs.getInt(levelKey) == 7) {
                                      levelUp = true;
                                      updateLevel();
                                    }
                                  } else if (updatedSingleDigitEntry
                                    .familiarity ==
                                    100) {
                                    snackBarText =
                                    'Familiarity for digits ${updatedSingleDigitEntry.digits} already maxed out!';
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
                                  var paoData = (json.decode(
                                    prefs.getString(paoKey))
                                  as List)
                                    .map((i) => PAOData.fromJson(i))
                                    .toList();
                                  int currIndex = int.parse(
                                    widget.paoData.digits);
                                  PAOData updatedSingleDigitEntry =
                                  paoData[currIndex];
                                  if (updatedSingleDigitEntry.familiarity -
                                    familiarityDecrease >=
                                    0) {
                                    updatedSingleDigitEntry.familiarity -=
                                      familiarityDecrease;
                                  } else {
                                    updatedSingleDigitEntry.familiarity = 0;
                                  }
                                  paoData[currIndex] =
                                    updatedSingleDigitEntry;
                                  prefs.setString(paoKey,
                                    json.encode(paoData));
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
