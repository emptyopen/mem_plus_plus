import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/standard/basic_flat_button.dart';
import 'package:mem_plus_plus/screens/templates/help_dialog.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'package:mem_plus_plus/services/services.dart';

import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:flutter/services.dart';

class TripleDigitTimedTestScreen extends StatefulWidget {
  final Function callback;
  final GlobalKey<ScaffoldState> globalKey;

  TripleDigitTimedTestScreen({required this.callback, required this.globalKey});

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
    PrefsUpdater prefs = PrefsUpdater();
    prefs.checkFirstTime(context, 'TripleDigitTimedTestFirstHelp',
        TripleDigitTimedTestScreenHelp(callback: widget.callback));
    // grab the digits
    digit1 = prefs.getString('tripleDigitTestDigit1');
    digit2 = prefs.getString('tripleDigitTestDigit2');
    digit3 = prefs.getString('tripleDigitTestDigit3');
    digit4 = prefs.getString('tripleDigitTestDigit4');
    digit5 = prefs.getString('tripleDigitTestDigit5');
    digit6 = prefs.getString('tripleDigitTestDigit6');
    digit7 = prefs.getString('tripleDigitTestDigit7');
    digit8 = prefs.getString('tripleDigitTestDigit8');
    digit9 = prefs.getString('tripleDigitTestDigit9');
    digit10 = prefs.getString('tripleDigitTestDigit10');
    digit11 = prefs.getString('tripleDigitTestDigit11');
    digit12 = prefs.getString('tripleDigitTestDigit12');
    print(
        'real answer: $digit1$digit2$digit3$digit4 $digit5$digit6$digit7$digit8 $digit9$digit10$digit11$digit12');
    setState(() {});
  }

  void checkAnswer() async {
    if (cleanString(textController.text) ==
        '$digit1$digit2$digit3$digit4$digit5$digit6$digit7$digit8$digit9$digit10$digit11$digit12') {
      prefs.updateActivityVisible(tripleDigitTimedTestKey, false);
      prefs.updateActivityVisible(tripleDigitTimedTestPrepKey, true);
      prefs.updateActivityVisible(lesson1Key, true);
      prefs.setBool(gamesAvailableKey, true);
      prefs.setBool(fadeGameAvailableKey, true);
      showSnackBar(
        context: context,
        snackBarText: 'Congratulations! You aced it!',
        textColor: Colors.black,
        backgroundColor: colorTripleDigitStandard,
        durationSeconds: 2,
      );
    } else {
      showSnackBar(
        context: context,
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
    prefs.updateActivityState(tripleDigitTimedTestKey, 'review');
    prefs.updateActivityVisible(tripleDigitTimedTestKey, false);
    prefs.updateActivityVisible(tripleDigitTimedTestPrepKey, true);
    showSnackBar(
        context: context,
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
          title:
              Text('Triple digit: timed test', style: TextStyle(fontSize: 18)),
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
                      return TripleDigitTimedTestScreenHelp(
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
                    color: Colors.grey[200]!,
                    onPressed: () => giveUp(),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  BasicFlatButton(
                    text: 'Submit',
                    fontSize: 24,
                    color: colorTripleDigitLighter,
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

class TripleDigitTimedTestScreenHelp extends StatelessWidget {
  final Function callback;
  TripleDigitTimedTestScreenHelp({Key? key, required this.callback})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return HelpDialog(
      title: 'Triple Digit - Timed Test',
      information: ['    Good luck! You rock!'],
      buttonColor: Colors.amber[100]!,
      buttonSplashColor: Colors.amber[300]!,
      firstHelpKey: tripleDigitTimedTestFirstHelpKey,
      callback: callback,
    );
  }
}
