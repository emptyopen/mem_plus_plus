import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/alphabet/alphabet_data.dart';
import 'package:mem_plus_plus/components/alphabet/alphabet_written_card.dart';
import 'dart:convert';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/screens/templates/card_test_screen.dart';

class AlphabetWrittenTestScreen extends StatefulWidget {
  final Function callback;
  final GlobalKey<ScaffoldState> globalKey;

  AlphabetWrittenTestScreen({this.callback, this.globalKey});

  @override
  _AlphabetWrittenTestScreenState createState() =>
      _AlphabetWrittenTestScreenState();
}

class _AlphabetWrittenTestScreenState extends State<AlphabetWrittenTestScreen> {
  List<AlphabetData> alphabetData;
  List<bool> results = List.filled(26, null);
  int score = 0;
  int attempts = 0;

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    var prefs = PrefsUpdater();
    prefs.checkFirstTime(
        context, alphabetWrittenFirstHelpKey, AlphabetWrittenTestScreenHelp());
    alphabetData = (json.decode(await prefs.getString(alphabetKey)) as List)
        .map((i) => AlphabetData.fromJson(i))
        .toList();
    alphabetData = shuffle(alphabetData);
    setState(() {});
  }

  void callback(BuildContext context, bool success) async {
    if (success) {
      score += 1;
      results[attempts] = true;
      if (score == 26) {
        // update keys
        PrefsUpdater prefs = PrefsUpdater();
        if (await prefs.getBool('AlphabetWrittenTestComplete') == null) {
          await prefs.updateActivityVisible('AlphabetTimedTestPrep', true);
          await prefs.updateActivityFirstView('AlphabetTimedTestPrep', true);
          await prefs.updateActivityState('AlphabetWrittenTest', 'review');
          await prefs.setBool('AlphabetWrittenTestComplete', true);
          widget.callback();
          showSnackBar(
            scaffoldState: widget.globalKey.currentState,
            snackBarText: 'You aced it! You\'ve unlocked the timed test!',
            textColor: Colors.black,
            backgroundColor: colorAlphabetDarker,
            durationSeconds: 5,
          );
          Navigator.pop(context);
        } else {
          showSnackBar(
            scaffoldState: widget.globalKey.currentState,
            snackBarText: 'You aced it!',
            textColor: Colors.black,
            backgroundColor: colorAlphabetStandard,
            durationSeconds: 3,
          );
          Navigator.pop(context);
        }
      }
    } else {
      results[attempts] = false;
    }
    attempts += 1;

    if (attempts == 26 && score < 26) {
      showSnackBar(
        scaffoldState: widget.globalKey.currentState,
        snackBarText: 'Try again! You got this. Score: $score/26',
        textColor: Colors.black,
        backgroundColor: colorIncorrect,
        durationSeconds: 4,
      );
      Navigator.pop(context);
    }
    setState(() {});
  }

  List<AlphabetWrittenCard> getAlphabetWrittenCards() {
    List<AlphabetWrittenCard> alphabetWrittenCards = [];
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
        alphabetWrittenCards.add(alphabetView);
      }
    }
    return alphabetWrittenCards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Alphabet: written test'),
            backgroundColor: Colors.blue[200],
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
        body: CardTestScreen(
          getCards: getAlphabetWrittenCards,
          results: results,
          numCards: 26,
        ));
  }
}

class AlphabetWrittenTestScreenHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'Alphabet Written Test',
      information: [
        '    Welcome to your first written test! In this section, you will be tested on your familiarity with '
            'each letter. Every time you load this page, the letters will be scattered in a random order, '
            'and you simply have to write in the correct object. If you get a perfect score, '
            'the next test will be unlocked! Good luck!'
      ],
      buttonColor: Colors.blue[100],
      buttonSplashColor: Colors.blue[300],
      firstHelpKey: alphabetWrittenFirstHelpKey,
    );
  }
}
