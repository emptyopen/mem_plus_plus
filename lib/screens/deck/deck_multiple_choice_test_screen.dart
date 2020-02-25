import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/deck/deck_data.dart';
import 'package:mem_plus_plus/components/deck/deck_multiple_choice_card.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/screens/templates/card_test_screen.dart';
import 'package:flutter/services.dart';
import 'dart:math';

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
  List<DeckData> deckData = [];
  List fakeData = [];
  List<Widget> deckCards = [];
  bool dataReady = false;
  List<DeckData> shuffledChoices = [
    DeckData(0, '0', 'nothing', 'nothing', 'nothing', 0),
    DeckData(1, '0', 'nothing', 'nothing', 'nothing', 0),
    DeckData(2, '0', 'nothing', 'nothing', 'nothing', 0),
    DeckData(3, '0', 'nothing', 'nothing', 'nothing', 0),
  ];
  int isDigitToObject = 0; // 0 == digitToObject, 1 == objectToDigit
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

    deckData.forEach((entry) {
      DeckData fakeSingleDigitChoice1;
      DeckData fakeSingleDigitChoice2;
      DeckData fakeSingleDigitChoice3;
      // randomly choose either digit -> object or object -> digit
      isDigitToObject = Random().nextInt(2);
      if (isDigitToObject == 0) {
        // loop until you find 3 random different objects
        List<String> notAllowed = [entry.object];
        while (fakeSingleDigitChoice1 == null) {
          DeckData candidate =
              deckData[Random().nextInt(deckData.length)];
          if (!notAllowed.contains(candidate.object)) {
            fakeSingleDigitChoice1 = candidate;
            notAllowed.add(candidate.object);
          }
        }
        while (fakeSingleDigitChoice2 == null) {
          DeckData candidate =
              deckData[Random().nextInt(deckData.length)];
          if (!notAllowed.contains(candidate.object)) {
            fakeSingleDigitChoice2 = candidate;
            notAllowed.add(candidate.object);
          }
        }
        while (fakeSingleDigitChoice3 == null) {
          DeckData candidate =
              deckData[Random().nextInt(deckData.length)];
          if (!notAllowed.contains(candidate.object)) {
            fakeSingleDigitChoice3 = candidate;
            notAllowed.add(candidate.object);
          }
        }
      } else {
        // loop until you find 3 random different digits
        List<String> notAllowed = [entry.digitSuit];
        while (fakeSingleDigitChoice1 == null) {
          DeckData candidate =
              deckData[Random().nextInt(deckData.length)];
          if (!notAllowed.contains(candidate.digitSuit)) {
            fakeSingleDigitChoice1 = candidate;
            notAllowed.add(candidate.digitSuit);
          }
        }
        while (fakeSingleDigitChoice2 == null) {
          DeckData candidate =
              deckData[Random().nextInt(deckData.length)];
          if (!notAllowed.contains(candidate.digitSuit)) {
            fakeSingleDigitChoice2 = candidate;
            notAllowed.add(candidate.digitSuit);
          }
        }
        while (fakeSingleDigitChoice3 == null) {
          DeckData candidate =
              deckData[Random().nextInt(deckData.length)];
          if (!notAllowed.contains(candidate.digitSuit)) {
            fakeSingleDigitChoice3 = candidate;
            notAllowed.add(candidate.digitSuit);
          }
        }
      }
      shuffledChoices = [
        entry,
        fakeSingleDigitChoice1,
        fakeSingleDigitChoice2,
        fakeSingleDigitChoice3,
      ];
      shuffledChoices = shuffle(shuffledChoices);
      fakeData.add(shuffledChoices);
    });

    dataReady = true;
    setState(() {});
  }

  void nextActivity() async {
    if (await prefs.getActivityState(deckMultipleChoiceTestKey) ==
        'todo') {
      await prefs.updateActivityState(
          deckMultipleChoiceTestKey, 'review');
      await prefs.updateActivityVisible(deckTimedTestPrepKey, true);
    }
    widget.callback();
  }

  callback() {
    widget.callback();
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
          body: dataReady
          ? CardTestScreen(
              cardData: deckData,
              cardType: 'MultipleChoiceCard',
              globalKey: widget.globalKey,
              nextActivity: nextActivity,
              systemKey: deckKey,
              color: colorDeckStandard,
              lighterColor: colorDeckLighter,
              familiarityTotal: 5200,
              shuffledChoices: fakeData,
            )
          : Container(),
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
