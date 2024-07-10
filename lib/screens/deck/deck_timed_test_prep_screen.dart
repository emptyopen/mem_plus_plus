import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/data/deck_data.dart';
import 'package:mem_plus_plus/components/standard/basic_flat_button.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'dart:math';
import 'package:mem_plus_plus/services/services.dart';
import 'dart:async';
import 'package:mem_plus_plus/screens/templates/help_dialog.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/constants/colors.dart';

import 'package:flutter/services.dart';

class DeckTimedTestPrepScreen extends StatefulWidget {
  final Function() callback;

  DeckTimedTestPrepScreen({required this.callback});

  @override
  _DeckTimedTestPrepScreenState createState() =>
      _DeckTimedTestPrepScreenState();
}

class _DeckTimedTestPrepScreenState extends State<DeckTimedTestPrepScreen> {
  String digits1 = '';
  String digits2 = '';
  String digits3 = '';
  String digits4 = '';
  String digits5 = '';
  String digits6 = '';
  String digits7 = '';
  String digits8 = '';
  String digits9 = '';
  var existingCards = [];
  PrefsUpdater prefs = PrefsUpdater();
  Duration testDuration = debugModeEnabled
      ? Duration(seconds: debugTestTimeSeconds)
      : Duration(hours: 1);
  List<String> possibleValues = [
    'AS',
    '2S',
    '3S',
    '4S',
    '5S',
    '6S',
    '7S',
    '8S',
    '9S',
    '10S',
    'JS',
    'QS',
    'KS',
    'AH',
    '2H',
    '3H',
    '4H',
    '5H',
    '6H',
    '7H',
    '8H',
    '9H',
    '10H',
    'JH',
    'QH',
    'KH',
    'AC',
    '2C',
    '3C',
    '4C',
    '5C',
    '6C',
    '7C',
    '8C',
    '9C',
    '10C',
    'JC',
    'QC',
    'KC',
    'AD',
    '2D',
    '3D',
    '4D',
    '5D',
    '6D',
    '7D',
    '8D',
    '9D',
    '10D',
    'JD',
    'QD',
    'KD',
  ];

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  getSharedPrefs() {
    prefs.checkFirstTime(context, deckTimedTestPrepFirstHelpKey,
        DeckTimedTestPrepScreenHelp(callback: widget.callback));
    if (!prefs.getBool(deckTestActiveKey)) {
      print('no active test, setting new values');
      var random = new Random();

      digits1 = possibleValues[random.nextInt(possibleValues.length)];
      existingCards.add(digits1);
      possibleValues.remove(digits1);
      digits2 = possibleValues[random.nextInt(possibleValues.length)];
      possibleValues.remove(digits2);
      digits3 = possibleValues[random.nextInt(possibleValues.length)];
      possibleValues.remove(digits3);
      digits4 = possibleValues[random.nextInt(possibleValues.length)];
      possibleValues.remove(digits4);
      digits5 = possibleValues[random.nextInt(possibleValues.length)];
      possibleValues.remove(digits5);
      digits6 = possibleValues[random.nextInt(possibleValues.length)];
      possibleValues.remove(digits6);
      digits7 = possibleValues[random.nextInt(possibleValues.length)];
      possibleValues.remove(digits7);
      digits8 = possibleValues[random.nextInt(possibleValues.length)];
      possibleValues.remove(digits8);
      print(possibleValues.length);
      digits9 = possibleValues[random.nextInt(possibleValues.length)];
      possibleValues.remove(digits9);
      prefs.setString('deckTestDigits1', digits1);
      prefs.setString('deckTestDigits2', digits2);
      prefs.setString('deckTestDigits3', digits3);
      prefs.setString('deckTestDigits4', digits4);
      prefs.setString('deckTestDigits5', digits5);
      prefs.setString('deckTestDigits6', digits6);
      prefs.setString('deckTestDigits7', digits7);
      prefs.setString('deckTestDigits8', digits8);
      prefs.setString('deckTestDigits9', digits9);
      prefs.setBool(deckTestActiveKey, true);
    } else {
      print('found active test, restoring values');
      digits1 = (prefs.getString('deckTestDigits1'));
      digits2 = (prefs.getString('deckTestDigits2'));
      digits3 = (prefs.getString('deckTestDigits3'));
      digits4 = (prefs.getString('deckTestDigits4'));
      digits5 = (prefs.getString('deckTestDigits5'));
      digits6 = (prefs.getString('deckTestDigits6'));
      digits7 = (prefs.getString('deckTestDigits7'));
      digits8 = (prefs.getString('deckTestDigits8'));
      digits9 = (prefs.getString('deckTestDigits9'));
    }
    setState(() {});
  }

