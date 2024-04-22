import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/data/deck_data.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_dialog.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/screens/templates/card_test_screen.dart';
import 'package:flutter/services.dart';

class DeckPracticeScreen extends StatefulWidget {
  final Function() callback;
  final GlobalKey<ScaffoldState> globalKey;

  DeckPracticeScreen({required this.callback, required this.globalKey});

  @override
  _DeckPracticeScreenState createState() => _DeckPracticeScreenState();
}

class _DeckPracticeScreenState extends State<DeckPracticeScreen> {
  late List<DeckData> deckData;
  List<Widget> deckCards = [];
  bool dataReady = false;
  PrefsUpdater prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    prefs.checkFirstTime(
        context, deckPracticeFirstHelpKey, DeckPracticeScreenHelp());
    deckData = prefs.getSharedPrefs(deckKey) as List<DeckData>;
    bool allComplete = true;
    for (int i = 0; i < deckData.length; i++) {
      if (deckData[i].familiarity < 100) {
        allComplete = false;
      }
    }
    if (!allComplete) {
      var tempDeckData = deckData;
      deckData = [];
      tempDeckData.forEach((s) {
        if (s.familiarity < 100) {
          deckData.add(s);
        }
      });
    }
    setState(() {
      deckData = shuffle(deckData) as List<DeckData>;
      dataReady = true;
    });
  }

  callback() {
    widget.callback();
  }

  void nextActivity() async {
    prefs.updateActivityState(deckPracticeKey, 'review');
    prefs.updateActivityVisible(deckMultipleChoiceTestKey, true);
    widget.callback();
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
                HapticFeedback.lightImpact();
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return DeckPracticeScreenHelp();
                    }));
              },
            ),
          ]),
      body: dataReady
          ? CardTestScreen(
              cardData: deckData,
              cardType: 'FlashCard',
              globalKey: widget.globalKey,
              nextActivity: nextActivity,
              systemKey: deckKey,
              color: colorDeckStandard,
              lighterColor: colorDeckLighter,
              familiarityTotal: 5200,
            )
          : Container(),
    );
  }
}

class DeckPracticeScreenHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HelpDialog(
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
