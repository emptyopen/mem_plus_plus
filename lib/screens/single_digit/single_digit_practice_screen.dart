import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/single_digit/single_digit_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/components/templates/flash_card.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/screens/templates/card_test_screen.dart';

class SingleDigitPracticeScreen extends StatefulWidget {
  final Function() callback;
  final GlobalKey<ScaffoldState> globalKey;

  SingleDigitPracticeScreen({this.callback, this.globalKey});

  @override
  _SingleDigitPracticeScreenState createState() =>
      _SingleDigitPracticeScreenState();
}

class _SingleDigitPracticeScreenState extends State<SingleDigitPracticeScreen> {
  SharedPreferences sharedPreferences;
  List<SingleDigitData> singleDigitData;
  List<bool> results = List.filled(10, null);
  List<bool> tempResults = [];
  int attempts = 0;
  var prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    prefs.checkFirstTime(context, 'SingleDigitPracticeFirstHelp',
        SingleDigitPracticeScreenHelp());
    singleDigitData = await prefs.getSharedPrefs(singleDigitKey);
    singleDigitData = shuffle(singleDigitData);
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
    await prefs.updateActivityState(singleDigitPracticeKey, 'review');
    await prefs.updateActivityVisible(singleDigitMultipleChoiceTestKey, true);

    widget.callback();
  }

  List<FlashCard> getSingleDigitFlashCards() {
    List<FlashCard> singleDigitFlashCards = [];
    if (singleDigitData != null) {
      bool allComplete = true;
      for (int i = 0; i < singleDigitData.length; i++) {
        if (singleDigitData[i].familiarity < 100) {
          allComplete = false;
        }
      }
      for (int i = 0; i < singleDigitData.length; i++) {
        if (singleDigitData[i].familiarity < 100 || allComplete) {
          FlashCard singleDigitFlashCard = FlashCard(
            entry: singleDigitData[i],
            callback: callback,
            globalKey: widget.globalKey,
            activityKey: singleDigitKey,
            nextActivityCallback: nextActivity,
            familiarityTotal: 1000,
            color: colorSingleDigitDarker,
            lighterColor: colorSingleDigitLighter,
          );
          singleDigitFlashCards.add(singleDigitFlashCard);
        }
      }
    }
    setState(() {
      tempResults = results.sublist(0, singleDigitFlashCards.length);
    });
    return singleDigitFlashCards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text('Single digit: practice'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return SingleDigitPracticeScreenHelp();
                    }));
              },
            ),
          ],
          backgroundColor: Colors.amber[200],
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop('test'),
          ),
        ),
        body: CardTestScreen(
          cards: getSingleDigitFlashCards(),
          results: tempResults,
        ));
  }
}

class SingleDigitPracticeScreenHelp extends StatelessWidget {
  final List<String> information = [
    '    Now that you have a complete set of single digits mapped out, you\'re '
        'ready to get started with practice! \n    Here you will familiarize yourself '
        'with the digit-object mapping until you\'ve maxed out your '
        'familiarity with each digit, after which the first test will be unlocked! ',
    '    We\'ll only show cards that are still ranked less than 100 in familiarity (unless all are at 100 familiarity, '
        'in which case we\'ll show all of them). \n'
        '    Try to guess the object before even hitting the reveal button! It\'ll help you once you really get tested ;)'
  ];

  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'Single Digit Practice',
      information: information,
      buttonColor: Colors.amber[100],
      buttonSplashColor: Colors.amber[300],
      firstHelpKey: singleDigitPracticeFirstHelpKey,
    );
  }
}
