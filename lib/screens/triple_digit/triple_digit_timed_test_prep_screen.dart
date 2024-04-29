import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/standard/basic_flat_button.dart';
import 'package:mem_plus_plus/screens/templates/help_dialog.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'dart:math';
import 'package:mem_plus_plus/services/services.dart';
import 'dart:async';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/constants/colors.dart';

import 'package:flutter/services.dart';

class TripleDigitTimedTestPrepScreen extends StatefulWidget {
  final Function() callback;

  TripleDigitTimedTestPrepScreen({required this.callback});

  @override
  _TripleDigitTimedTestPrepScreenState createState() =>
      _TripleDigitTimedTestPrepScreenState();
}

class _TripleDigitTimedTestPrepScreenState
    extends State<TripleDigitTimedTestPrepScreen> {
  String digits1 = '';
  String digits2 = '';
  String digits3 = '';
  String digits4 = '';
  String digits5 = '';
  String digits6 = '';
  String digits7 = '';
  String digits8 = '';
  String digits9 = '';
  String digits10 = '';
  String digits11 = '';
  String digits12 = '';
  PrefsUpdater prefs = PrefsUpdater();
  Duration testDuration =
      debugModeEnabled ? Duration(seconds: debugTestTime) : Duration(hours: 4);

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    PrefsUpdater prefs = PrefsUpdater();
    prefs.checkFirstTime(context, tripleDigitTimedTestPrepFirstHelpKey,
        TripleDigitTimedTestPrepScreenHelp());
    // if digits are null, randomize values and store them,
    // then update DateTime available for tripleDigitTest
    bool? sdTestIsActive = prefs.getBool(tripleDigitTestActiveKey);
    if (sdTestIsActive == null || !sdTestIsActive) {
      print('no active test, setting new values');
      var random = new Random();
      digits1 = random.nextInt(1000).toString().padLeft(3, '0');
      digits2 = random.nextInt(1000).toString().padLeft(3, '0');
      digits3 = random.nextInt(1000).toString().padLeft(3, '0');
      digits4 = random.nextInt(1000).toString().padLeft(3, '0');
      digits5 = random.nextInt(1000).toString().padLeft(3, '0');
      digits6 = random.nextInt(1000).toString().padLeft(3, '0');
      digits7 = random.nextInt(1000).toString().padLeft(3, '0');
      digits8 = random.nextInt(1000).toString().padLeft(3, '0');
      digits9 = random.nextInt(1000).toString().padLeft(3, '0');
      digits10 = random.nextInt(1000).toString().padLeft(3, '0');
      digits11 = random.nextInt(1000).toString().padLeft(3, '0');
      digits12 = random.nextInt(1000).toString().padLeft(3, '0');
      prefs.setString('tripleDigitTestDigit1', digits1);
      prefs.setString('tripleDigitTestDigit2', digits2);
      prefs.setString('tripleDigitTestDigit3', digits3);
      prefs.setString('tripleDigitTestDigit4', digits4);
      prefs.setString('tripleDigitTestDigit5', digits5);
      prefs.setString('tripleDigitTestDigit6', digits6);
      prefs.setString('tripleDigitTestDigit7', digits7);
      prefs.setString('tripleDigitTestDigit8', digits8);
      prefs.setString('tripleDigitTestDigit9', digits9);
      prefs.setString('tripleDigitTestDigit10', digits10);
      prefs.setString('tripleDigitTestDigit11', digits11);
      prefs.setString('tripleDigitTestDigit12', digits12);
      prefs.setBool(tripleDigitTestActiveKey, true);
    } else {
      print('found active test, restoring values');
      digits1 = prefs.getString('tripleDigitTestDigit1')!;
      digits2 = prefs.getString('tripleDigitTestDigit2')!;
      digits3 = prefs.getString('tripleDigitTestDigit3')!;
      digits4 = prefs.getString('tripleDigitTestDigit4')!;
      digits5 = prefs.getString('tripleDigitTestDigit5')!;
      digits6 = prefs.getString('tripleDigitTestDigit6')!;
      digits7 = prefs.getString('tripleDigitTestDigit7')!;
      digits8 = prefs.getString('tripleDigitTestDigit8')!;
      digits9 = prefs.getString('tripleDigitTestDigit9')!;
      digits10 = prefs.getString('tripleDigitTestDigit10')!;
      digits11 = prefs.getString('tripleDigitTestDigit11')!;
      digits12 = prefs.getString('tripleDigitTestDigit12')!;
    }
    setState(() {});
  }

  void updateStatus() async {
    prefs.setBool(tripleDigitTestActiveKey, false);
    prefs.updateActivityState(tripleDigitTimedTestPrepKey, 'review');
    prefs.updateActivityVisible(tripleDigitTimedTestPrepKey, false);
    prefs.updateActivityState(tripleDigitTimedTestKey, 'todo');
    prefs.updateActivityVisible(tripleDigitTimedTestKey, true);
    prefs.updateActivityVisibleAfter(
        tripleDigitTimedTestKey, DateTime.now().add(testDuration));
    Timer(testDuration, widget.callback);
    notifyDuration(testDuration, 'Timed test (Triple Digit) is ready!',
        'Good luck!', tripleDigitTimedTestKey);
    widget.callback();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          title: Text('Triple Digit: timed test prep'),
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
                      return TripleDigitTimedTestPrepScreenHelp();
                    }));
              },
            ),
          ]),
      body: Container(
        decoration: BoxDecoration(color: backgroundColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
                child: Text(
              'Your sequences are: ',
              style: TextStyle(fontSize: 34, color: backgroundHighlightColor),
            )),
            SizedBox(
              height: 50,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              TimedTestPrepRowContainer(
                digits: digits1,
                color: Colors.deepOrange[50]!,
              ),
              TimedTestPrepRowContainer(
                digits: digits2,
                color: Colors.deepOrange[100]!,
              ),
              TimedTestPrepRowContainer(
                digits: digits3,
                color: Colors.deepOrange[200]!,
              ),
            ]),
            SizedBox(height: 25),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              TimedTestPrepRowContainer(
                digits: digits4,
                color: Colors.deepOrange[50]!,
              ),
              TimedTestPrepRowContainer(
                digits: digits5,
                color: Colors.deepOrange[100]!,
              ),
              TimedTestPrepRowContainer(
                digits: digits6,
                color: Colors.deepOrange[200]!,
              ),
            ]),
            SizedBox(height: 25),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              TimedTestPrepRowContainer(
                digits: digits7,
                color: Colors.deepOrange[50]!,
              ),
              TimedTestPrepRowContainer(
                digits: digits8,
                color: Colors.deepOrange[100]!,
              ),
              TimedTestPrepRowContainer(
                digits: digits9,
                color: Colors.deepOrange[200]!,
              ),
            ]),
            SizedBox(height: 25),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              TimedTestPrepRowContainer(
                digits: digits10,
                color: Colors.deepOrange[50]!,
              ),
              TimedTestPrepRowContainer(
                digits: digits11,
                color: Colors.deepOrange[100]!,
              ),
              TimedTestPrepRowContainer(
                digits: digits12,
                color: Colors.deepOrange[200]!,
              ),
            ]),
            SizedBox(
              height: 50,
            ),
            BasicFlatButton(
              text: 'I\'m ready!',
              color: colorTripleDigitLighter,
              onPressed: () => showConfirmDialog(
                  context: context,
                  function: updateStatus,
                  confirmText:
                      'Are you sure you\'d like to start this test? The sequences will no longer be available to view!',
                  confirmColor: colorTripleDigitStandard),
              fontSize: 30,
              padding: 10,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Text(
                '(You\'ll be quizzed on this in four hours!)',
                style: TextStyle(fontSize: 18, color: backgroundHighlightColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TripleDigitTimedTestPrepScreenHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HelpDialog(
      title: 'Triple Digit - Timed Test Preparation',
      information: [
        '    Very proud of you for coming this far. I myself have only achieved basic proficiency in this system recently.\n\n'
            '    If you haven\'t already, definitely start memorizing information that could be important! Phone numbers of your SO, '
            'checking account numbers, and passport expiration dates just to name a few!',
      ],
      buttonColor: colorTripleDigitStandard,
      buttonSplashColor: colorTripleDigitDarker,
      firstHelpKey: tripleDigitTimedTestPrepFirstHelpKey,
    );
  }
}

class TimedTestPrepRowContainer extends StatelessWidget {
  final String digits;
  final Color color;

  TimedTestPrepRowContainer({required this.digits, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.all(Radius.circular(5))),
      padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
      child: Center(
        child: Text(
          digits,
          style: TextStyle(fontSize: 30, fontFamily: 'SpaceMono'),
        ),
      ),
    );
  }
}
