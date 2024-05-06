import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/standard/basic_flat_button.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_dialog.dart';

import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class PlanetTimedTestScreen extends StatefulWidget {
  final Function() callback;
  final GlobalKey<ScaffoldState> globalKey;

  PlanetTimedTestScreen({required this.callback, required this.globalKey});

  @override
  _PlanetTimedTestScreenState createState() => _PlanetTimedTestScreenState();
}

class _PlanetTimedTestScreenState extends State<PlanetTimedTestScreen> {
  final guess1Controller = TextEditingController();
  final guess2Controller = TextEditingController();
  final guess3Controller = TextEditingController();
  final guess4Controller = TextEditingController();
  String planet1 = '';
  String planet2 = '';
  String planet3 = '';
  String planet4 = '';
  Map planetPositionSize = {
    'mercury': [1, 1],
    'venus': [2, 3],
    'earth': [3, 4],
    'mars': [4, 2],
    'jupiter': [5, 8],
    'saturn': [6, 7],
    'uranus': [7, 6],
    'neptune': [8, 5],
  };
  bool showError1 = false;
  bool showError2 = false;
  bool showError3 = false;
  bool showError4 = false;
  PrefsUpdater prefs = PrefsUpdater();

  @override
  void dispose() {
    guess1Controller.dispose();
    guess2Controller.dispose();
    guess3Controller.dispose();
    guess4Controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    prefs.checkFirstTime(
        context, planetTimedTestFirstHelpKey, PlanetTimedTestScreenHelp());

    var random = Random();
    List planets = planetPositionSize.keys.toList();
    List notAllowed = [];
    planet1 = planets[random.nextInt(planets.length)];
    notAllowed.add(planet1);
    planet2 = planets[random.nextInt(planets.length)];
    while (notAllowed.contains(planet2)) {
      planet2 = planets[random.nextInt(planets.length)];
    }
    planet3 = planets[random.nextInt(planets.length)];
    while (notAllowed.contains(planet3)) {
      planet3 = planets[random.nextInt(planets.length)];
    }
    planet4 = planets[random.nextInt(planets.length)];
    while (notAllowed.contains(planet4)) {
      planet4 = planets[random.nextInt(planets.length)];
    }
    print(
        '${planetPositionSize[planet1][0]} ${planetPositionSize[planet2][0]} ${planetPositionSize[planet3][1]} ${planetPositionSize[planet4][1]}');
    setState(() {});
  }

  void checkAnswer() async {
    setState(() {
      showError1 = false;
      showError2 = false;
      showError3 = false;
      showError4 = false;
    });
    HapticFeedback.lightImpact();
    bool hasError = false;
    if (guess1Controller.text == '') {
      hasError = true;
      setState(() {
        showError1 = true;
      });
    }
    if (guess2Controller.text == '') {
      hasError = true;
      setState(() {
        showError2 = true;
      });
    }
    if (guess3Controller.text == '') {
      hasError = true;
      setState(() {
        showError3 = true;
      });
    }
    if (guess4Controller.text == '') {
      hasError = true;
      setState(() {
        showError4 = true;
      });
    }
    if (hasError) {
      return;
    }
    if (guess1Controller.text.trim() ==
            planetPositionSize[planet1][0].toString() &&
        guess2Controller.text.trim() ==
            planetPositionSize[planet2][0].toString() &&
        guess3Controller.text.trim() ==
            planetPositionSize[planet3][1].toString() &&
        guess4Controller.text.trim() ==
            planetPositionSize[planet4][1].toString()) {
      prefs.updateActivityVisible(planetTimedTestKey, false);
      prefs.updateActivityVisible(planetTimedTestPrepKey, true);
      if (!prefs.getBool(planetTimedTestCompleteKey)) {
        prefs.updateActivityState(planetTimedTestKey, 'review');
        prefs.setBool(planetTimedTestCompleteKey, true);
        if (!prefs.getBool(faceTimedTestCompleteKey)) {
          showSnackBar(
            context: context,
            snackBarText:
                'Awesome job! Complete the Face test to unlock the next system!',
            textColor: Colors.black,
            backgroundColor: colorChapter1Darker,
            durationSeconds: 3,
          );
        } else {
          prefs.updateActivityVisible(alphabetEditKey, true);
          showSnackBar(
            context: context,
            snackBarText:
                'Congratulations! You\'ve unlocked the Alphabet system!',
            textColor: Colors.white,
            backgroundColor: colorAlphabetDarker,
            durationSeconds: 3,
            isSuper: true,
          );
        }
      } else {
        showSnackBar(
          context: context,
          snackBarText: 'Congratulations! You aced it!',
          textColor: Colors.black,
          backgroundColor: colorChapter1Standard,
          durationSeconds: 2,
        );
      }
    } else {
      showSnackBar(
        context: context,
        snackBarText:
            'Incorrect. Keep trying to remember, or give up and try again!',
        textColor: Colors.black,
        backgroundColor: colorIncorrect,
        durationSeconds: 3,
      );
    }
    guess1Controller.text = '';
    guess2Controller.text = '';
    guess3Controller.text = '';
    guess4Controller.text = '';
    widget.callback();
    Navigator.pop(context);
  }

  void giveUp() async {
    HapticFeedback.lightImpact();
    prefs.updateActivityState(planetTimedTestKey, 'review');
    prefs.updateActivityVisible(planetTimedTestKey, false);
    prefs.updateActivityVisible(planetTimedTestPrepKey, true);
    showSnackBar(
        context: context,
        snackBarText: 'Head back to test prep to study up!',
        textColor: Colors.white,
        backgroundColor: colorIncorrect,
        durationSeconds: 3);
    Navigator.pop(context);
    widget.callback();
  }

