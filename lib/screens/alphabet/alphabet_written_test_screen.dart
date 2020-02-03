import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/alphabet/alphabet_data.dart';
import 'package:mem_plus_plus/components/alphabet/alphabet_written_card.dart';
import 'dart:convert';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/components/templates/help_screen.dart';

class AlphabetMultipleChoiceTestScreen extends StatefulWidget {
  final Function() callback;

  AlphabetMultipleChoiceTestScreen({this.callback});

  @override
  _AlphabetMultipleChoiceTestScreenState createState() =>
      _AlphabetMultipleChoiceTestScreenState();
}

class _AlphabetMultipleChoiceTestScreenState
    extends State<AlphabetMultipleChoiceTestScreen> {
  List<AlphabetData> alphabetData;
  String alphabetKey = 'Alphabet';
  int score = 0;
  int attempts = 0;

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    var prefs = PrefsUpdater();
    prefs.checkFirstTime(context, 'AlphabetWrittenTestFirstHelp', AlphabetWrittenTestScreenHelp());
    alphabetData = (json.decode(await prefs.getString(alphabetKey)) as List)
        .map((i) => AlphabetData.fromJson(i))
        .toList();
    alphabetData = shuffle(alphabetData);
    setState(() {});
  }

  void callback(BuildContext context, bool success) async {
    if (success) {
      score += 1;
      if (score == 26) {
        // update keys
        PrefsUpdater prefs = PrefsUpdater();
        if (await prefs.getBool('AlphabetWrittenTestComplete') == null) {
          await prefs.updateActivityVisible('AlphabetTimedTestPrep', true);
          await prefs.updateActivityFirstView('AlphabetTimedTestPrep', true);
          await prefs.updateActivityState('AlphabetWrittenTest', 'review');
          await prefs.setBool('AlphabetWrittenTestComplete', true);
          widget.callback();
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

    if (attempts == 26 && score < 26) {
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

  List<AlphabetWrittenCard> getAlphabetMultipleChoiceCards() {
    List<AlphabetWrittenCard> alphabetMultipleChoiceCards = [];
    if (alphabetData != null) {
      for (int i = 0; i < alphabetData.length; i++) {
        AlphabetWrittenCard alphabetView = AlphabetWrittenCard(
          alphabetData: AlphabetData(
              alphabetData[i].index,
              alphabetData[i].letter,
              alphabetData[i].object,
              alphabetData[i].familiarity),
          callback: callback,
        );
        alphabetMultipleChoiceCards.add(alphabetView);
      }
    }
    return alphabetMultipleChoiceCards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Alphabet: multiple choice test'),
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return AlphabetWrittenTestScreenHelp();
                    }));
              },
            ),
          ]),
      body: Center(
          child: ListView(
        children: getAlphabetMultipleChoiceCards(),
      )),
    );
  }
}

class AlphabetWrittenTestScreenHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      information: ['    Welcome to your first written test! In this section, you will be tested on your familiarity with '
        'each letter. Every time you load this page, the letters will be scattered in a random order, '
        'and you simply have to write in the correct object. If you get a perfect score, '
        'the next test will be unlocked! Good luck!'],
    );
  }
}
