import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/alphabet/alphabet_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/components/templates/flash_card.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/screens/templates/card_test_screen.dart';

class AlphabetPracticeScreen extends StatefulWidget {
  final Function() callback;
  final GlobalKey<ScaffoldState> globalKey;

  AlphabetPracticeScreen({this.callback, this.globalKey});

  @override
  _AlphabetPracticeScreenState createState() => _AlphabetPracticeScreenState();
}

class _AlphabetPracticeScreenState extends State<AlphabetPracticeScreen> {
  SharedPreferences sharedPreferences;
  List<AlphabetData> alphabetData;
  List<bool> results = List.filled(26, null);
  List<bool> tempResults = [];
  int attempts = 0;
  var prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    prefs.checkFirstTime(
        context, 'AlphabetPracticeFirstHelp', AlphabetPracticeScreenHelp());
    alphabetData = await prefs.getSharedPrefs(alphabetKey);
    alphabetData = shuffle(alphabetData);
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
    await prefs.setBool('AlphabetPracticeComplete', true);
    await prefs.updateActivityState('AlphabetEdit', 'review');
    await prefs.updateActivityState('AlphabetPractice', 'review');
    await prefs.updateActivityVisible('AlphabetWrittenTest', true);
    await prefs.updateActivityFirstView('AlphabetWrittenTest', true);
    widget.callback();
  }

  List<FlashCard> getAlphabetFlashCards() {
    List<FlashCard> alphabetFlashCards = [];
    if (alphabetData != null) {
      bool allComplete = true;
      for (int i = 0; i < alphabetData.length; i++) {
        if (alphabetData[i].familiarity < 100) {
          allComplete = false;
        }
      }
      for (int i = 0; i < alphabetData.length; i++) {
        if (alphabetData[i].familiarity < 100 || allComplete) {
          FlashCard alphabetFlashCard = FlashCard(
            entry: alphabetData[i],
            callback: callback,
            globalKey: widget.globalKey,
            activityKey: 'Alphabet',
            nextActivityCallback: nextActivity,
            familiarityTotal: 2600,
            color: colorAlphabetDarker,
            lighterColor: colorAlphabetLighter,
          );
          alphabetFlashCards.add(alphabetFlashCard);
        }
      }
    }
    setState(() {
      tempResults = results.sublist(0, alphabetFlashCards.length);
    });
    return alphabetFlashCards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alphabet: practice'),
        backgroundColor: Colors.blue[200],
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              Navigator.of(context).push(PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (BuildContext context, _, __) {
                    return AlphabetPracticeScreenHelp();
                  }));
            },
          ),
        ],
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop('test'),
        ),
      ),
      body: CardTestScreen(
        cards: getAlphabetFlashCards(),
        results: tempResults,
      ),
    );
  }
}

class AlphabetPracticeScreenHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'Alphabet Practice',
      information: [
        '    You know the drill, get cracking :) ',
      ],
      buttonColor: Colors.blue[100],
      buttonSplashColor: Colors.blue[300],
      firstHelpKey: alphabetPracticeFirstHelpKey,
    );
  }
}
