import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/pao/pao_data.dart';
import 'package:mem_plus_plus/components/pao/pao_multiple_choice_card.dart';
import 'dart:convert';
import 'dart:math';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/components/templates/help_screen.dart';

class PAOMultipleChoiceTestScreen extends StatefulWidget {
  final Function() callback;

  PAOMultipleChoiceTestScreen({this.callback});

  @override
  _PAOMultipleChoiceTestScreenState createState() =>
      _PAOMultipleChoiceTestScreenState();
}

class _PAOMultipleChoiceTestScreenState
    extends State<PAOMultipleChoiceTestScreen> {
  List<PAOData> paoData;
  String paoKey = 'PAO';
  String activityCompleteKey = 'PAOMultipleChoiceTestComplete';
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
    paoData = (json.decode(await prefs.getString(paoKey)) as List)
        .map((i) => PAOData.fromJson(i))
        .toList();
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
          // Snackbar
          final snackBar = SnackBar(
            content: Text(
              'You aced it! Head to the main menu to see what you\'ve unlocked!',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            duration: Duration(seconds: 10),
            backgroundColor: Colors.black,
          );
          Scaffold.of(context).showSnackBar(snackBar);
        } else {
          final snackBar = SnackBar(
            content: Text(
              'You aced it!',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            duration: Duration(seconds: 10),
            backgroundColor: Colors.black,
          );
          Scaffold.of(context).showSnackBar(snackBar);
        }
      }
    }
    attempts += 1;

    if (attempts == 100 && score < 100) {
      final snackBar = SnackBar(
        content: Text(
          'Try again! You got this. Score: $score/100',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        // TODO: add action here for quick redo
        duration: Duration(seconds: 10),
        backgroundColor: Colors.red[200],
      );
      Scaffold.of(context).showSnackBar(snackBar);
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

  List shuffle(List items) {
    var random = new Random();
    for (var i = items.length - 1; i > 0; i--) {
      var n = random.nextInt(i + 1);
      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Single digit: multiple choice test'),
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
      information: ['    Alright! Time for a test on your PAO system. If you get a perfect score, '
        'the next test will be unlocked! Good luck!'],
    );
  }
}
