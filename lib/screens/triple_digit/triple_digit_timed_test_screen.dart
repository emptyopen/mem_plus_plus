import 'package:flutter/material.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:flutter/services.dart';

import '../../constants/keys.dart';

class TripleDigitTimedTestScreen extends StatefulWidget {
  final Function callback;
  final GlobalKey<ScaffoldState> globalKey;

  TripleDigitTimedTestScreen({this.callback, this.globalKey});

  @override
  _TripleDigitTimedTestScreenState createState() =>
      _TripleDigitTimedTestScreenState();
}

class _TripleDigitTimedTestScreenState
    extends State<TripleDigitTimedTestScreen> {
  String digit1 = '';
  String digit2 = '';
  String digit3 = '';
  String digit4 = '';
  String digit5 = '';
  String digit6 = '';
  String digit7 = '';
  String digit8 = '';
  String digit9 = '';
  String digit10 = '';
  String digit11 = '';
  String digit12 = '';
  final textController = TextEditingController();
  PrefsUpdater prefs = PrefsUpdater();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    var prefs = PrefsUpdater();
    prefs.checkFirstTime(context, 'TripleDigitTimedTestFirstHelp',
        TripleDigitTimedTestScreenHelp());
    // grab the digits
    digit1 = await prefs.getString('tripleDigitTestDigit1');
    digit2 = await prefs.getString('tripleDigitTestDigit2');
    digit3 = await prefs.getString('tripleDigitTestDigit3');
    digit4 = await prefs.getString('tripleDigitTestDigit4');
    digit5 = await prefs.getString('tripleDigitTestDigit5');
    digit6 = await prefs.getString('tripleDigitTestDigit6');
    digit7 = await prefs.getString('tripleDigitTestDigit7');
    digit8 = await prefs.getString('tripleDigitTestDigit8');
    digit9 = await prefs.getString('tripleDigitTestDigit9');
    digit10 = await prefs.getString('tripleDigitTestDigit10');
    digit11 = await prefs.getString('tripleDigitTestDigit11');
    digit12 = await prefs.getString('tripleDigitTestDigit12');
    print(
        'real answer: $digit1$digit2$digit3$digit4 $digit5$digit6$digit7$digit8 $digit9$digit10$digit11$digit12');
    setState(() {});
  }

  void checkAnswer() async {
    if (cleanString(textController.text) ==
        '$digit1$digit2$digit3$digit4$digit5$digit6$digit7$digit8$digit9$digit10$digit11$digit12') {
      await prefs.updateActivityVisible(tripleDigitTimedTestKey, false);
      await prefs.updateActivityVisible(tripleDigitTimedTestPrepKey, true);
      await prefs.updateActivityVisible(lesson1Key, true);
      await prefs.setBool(gamesAvailableKey, true);
      if (await prefs.getBool(fadeGameFirstViewKey) == null) {
        await prefs.setBool(newGamesAvailableKey, true);
        await prefs.setBool(fadeGameFirstViewKey, true);
      }
      await prefs.setBool(fadeGameAvailableKey, true);
      if (await prefs.getBool(tripleDigitTimedTestCompleteKey) == null) {
        await prefs.updateActivityState(tripleDigitTimedTestKey, 'review');
        await prefs.setBool(tripleDigitTimedTestCompleteKey, true);
        showSnackBar(
          scaffoldState: widget.globalKey.currentState,
          snackBarText:
              'Congratulations! You\'ve completed the Triple Digit system!',
          textColor: Colors.black,
          backgroundColor: colorTripleDigitDarker,
          durationSeconds: 3,
          isSuper: true,
        );
      } else {
        showSnackBar(
          scaffoldState: widget.globalKey.currentState,
          snackBarText: 'Congratulations! You aced it!',
          textColor: Colors.black,
          backgroundColor: colorTripleDigitStandard,
          durationSeconds: 2,
        );
      }
    } else {
      showSnackBar(
        scaffoldState: widget.globalKey.currentState,
        snackBarText:
            'Incorrect. Keep trying to remember, or give up and try again!',
        backgroundColor: colorTripleDigitDarkest,
        durationSeconds: 3,
      );
    }
    textController.text = '';
    widget.callback();
    Navigator.pop(context);
  }

  void giveUp() async {
    await prefs.updateActivityState(tripleDigitTimedTestKey, 'review');
    await prefs.updateActivityVisible(tripleDigitTimedTestKey, false);
    await prefs.updateActivityVisible(tripleDigitTimedTestPrepKey, true);
    if (await prefs.getBool(tripleDigitTimedTestCompleteKey) == null) {
      await prefs.updateActivityState(tripleDigitTimedTestPrepKey, 'todo');
    }
    showSnackBar(
        scaffoldState: widget.globalKey.currentState,
        snackBarText:
            'The correct answer was: $digit1$digit2$digit3 $digit4$digit5$digit6 $digit7$digit8$digit9 $digit10$digit11$digit12\nTry the timed test again to unlock the next system.',
        backgroundColor: colorTripleDigitDarkest,
        durationSeconds: 5);
    Navigator.pop(context);
    widget.callback();
  }

  cleanString(String s) {
    return s.trim().replaceAll(new RegExp(r'[^\w]+'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          title: Text('Triple digit: timed test'),
          backgroundColor: colorTripleDigitStandard,
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return TripleDigitTimedTestScreenHelp();
                    }));
              },
            ),
          ]),
      body: Container(
        decoration: BoxDecoration(color: backgroundColor),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Text(
                  'Enter the number: ',
                  style:
                      TextStyle(fontSize: 30, color: backgroundHighlightColor),
                ),
              ),
              SizedBox(height: 5),
              Container(
                child: Text(
                  '(spaces and punctuation are ignored)',
                  style: TextStyle(
                      fontSize: 16, color: backgroundSemiHighlightColor),
                ),
              ),
              SizedBox(height: 25),
              Container(
                width: 250,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: TextFormField(
                  controller: textController,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'SpaceMono',
                      color: backgroundHighlightColor),
                  keyboardType: TextInputType.phone,
                  onChanged: (s) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: backgroundHighlightColor)),
                      hintText: 'XXXXXXXXX...',
                      hintStyle: TextStyle(
                          fontSize: 30,
                          fontFamily: 'SpaceMono',
                          color: Colors.grey)),
                ),
              ),
              SizedBox(height: 10),
              Container(
                child: Text(
                  '${cleanString(textController.text).length}/36 entered',
                  style: TextStyle(
                      fontSize: 16, color: backgroundSemiHighlightColor),
                ),
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  BasicFlatButton(
                    text: 'Give up',
                    fontSize: 24,
                    color: Colors.grey[200],
                    splashColor: colorTripleDigitStandard,
                    onPressed: () => giveUp(),
                    padding: 10,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  BasicFlatButton(
                    text: 'Submit',
                    fontSize: 24,
                    color: colorTripleDigitLighter,
                    splashColor: colorTripleDigitStandard,
                    onPressed: () => checkAnswer(),
                    padding: 10,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TripleDigitTimedTestScreenHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'Triple Digit Timed Test',
      information: ['    Good luck! You rock!'],
      buttonColor: Colors.amber[100],
      buttonSplashColor: Colors.amber[300],
      firstHelpKey: tripleDigitTimedTestFirstHelpKey,
    );
  }
}
