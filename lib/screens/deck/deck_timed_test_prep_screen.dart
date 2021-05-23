import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/data/deck_data.dart';
import 'dart:math';
import 'package:mem_plus_plus/services/services.dart';
import 'dart:async';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:flutter/services.dart';

class DeckTimedTestPrepScreen extends StatefulWidget {
  final Function() callback;

  DeckTimedTestPrepScreen({this.callback});

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
  Duration testDuration =
      debugModeEnabled ? Duration(seconds: debugTestTime) : Duration(hours: 1);
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

  Future<Null> getSharedPrefs() async {
    var prefs = PrefsUpdater();
    prefs.checkFirstTime(
        context, deckTimedTestPrepFirstHelpKey, DeckTimedTestPrepScreenHelp());
    bool sdTestIsActive = await prefs.getBool(deckTestActiveKey);
    if (sdTestIsActive == null || !sdTestIsActive) {
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
      await prefs.setString('deckTestDigits1', digits1);
      await prefs.setString('deckTestDigits2', digits2);
      await prefs.setString('deckTestDigits3', digits3);
      await prefs.setString('deckTestDigits4', digits4);
      await prefs.setString('deckTestDigits5', digits5);
      await prefs.setString('deckTestDigits6', digits6);
      await prefs.setString('deckTestDigits7', digits7);
      await prefs.setString('deckTestDigits8', digits8);
      await prefs.setString('deckTestDigits9', digits9);
      await prefs.setBool(deckTestActiveKey, true);
    } else {
      print('found active test, restoring values');
      digits1 = await prefs.getString('deckTestDigits1');
      digits2 = await prefs.getString('deckTestDigits2');
      digits3 = await prefs.getString('deckTestDigits3');
      digits4 = await prefs.getString('deckTestDigits4');
      digits5 = await prefs.getString('deckTestDigits5');
      digits6 = await prefs.getString('deckTestDigits6');
      digits7 = await prefs.getString('deckTestDigits7');
      digits8 = await prefs.getString('deckTestDigits8');
      digits9 = await prefs.getString('deckTestDigits9');
    }
    setState(() {});
  }

  void updateStatus() async {
    await prefs.setBool(deckTestActiveKey, false);
    await prefs.updateActivityState(deckTimedTestPrepKey, 'review');
    await prefs.updateActivityVisible(deckTimedTestPrepKey, false);
    await prefs.updateActivityState(deckTimedTestKey, 'todo');
    await prefs.updateActivityVisible(deckTimedTestKey, true);
    await prefs.updateActivityVisibleAfter(
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
          title: Text('Deck: timed test prep'),
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
                      return DeckTimedTestPrepScreenHelp();
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
              splashColor: colorDeckDarker,
              onPressed: () => showConfirmDialog(
                  context: context,
                  function: updateStatus,
                  confirmText:
                      'Are you sure you\'d like to start this test? The cards will no longer be available to view!',
                  confirmColor: colorDeckDarker),
              fontSize: 30,
              padding: 10,
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
  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'Deck Timed Test Preparation',
      information: [
        '    OK! Now you\'re going to convert these nine cards into three scenes, and link the scenes together. '
            'Remember, make it visceral - really add as much detail as you can muster!',
      ],
      buttonColor: colorDeckStandard,
      buttonSplashColor: colorDeckDarker,
      firstHelpKey: deckTimedTestPrepFirstHelpKey,
    );
  }
}

class TimedTestPrepRowContainer extends StatelessWidget {
  final String digits;
  final Color color;

  TimedTestPrepRowContainer({this.digits, this.color});

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
