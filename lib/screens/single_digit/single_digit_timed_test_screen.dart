import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/standard/basic_flat_button.dart';
import 'package:mem_plus_plus/screens/templates/help_dialog.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'package:mem_plus_plus/services/services.dart';

import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:flutter/services.dart';

class SingleDigitTimedTestScreen extends StatefulWidget {
  final Function callback;
  final GlobalKey<ScaffoldState> globalKey;

  SingleDigitTimedTestScreen({required this.callback, required this.globalKey});

  @override
  _SingleDigitTimedTestScreenState createState() =>
      _SingleDigitTimedTestScreenState();
}

class _SingleDigitTimedTestScreenState
    extends State<SingleDigitTimedTestScreen> {
  String digit1 = '';
  String digit2 = '';
  String digit3 = '';
  String digit4 = '';
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

  getSharedPrefs() {
    prefs.checkFirstTime(context, 'SingleDigitTimedTestFirstHelp',
        SingleDigitTimedTestScreenHelp(callback: widget.callback));
    // grab the digits
    digit1 = (prefs.getString('singleDigitTestDigit1'));
    digit2 = (prefs.getString('singleDigitTestDigit2'));
    digit3 = (prefs.getString('singleDigitTestDigit3'));
    digit4 = (prefs.getString('singleDigitTestDigit4'));
    print('real answer: $digit1$digit2$digit3$digit4');
    setState(() {});
  }

  checkAnswer() {
    if (textController.text == '$digit1$digit2$digit3$digit4') {
      prefs.updateActivityVisible(singleDigitTimedTestKey, false);
      prefs.updateActivityVisible(singleDigitTimedTestPrepKey, true);
      prefs.updateActivityVisible(lesson1Key, true);
      prefs.setBool(gamesAvailableKey, true);
      if (!prefs.getBool(fadeGameFirstViewKey)) {
        prefs.setBool(newGamesAvailableKey, true);
        prefs.setBool(fadeGameFirstViewKey, true);
      }
      prefs.setBool(fadeGameAvailableKey, true);
      if (!prefs.getBool(singleDigitTimedTestCompleteKey)) {
        prefs.updateActivityState(singleDigitTimedTestKey, 'review');
        prefs.setBool(singleDigitTimedTestCompleteKey, true);
        showSnackBar(
          context: context,
          snackBarText:
              'Congratulations! You\'ve completed the Single Digit system!',
          textColor: Colors.black,
          backgroundColor: colorSingleDigitDarker,
          durationSeconds: 3,
          isSuper: true,
        );
        showSnackBar(
          context: context,
          snackBarText: 'You\'ve unlocked Mini-Games!',
          textColor: Colors.white,
          backgroundColor: colorGamesDarker,
          durationSeconds: 3,
          isSuper: true,
        );
        showSnackBar(
          context: context,
          snackBarText: 'You\'ve unlocked Chapter 1!',
          textColor: Colors.black,
          backgroundColor: colorChapter1Darker,
          durationSeconds: 3,
          isSuper: true,
        );
      } else {
        showSnackBar(
          context: context,
          snackBarText: 'Congratulations! You aced it!',
          textColor: Colors.black,
          backgroundColor: colorSingleDigitStandard,
          durationSeconds: 2,
        );
      }
    } else {
      showSnackBar(
        context: context,
        snackBarText:
            'Incorrect. Keep trying to remember, or give up and try again!',
        backgroundColor: colorSingleDigitDarkest,
        durationSeconds: 3,
      );
    }
    textController.text = '';
    widget.callback();
    Navigator.pop(context);
  }

  giveUp() {
    prefs.updateActivityState(singleDigitTimedTestKey, 'review');
    prefs.updateActivityVisible(singleDigitTimedTestKey, false);
    prefs.updateActivityVisible(singleDigitTimedTestPrepKey, true);
    if (!prefs.getBool(singleDigitTimedTestCompleteKey)) {
      prefs.updateActivityState(singleDigitTimedTestPrepKey, 'todo');
    }
    showSnackBar(
        context: context,
        snackBarText:
            'The correct answer was: $digit1$digit2$digit3$digit4\nTry the timed test again to unlock the next system.',
        backgroundColor: colorSingleDigitDarkest,
        durationSeconds: 5);
    Navigator.pop(context);
    widget.callback();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          title:
              Text('Single digit: timed test', style: TextStyle(fontSize: 18)),
          backgroundColor: Colors.amber[200],
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return SingleDigitTimedTestScreenHelp(
                          callback: widget.callback);
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
              SizedBox(height: 25),
              Container(
                width: 150,
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
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: backgroundHighlightColor)),
                      hintText: 'XXXX',
                      hintStyle: TextStyle(
                          fontSize: 30,
                          fontFamily: 'SpaceMono',
                          color: Colors.grey)),
                ),
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  BasicFlatButton(
                    text: 'Give up',
                    fontSize: 24,
                    color: Colors.grey[200]!,
                    onPressed: () => giveUp(),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  BasicFlatButton(
                    text: 'Submit',
                    fontSize: 24,
                    color: Colors.amber[200]!,
                    onPressed: () => checkAnswer(),
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

class SingleDigitTimedTestScreenHelp extends StatelessWidget {
  final Function callback;
  SingleDigitTimedTestScreenHelp({Key? key, required this.callback})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return HelpDialog(
      title: 'Single Digit - Timed Test',
      information: [
        '    Time to remember your story! If you recall this correctly, you\'ll '
            'unlock the next chapter! Good luck!'
      ],
      buttonColor: Colors.amber[100]!,
      buttonSplashColor: Colors.amber[300]!,
      firstHelpKey: singleDigitTimedTestFirstHelpKey,
      callback: callback,
    );
  }
}
