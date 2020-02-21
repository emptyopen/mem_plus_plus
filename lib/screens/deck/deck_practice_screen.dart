import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/deck/deck_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/components/templates/flash_card.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/screens/templates/card_test_screen.dart';

class DeckPracticeScreen extends StatefulWidget {
  final Function() callback;
  final GlobalKey<ScaffoldState> globalKey;

  DeckPracticeScreen({this.callback, this.globalKey});

  @override
  _DeckPracticeScreenState createState() => _DeckPracticeScreenState();
}

class _DeckPracticeScreenState extends State<DeckPracticeScreen> {
  SharedPreferences sharedPreferences;
  List<DeckData> deckData;
  List<bool> results = List.filled(100, null);
  List<bool> tempResults = [];
  int attempts = 0;
  var prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    deckData = await prefs.getSharedPrefs(deckKey);
    deckData = shuffle(deckData);
    setState(() {});
  }

  callback(bool success) {
    if (success) {
      results[attempts] = true;
    } else {
      results[attempts] = false;
    }
    attempts += 1;
    widget.callback();
    setState(() {});
  }

  void nextActivity() async {
    await prefs.updateActivityState(deckPracticeKey, 'review');
    await prefs.updateActivityVisible(deckMultipleChoiceTestKey, true);
    widget.callback();
  }

  List<FlashCard> getDeckFlashCards() {
    List<FlashCard> deckFlashCards = [];
    if (deckData != null) {
      bool allComplete = true;
      for (int i = 0; i < deckData.length; i++) {
        if (deckData[i].familiarity < 100) {
          allComplete = false;
        }
      }
      for (int i = 0; i < deckData.length; i++) {
        if (deckData[i].familiarity < 100 || allComplete) {
          FlashCard deckFlashCard = FlashCard(
            entry: deckData[i],
            callback: callback,
            globalKey: widget.globalKey,
            activityKey: deckKey,
            nextActivityCallback: nextActivity,
            familiarityTotal: 5200,
            color: colorDeckDarker,
            lighterColor: colorDeckLighter,
          );
          deckFlashCards.add(deckFlashCard);
        }
      }
    }
    setState(() {
      tempResults = results.sublist(0, deckFlashCards.length);
    });
    return deckFlashCards;
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
          backgroundColor: backgroundColor,
        appBar: AppBar(
            title: Text('Deck: practice'),
            backgroundColor: colorDeckStandard,
            actions: <Widget>[
              // action button
              IconButton(
                icon: Icon(Icons.info),
                onPressed: () {
                  Navigator.of(context).push(PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (BuildContext context, _, __) {
                        return DeckPracticeScreenHelp();
                      }));
                },
              ),
            ]),
        body: CardTestScreen(
          cards: getDeckFlashCards(),
          results: tempResults,
        ));
  }
}

class DeckPracticeScreenHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'Deck Practice',
      information: [
        '    Get perfect familiarities for each card and '
            'the first test will be unlocked! Good luck!'
      ],
      buttonColor: colorDeckStandard,
      buttonSplashColor: colorDeckDarker,
      firstHelpKey: deckPracticeFirstHelpKey,
    );
  }
}
