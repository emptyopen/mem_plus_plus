import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/single_digit/single_digit_data.dart';
import 'package:mem_plus_plus/components/single_digit/single_digit_multiple_choice_card.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:mem_plus_plus/services/services.dart';

class SingleDigitMultipleChoiceTestScreen extends StatefulWidget {
  final Function() callback;

  SingleDigitMultipleChoiceTestScreen({this.callback});

  @override
  _SingleDigitMultipleChoiceTestScreenState createState() =>
      _SingleDigitMultipleChoiceTestScreenState();
}

class _SingleDigitMultipleChoiceTestScreenState
    extends State<SingleDigitMultipleChoiceTestScreen> {
  List<SingleDigitData> singleDigitData;
  String singleDigitKey = 'SingleDigit';
  String activityCompleteKey = 'SingleDigitMultipleChoiceTestComplete';
  int score = 0;
  int attempts = 0;

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    var prefs = PrefsUpdater();
    singleDigitData = await prefs.getSharedPrefs(singleDigitKey);
    singleDigitData = shuffle(singleDigitData);
    setState(() {});
  }

  void callback(BuildContext context, bool success) async {
    if (success) {
      score += 1;
      if (score == 10) {
        // update keys
        PrefsUpdater prefs = PrefsUpdater();
        if (await prefs.getBool(activityCompleteKey) == null) {
          await prefs.setBool(activityCompleteKey, true);
          await prefs.updateActivityVisible('SingleDigitTimedTestPrep', true);
          await prefs.updateActivityFirstView('SingleDigitTimedTestPrep', true);
          await prefs.updateActivityState(
              'SingleDigitMultipleChoiceTest', 'review');
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

    if (attempts == 10 && score < 10) {
      final snackBar = SnackBar(
        content: Text(
          'Try again! You got this. Score: $score/10',
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

  List<SingleDigitMultipleChoiceCard> getSingleDigitMultipleChoiceCards() {
    List<SingleDigitMultipleChoiceCard> singleDigitMultipleChoiceCards = [];
    if (singleDigitData != null) {
      for (int i = 0; i < singleDigitData.length; i++) {
        SingleDigitMultipleChoiceCard singleDigitView =
            SingleDigitMultipleChoiceCard(
          singleDigitData: SingleDigitData(singleDigitData[i].index, singleDigitData[i].digits,
              singleDigitData[i].object, singleDigitData[i].familiarity),
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
                      return SingleDigitMultipleChoiceScreenHelp();
                    }));
              },
            ),
          ]),
      body: Center(
          child: ListView(
        children: getSingleDigitMultipleChoiceCards(),
      )),
    );
  }
}

class SingleDigitMultipleChoiceScreenHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
        color: Color.fromRGBO(0, 0, 0, 0.7),
        child: Stack(
          children: <Widget>[
            Container(
              color: Colors.transparent,
              constraints: BoxConstraints.expand(),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 350,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                      child: Text(
                        '    Welcome to your first multiple choice test! \n\n'
                        '    In this section, you will be tested on your familiarity with '
                        'each digit. Every time you load this page, the digits will be scattered in a random order, '
                        'and you simply have to choose the correct object. If you get a perfect score, '
                        'the next test will be unlocked! Good luck!',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  PopButton(
                    widget: Text('OK'),
                    color: Colors.amber[300],
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
