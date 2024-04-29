import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/data/deck_data.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_dialog.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/screens/templates/card_test_screen.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class DeckMultipleChoiceTestScreen extends StatefulWidget {
  final Function callback;
  final GlobalKey<ScaffoldState> globalKey;

  DeckMultipleChoiceTestScreen(
      {required this.callback, required this.globalKey});

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
  late List<DeckData> shuffledChoices;
  PrefsUpdater prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    prefs.checkFirstTime(context, deckMultipleChoiceTestFirstHelpKey,
        DeckMultipleChoiceScreenHelp());
    deckData = prefs.getSharedPrefs(deckKey) as List<DeckData>;
    deckData = shuffle(deckData) as List<DeckData>;

    deckData.forEach((entry) {
      DeckData? fakeChoice1;
      DeckData? fakeChoice2;
      DeckData? fakeChoice3;

      List<int> notAllowed = [entry.index];
      while (fakeChoice1 == null) {
        DeckData candidate = deckData[Random().nextInt(deckData.length)];
        if (!notAllowed.contains(candidate.index)) {
          fakeChoice1 = candidate;
          notAllowed.add(candidate.index);
        }
      }
      while (fakeChoice2 == null) {
        DeckData candidate = deckData[Random().nextInt(deckData.length)];
        if (!notAllowed.contains(candidate.index)) {
          fakeChoice2 = candidate;
          notAllowed.add(candidate.index);
        }
      }
      while (fakeChoice3 == null) {
        DeckData candidate = deckData[Random().nextInt(deckData.length)];
        if (!notAllowed.contains(candidate.index)) {
          fakeChoice3 = candidate;
          notAllowed.add(candidate.index);
        }
      }

      shuffledChoices = [
        entry,
        fakeChoice1,
        fakeChoice2,
        fakeChoice3,
      ];
      shuffledChoices = shuffle(shuffledChoices) as List<DeckData>;
      fakeData.add(shuffledChoices);
    });

    dataReady = true;
    setState(() {});
  }

  void nextActivity() async {
    if (prefs.getActivityState(deckMultipleChoiceTestKey) == 'todo') {
      prefs.updateActivityState(deckMultipleChoiceTestKey, 'review');
      prefs.updateActivityVisible(deckTimedTestPrepKey, true);
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
              HapticFeedback.lightImpact();
              Navigator.of(context).pop();
            },
          ),
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                HapticFeedback.lightImpact();
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
    return HelpDialog(
      title: 'Deck - Multiple Choice Test',
      information: [
        '    Alright! Time for a test on your Deck system. If you get a perfect score, '
            'the next test will be unlocked! Good luck!'
      ],
      buttonColor: colorDeckStandard,
      buttonSplashColor: colorDeckDarker,
      firstHelpKey: deckMultipleChoiceTestFirstHelpKey,
    );
  }
}
