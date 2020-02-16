import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/single_digit/single_digit_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/components/templates/flash_card.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';

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

  callback() {
    widget.callback();
  }

  void nextActivity() async {
    await prefs.setBool('SingleDigitPracticeComplete', true);
    await prefs.updateActivityState('SingleDigitPractice', 'review');
    await prefs.updateActivityVisible('SingleDigitMultipleChoiceTest', true);
    await prefs.updateActivityFirstView('SingleDigitMultipleChoiceTest', true);

    widget.callback();
  }

  List<FlashCard> getSingleDigitFlashCards() {
    List<FlashCard> singleDigitFlashCards = [];
    if (singleDigitData != null) {
      for (int i = 0; i < singleDigitData.length; i++) {
        FlashCard singleDigitFlashCard = FlashCard(
          entry: singleDigitData[i],
          callback: callback,
          globalKey: widget.globalKey,
          activityKey: 'SingleDigit',
          nextActivityCallback: nextActivity,
          familiarityTotal: 1000,
          color: colorSingleDigitDarker,
        );
        singleDigitFlashCards.add(singleDigitFlashCard);
      }
    }
    return singleDigitFlashCards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Center(
          child: ListView(
        children: getSingleDigitFlashCards(),
      )),
    );
  }
}

class SingleDigitPracticeScreenHelp extends StatelessWidget {
  final List<String> information = [
    '    Now that you have a complete set of single digits mapped out, you\'re '
        'ready to get started with practice! \n    Here you will familiarize yourself '
        'with the digit-object mapping until you\'ve maxed out your '
        'familiarity with each digit, after which the first test will be unlocked! ',
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
