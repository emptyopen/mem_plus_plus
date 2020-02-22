import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/pao/pao_data.dart';
import 'package:mem_plus_plus/components/pao/pao_multiple_choice_card.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/screens/templates/card_test_screen.dart';
import 'package:flutter/services.dart';

class PAOMultipleChoiceTestScreen extends StatefulWidget {
  final Function callback;
  final GlobalKey<ScaffoldState> globalKey;

  PAOMultipleChoiceTestScreen({this.callback, this.globalKey});

  @override
  _PAOMultipleChoiceTestScreenState createState() =>
      _PAOMultipleChoiceTestScreenState();
}

class _PAOMultipleChoiceTestScreenState
    extends State<PAOMultipleChoiceTestScreen> {
  List<PAOData> paoData;
  List<bool> results = List.filled(100, null);
  int score = 0;
  int attempts = 0;
  PrefsUpdater prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    prefs.checkFirstTime(context, paoMultipleChoiceTestFirstHelpKey, PAOMultipleChoiceScreenHelp());
    paoData = await prefs.getSharedPrefs(paoKey);
    paoData = shuffle(paoData);
    setState(() {});
  }

  void callback(BuildContext context, bool success) async {
    if (success) {
      score += 1;
      results[attempts] = true;
      if (score == 100) {
        // update keys
        if (await prefs.getBool(paoMultipleChoiceTestCompleteKey) == null) {
          await prefs.setBool(paoMultipleChoiceTestCompleteKey, true);
          await prefs.updateActivityVisible(paoTimedTestPrepKey, true);
          await prefs.updateActivityState(paoMultipleChoiceTestKey, 'review');
          widget.callback();
          showSnackBar(
            scaffoldState: widget.globalKey.currentState,
            snackBarText: 'You aced it! You\'ve unlocked the timed test!',
            textColor: Colors.white,
            backgroundColor: colorPAOStandard,
            durationSeconds: 4,
          );
          Navigator.pop(context);
        } else {
          showSnackBar(
            scaffoldState: widget.globalKey.currentState,
            snackBarText: 'You aced it!',
            textColor: Colors.white,
            backgroundColor: colorPAOStandard,
            durationSeconds: 3,
          );
          Navigator.pop(context);
        }
      }
    } else {
      results[attempts] = false;
    }
    attempts += 1;

    if (attempts == 100 && score < 100) {
      showSnackBar(
        scaffoldState: widget.globalKey.currentState,
        snackBarText: 'Try again! You got this. Score: $score/100',
        textColor: Colors.white,
        backgroundColor: colorIncorrect,
        durationSeconds: 5,
      );
      Navigator.pop(context);
    }
    setState(() {});
  }

  List<PAOMultipleChoiceCard> getPAOMultipleChoiceCards() {
    List<PAOMultipleChoiceCard> paoMultipleChoiceCards = [];
    if (paoData != null) {
      for (int i = 0; i < paoData.length; i++) {
        PAOMultipleChoiceCard paoView = PAOMultipleChoiceCard(
          paoData: PAOData(paoData[i].index, paoData[i].digits, paoData[i].person,
              paoData[i].action, paoData[i].object, paoData[i].familiarity),
          callback: callback,
        );
        paoMultipleChoiceCards.add(paoView);
      }
    }
    return paoMultipleChoiceCards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: backgroundColor,
      appBar: AppBar(
          title: Text('Single digit: multiple choice test'),
        backgroundColor: Colors.pink[200],
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              HapticFeedback.heavyImpact();
              score = 0;
              attempts = 0;
              Navigator.of(context).pop();
            },
          ),
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                HapticFeedback.heavyImpact();
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return PAOMultipleChoiceScreenHelp();
                    }));
              },
            ),
          ]),
          body: CardTestScreen(
        cards: getPAOMultipleChoiceCards(),
        results: results,
      ),
    );
  }
}

class PAOMultipleChoiceScreenHelp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'PAO Multiple Choice Test',
      information: ['    Alright! Time for a test on your PAO system. If you get a perfect score, '
        'the next test will be unlocked! Good luck!'],
      buttonColor: Colors.pink[100],
      buttonSplashColor: Colors.pink[300],
      firstHelpKey: paoMultipleChoiceTestFirstHelpKey,
    );
  }
}