  getNumberEnder(int index) {
    var number = '1';
    if (index == 1) {
      number = guess1Controller.text;
    } else if (index == 2) {
      number = guess2Controller.text;
    } else if (index == 3) {
      number = guess3Controller.text;
    } else if (index == 4) {
      number = guess4Controller.text;
    }
    if (number == '') {
      return '';
    } else if (number == '1') {
      return 'st';
    } else if (number == '2') {
      return 'nd';
    } else if (number == '3') {
      return 'rd';
    } else {
      return 'th';
    }
  }

  update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          title: Text('Planet: timed test'),
          backgroundColor: colorChapter1Standard,
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return PlanetTimedTestScreenHelp();
                    }));
              },
            ),
          ]),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(color: backgroundColor),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Text(
                        '${planet1.toUpperCase()} is the    ',
                        style: TextStyle(
                            fontSize: 20, color: backgroundHighlightColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: TextFormField(
                        controller: guess1Controller,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 25, color: backgroundHighlightColor),
                        keyboardType: TextInputType.number,
                        // maxLength: 1,
                        onChanged: (text) {
                          update();
                        },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                        ],
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: backgroundHighlightColor)),
                          contentPadding: EdgeInsets.all(5),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        ' ${getNumberEnder(1)}',
                        style: TextStyle(
                            fontSize: 20, color: backgroundHighlightColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Text(
                    'farthest from the sun!',
                    style: TextStyle(
                        fontSize: 20, color: backgroundHighlightColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  child: Text(
                    '(closest = 1, furthest = 8)',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                showError1
                    ? Text(
                        'Guess cannot be empty!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      )
                    : SizedBox(
                        height: 16,
                      ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Text(
                        '${planet2.toUpperCase()} is the    ',
                        style: TextStyle(
                            fontSize: 20, color: backgroundHighlightColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: TextFormField(
                        controller: guess2Controller,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 25, color: backgroundHighlightColor),
                        keyboardType: TextInputType.number,
                        // maxLength: 1,
                        onChanged: (text) {
                          update();
                        },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                        ],
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: backgroundHighlightColor)),
                          contentPadding: EdgeInsets.all(5),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        ' ${getNumberEnder(2)}',
                        style: TextStyle(
                            fontSize: 20, color: backgroundHighlightColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Text(
                    'farthest from the sun!',
                    style: TextStyle(
                        fontSize: 20, color: backgroundHighlightColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                showError2
                    ? Text(
                        'Guess cannot be empty!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      )
                    : SizedBox(
                        height: 16,
                      ),
                SizedBox(height: 10),
                Container(
                  child: Text(
                    '--------------------------',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Text(
                        '${planet3.toUpperCase()} is the    ',
                        style: TextStyle(
                            fontSize: 20, color: backgroundHighlightColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: TextFormField(
                        controller: guess3Controller,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 25, color: backgroundHighlightColor),
                        keyboardType: TextInputType.number,
                        // maxLength: 1,
                        onChanged: (text) {
                          update();
                        },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                        ],
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: backgroundHighlightColor)),
                          contentPadding: EdgeInsets.all(5),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        ' ${getNumberEnder(3)}',
                        style: TextStyle(
                            fontSize: 20, color: backgroundHighlightColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Text(
                    'smallest planet!',
                    style: TextStyle(
                        fontSize: 20, color: backgroundHighlightColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  child: Text(
                    '(smallest = 1, largest = 8)',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                showError3
                    ? Text(
                        'Guess cannot be empty!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      )
                    : SizedBox(
                        height: 16,
                      ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Text(
                        '${planet4.toUpperCase()} is the    ',
                        style: TextStyle(
                            fontSize: 20, color: backgroundHighlightColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: TextFormField(
                        controller: guess4Controller,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 25, color: backgroundHighlightColor),
                        keyboardType: TextInputType.number,
                        // maxLength: 1,
                        onChanged: (text) {
                          update();
                        },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                        ],
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: backgroundHighlightColor)),
                          contentPadding: EdgeInsets.all(5),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        ' ${getNumberEnder(4)}',
                        style: TextStyle(
                            fontSize: 20, color: backgroundHighlightColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Text(
                    'smallest planet!',
                    style: TextStyle(
                        fontSize: 20, color: backgroundHighlightColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                showError4
                    ? Text(
                        'Guess cannot be empty!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      )
                    : SizedBox(
                        height: 16,
                      ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    BasicFlatButton(
                      text: 'Give up',
                      onPressed: () => giveUp(),
                      color: Colors.grey[200]!,
                      padding: 10,
                      fontSize: 24,
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    BasicFlatButton(
                      text: 'Submit',
                      onPressed: () => checkAnswer(),
                      color: colorChapter1Standard,
                      padding: 10,
                      fontSize: 24,
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PlanetTimedTestScreenHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HelpDialog(
      title: 'Planets - Timed Test',
      information: [
        '    Time to recall your story! Hopefully you anchored your story well! Did it start from the sun? '
            'From a burning inferno? \n    If you need to figure out which planet is 5th biggest, just try and remember where '
            'your object for the number 5 appears in your story! For me, that would be a SNAKE floating all alone in the OCEAN '
            '(snake = 5, ocean = Poseidon/Neptune, god of the ocean). The snake is shivering, by the way. It feels very sad '
            'that it\'s all alone out there. Poor little snake. '
      ],
      buttonColor: colorChapter1Standard,
      buttonSplashColor: colorChapter1Darker,
      firstHelpKey: planetTimedTestFirstHelpKey,
    );
  }
}