  updateStatus() {
    prefs.setBool(deckTestActiveKey, false);
    prefs.updateActivityState(deckTimedTestPrepKey, 'review');
    prefs.updateActivityVisible(deckTimedTestPrepKey, false);
    prefs.updateActivityState(deckTimedTestKey, 'todo');
    prefs.updateActivityVisible(deckTimedTestKey, true);
    prefs.updateActivityVisibleAfter(
        deckTimedTestKey, DateTime.now().add(testDuration));
    Timer(testDuration, widget.callback);
    notifyDuration(testDuration, 'Timed test (Deck) is ready!', 'Good luck!',
        deckTimedTestKey);
    widget.callback();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          title: Text('Deck: timed test prep', style: TextStyle(fontSize: 18)),
          backgroundColor: colorDeckStandard,
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return DeckTimedTestPrepScreenHelp(
                          callback: widget.callback);
                    }));
              },
            ),
          ]),
      body: Container(
        decoration: BoxDecoration(color: backgroundColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
                child: Text(
              'Your cards are: ',
              style: TextStyle(fontSize: 34, color: backgroundHighlightColor),
            )),
            SizedBox(
              height: 50,
            ),
            Container(
              width: 150,
              height: 100,
              child: Stack(children: [
                Positioned.fill(
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Transform.rotate(
                        angle: -pi / 20.0,
                        child: getDeckCard(digits1, 'medium'),
                      )),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: getDeckCard(digits2, 'medium'),
                  ),
                  bottom: 7,
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Transform.rotate(
                      angle: pi / 20.0,
                      child: getDeckCard(digits3, 'medium'),
                    ),
                  ),
                  top: 0,
                  right: 0,
                ),
              ]),
            ),
            Container(
              width: 150,
              height: 100,
              child: Stack(children: [
                Positioned.fill(
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Transform.rotate(
                        angle: -pi / 20.0,
                        child: getDeckCard(digits4, 'medium'),
                      )),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: getDeckCard(digits5, 'medium'),
                  ),
                  bottom: 7,
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Transform.rotate(
                      angle: pi / 20.0,
                      child: getDeckCard(digits6, 'medium'),
                    ),
                  ),
                  top: 0,
                  right: 0,
                ),
              ]),
            ),
            Container(
              width: 150,
              height: 100,
              child: Stack(children: [
                Positioned.fill(
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Transform.rotate(
                        angle: -pi / 20.0,
                        child: getDeckCard(digits7, 'medium'),
                      )),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: getDeckCard(digits8, 'medium'),
                  ),
                  bottom: 7,
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Transform.rotate(
                      angle: pi / 20.0,
                      child: getDeckCard(digits9, 'medium'),
                    ),
                  ),
                  top: 0,
                  right: 0,
                ),
              ]),
            ),
            SizedBox(
              height: 50,
            ),
            BasicFlatButton(
              text: 'I\'m ready!',
              color: colorDeckStandard,
              onPressed: () => showConfirmDialog(
                  context: context,
                  function: updateStatus,
                  confirmText:
                      'Are you sure you\'d like to start this test? The cards will no longer be available to view!',
                  confirmColor: colorDeckDarker),
              fontSize: 30,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Text(
                '(You\'ll be quizzed on this in one hour!)',
                style: TextStyle(fontSize: 18, color: backgroundHighlightColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DeckTimedTestPrepScreenHelp extends StatelessWidget {
  final Function callback;
  DeckTimedTestPrepScreenHelp({Key? key, required this.callback})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return HelpDialog(
      title: 'Deck - Timed Test Preparation',
      information: [
        '    OK! Now you\'re going to convert these nine cards into three scenes, and link the scenes together. '
            'Remember, make it visceral - really add as much detail as you can muster!',
      ],
      buttonColor: colorDeckStandard,
      buttonSplashColor: colorDeckDarker,
      firstHelpKey: deckTimedTestPrepFirstHelpKey,
      callback: callback,
    );
  }
}

class TimedTestPrepRowContainer extends StatelessWidget {
  final String digits;
  final Color color;

  TimedTestPrepRowContainer({required this.digits, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.all(Radius.circular(5))),
      padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
      child: Center(
        child: Text(
          digits,
          style: TextStyle(fontSize: 30, fontFamily: 'SpaceMono'),
        ),
      ),
    );
  }
}
