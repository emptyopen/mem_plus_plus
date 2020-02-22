import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/deck/deck_data.dart';
import 'package:mem_plus_plus/components/deck/deck_multiple_choice_card.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/screens/templates/card_test_screen.dart';
import 'package:flutter/services.dart';

class DeckMultipleChoiceTestScreen extends StatefulWidget {
  final Function callback;
  final GlobalKey<ScaffoldState> globalKey;

  DeckMultipleChoiceTestScreen({this.callback, this.globalKey});

  @override
  _DeckMultipleChoiceTestScreenState createState() =>
      _DeckMultipleChoiceTestScreenState();
}

class _DeckMultipleChoiceTestScreenState
    extends State<DeckMultipleChoiceTestScreen> {
  List<DeckData> deckData;
  List<bool> results = List.filled(52, null);
  int score = 0;
  int attempts = 0;
  PrefsUpdater prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    prefs.checkFirstTime(context, deckMultipleChoiceTestFirstHelpKey, DeckMultipleChoiceScreenHelp());
    deckData = await prefs.getSharedPrefs(deckKey);
    deckData = shuffle(deckData);
    setState(() {});
  }

  void callback(BuildContext context, bool success) async {
    if (success) {
      score += 1;
      results[attempts] = true;
      if (score == 52 || (debugModeEnabled && score >= 5)) {
        // update keys
        if (await prefs.getActivityState(deckMultipleChoiceTestKey) == 'todo') {
          await prefs.updateActivityState(deckMultipleChoiceTestKey, 'review');
          await prefs.updateActivityVisible(deckTimedTestPrepKey, true);
          widget.callback();
          showSnackBar(
            scaffoldState: widget.globalKey.currentState,
            snackBarText: 'You aced it! You\'ve unlocked the timed test!',
            textColor: Colors.black,
            backgroundColor: colorDeckStandard,
            durationSeconds: 4,
          );
          Navigator.pop(context);
        } else {
          showSnackBar(
            scaffoldState: widget.globalKey.currentState,
            snackBarText: 'You aced it!',
            textColor: Colors.black,
            backgroundColor: colorDeckStandard,
            durationSeconds: 3,
          );
          Navigator.pop(context);
        }
      }
    } else {
      results[attempts] = false;
    }
    attempts += 1;

    if (attempts == 52 && score < 52) {
      showSnackBar(
        scaffoldState: widget.globalKey.currentState,
        snackBarText: 'Try again! You got this. Score: $score/52',
        textColor: Colors.black,
        backgroundColor: colorIncorrect,
        durationSeconds: 2,
      );
      Navigator.pop(context);
    }
    setState(() {});
  }

  List<DeckMultipleChoiceCard> getDeckMultipleChoiceCards() {
    List<DeckMultipleChoiceCard> deckMultipleChoiceCards = [];
    if (deckData != null) {
      for (int i = 0; i < deckData.length; i++) {
        DeckMultipleChoiceCard deckView = DeckMultipleChoiceCard(
          deckData: DeckData(deckData[i].index, deckData[i].digitSuit, deckData[i].person,
              deckData[i].action, deckData[i].object, deckData[i].familiarity),
          callback: callback,
        );
        deckMultipleChoiceCards.add(deckView);
      }
    }
    return deckMultipleChoiceCards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: backgroundColor,
      appBar: AppBar(
          title: Text('Deck: multiple choice test'),
        backgroundColor: colorDeckStandard,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
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
                      return DeckMultipleChoiceScreenHelp();
                    }));
              },
            ),
          ]),
          body: CardTestScreen(
        cards: getDeckMultipleChoiceCards(),
        results: results,
      ),
    );
  }
}

class DeckMultipleChoiceScreenHelp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'Deck Multiple Choice Test',
      information: ['    Alright! Time for a test on your Deck system. If you get a perfect score, '
        'the next test will be unlocked! Good luck!'],
      buttonColor: colorDeckStandard,
      buttonSplashColor: colorDeckDarker,
      firstHelpKey: deckMultipleChoiceTestFirstHelpKey,
    );
  }
}
