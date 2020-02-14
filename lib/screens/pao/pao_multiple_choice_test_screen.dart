import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/pao/pao_data.dart';
import 'package:mem_plus_plus/components/pao/pao_multiple_choice_card.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';

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
  int score = 0;
  int attempts = 0;

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    var prefs = PrefsUpdater();
    prefs.checkFirstTime(context, 'PAOMultipleChoiceTestFirstHelp', PAOMultipleChoiceScreenHelp());
    paoData = await prefs.getSharedPrefs(paoKey);
    paoData = shuffle(paoData);
    setState(() {});
  }

  void callback(BuildContext context, bool success) async {
    if (success) {
      score += 1;
      if (score == 100) {
        // update keys
        PrefsUpdater prefs = PrefsUpdater();
        if (!await prefs.getBool(activityCompleteKey)) {
          await prefs.setBool(activityCompleteKey, true);
          await prefs.updateActivityVisible('PAOTimedTestPrep', true);
          await prefs.updateActivityFirstView('PAOTimedTestPrep', true);
          await prefs.updateActivityState('PAOMultipleChoiceTest', 'review');
          widget.callback();
          showSnackBar(
            scaffoldState: widget.globalKey.currentState,
            snackBarText: 'You aced it! You\'ve unlocked the timed test!',
            textColor: Colors.white,
            backgroundColor: colorPAOStandard,
            durationSeconds: 5,
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
      appBar: AppBar(
          title: Text('Single digit: multiple choice test'),
        backgroundColor: Colors.pink[200],
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
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
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return PAOMultipleChoiceScreenHelp();
                    }));
              },
            ),
          ]),
      body: Center(
          child: ListView(
        children: getPAOMultipleChoiceCards(),
      )),
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
    );
  }
}
