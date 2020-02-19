import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/single_digit/single_digit_data.dart';
import 'package:mem_plus_plus/components/single_digit/single_digit_multiple_choice_card.dart';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/screens/templates/card_test_screen.dart';

class SingleDigitMultipleChoiceTestScreen extends StatefulWidget {
  final Function callback;
  final GlobalKey<ScaffoldState> globalKey;

  SingleDigitMultipleChoiceTestScreen({this.callback, this.globalKey});

  @override
  _SingleDigitMultipleChoiceTestScreenState createState() =>
      _SingleDigitMultipleChoiceTestScreenState();
}

class _SingleDigitMultipleChoiceTestScreenState
    extends State<SingleDigitMultipleChoiceTestScreen> {
  List<SingleDigitData> singleDigitData;
  List<bool> results = List.filled(10, null);
  int score = 0;
  int attempts = 0;
  var prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    prefs.checkFirstTime(context, singleDigitMultipleChoiceFirstHelpKey,
        SingleDigitMultipleChoiceScreenHelp());
    singleDigitData = await prefs.getSharedPrefs(singleDigitKey);
    singleDigitData = shuffle(singleDigitData);
    setState(() {});
  }

  void callback(BuildContext context, bool success) async {
    if (success) {
      results[attempts] = true;
      score += 1;
      if (score == 10) {
        // update keys
        PrefsUpdater prefs = PrefsUpdater();
        if (await prefs.getBool(activityCompleteKey) == null) {
          await prefs.setBool(activityCompleteKey, true);
          await prefs.updateActivityVisible('SingleDigitTimedTestPrep', true);
          await prefs.updateActivityState(
              'SingleDigitMultipleChoiceTest', 'review');
          widget.callback();
          showSnackBar(
            scaffoldState: widget.globalKey.currentState,
            snackBarText: 'You aced it! You\'ve unlocked the timed test!',
            backgroundColor: colorSingleDigitDarker,
            durationSeconds: 4,
          );
          Navigator.pop(context);
        } else {
          showSnackBar(
            scaffoldState: widget.globalKey.currentState,
            snackBarText: 'You aced it!',
            backgroundColor: colorCorrect,
            durationSeconds: 3,
          );
          Navigator.pop(context);
        }
      }
    } else {
      results[attempts] = false;
    }
    attempts += 1;

    if (attempts == 10 && score < 10) {
      showSnackBar(
        scaffoldState: widget.globalKey.currentState,
        snackBarText: 'Try again! You got this. Score: $score/10',
        backgroundColor: colorIncorrect,
        durationSeconds: 4,
      );
      Navigator.pop(context);
    }
    setState(() {});
  }

  List<SingleDigitMultipleChoiceCard> getSingleDigitMultipleChoiceCards() {
    List<SingleDigitMultipleChoiceCard> singleDigitMultipleChoiceCards = [];
    if (singleDigitData != null) {
      for (int i = 0; i < singleDigitData.length; i++) {
        SingleDigitMultipleChoiceCard singleDigitView =
            SingleDigitMultipleChoiceCard(
          singleDigitData: SingleDigitData(
              singleDigitData[i].index,
              singleDigitData[i].digits,
              singleDigitData[i].object,
              singleDigitData[i].familiarity),
          callback: callback,
        );
        singleDigitMultipleChoiceCards.add(singleDigitView);
      }
    }
    return singleDigitMultipleChoiceCards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: backgroundColor,
      appBar: AppBar(
          title: Text('Single digit: multiple choice test'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              score = 0;
              attempts = 0;
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.amber[200],
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return SingleDigitMultipleChoiceScreenHelp();
                    }));
              },
            ),
          ]),
      body: CardTestScreen(
        cards: getSingleDigitMultipleChoiceCards(),
        results: results,
      ),
    );
  }
}

class SingleDigitMultipleChoiceScreenHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'Single Digit Multiple Choice Test',
      information: [
        '    Welcome to your first multiple choice test! In this section, you will be tested on your familiarity with '
            'each digit. \n    Every time you load this page, the digits and objects will be scattered in a random order, '
            'and you simply have to choose the correct digit or object. If you get a perfect score, the next test will be unlocked! '
            '\n    Good luck!'
      ],
      buttonColor: Colors.amber[100],
      buttonSplashColor: Colors.amber[300],
      firstHelpKey: singleDigitMultipleChoiceFirstHelpKey,
    );
  }
}
