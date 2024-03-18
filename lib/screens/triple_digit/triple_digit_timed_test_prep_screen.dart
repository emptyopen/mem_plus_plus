import 'package:flutter/material.dart';
import 'dart:math';
import 'package:mem_plus_plus/services/services.dart';
import 'dart:async';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:flutter/services.dart';

class TripleDigitTimedTestPrepScreen extends StatefulWidget {
  final Function() callback;

  TripleDigitTimedTestPrepScreen({this.callback});

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
    var prefs = PrefsUpdater();
    prefs.checkFirstTime(context, tripleDigitTimedTestPrepFirstHelpKey,
        TripleDigitTimedTestPrepScreenHelp());
    // if digits are null, randomize values and store them,
    // then update DateTime available for tripleDigitTest
    bool sdTestIsActive = await prefs.getBool(tripleDigitTestActiveKey);
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
      await prefs.setString('tripleDigitTestDigit1', digits1);
      await prefs.setString('tripleDigitTestDigit2', digits2);
      await prefs.setString('tripleDigitTestDigit3', digits3);
      await prefs.setString('tripleDigitTestDigit4', digits4);
      await prefs.setString('tripleDigitTestDigit5', digits5);
      await prefs.setString('tripleDigitTestDigit6', digits6);
      await prefs.setString('tripleDigitTestDigit7', digits7);
      await prefs.setString('tripleDigitTestDigit8', digits8);
      await prefs.setString('tripleDigitTestDigit9', digits9);
      await prefs.setString('tripleDigitTestDigit10', digits10);
      await prefs.setString('tripleDigitTestDigit11', digits11);
      await prefs.setString('tripleDigitTestDigit12', digits12);
      await prefs.setBool(tripleDigitTestActiveKey, true);
    } else {
      print('found active test, restoring values');
      digits1 = await prefs.getString('tripleDigitTestDigit1');
      digits2 = await prefs.getString('tripleDigitTestDigit2');
      digits3 = await prefs.getString('tripleDigitTestDigit3');
      digits4 = await prefs.getString('tripleDigitTestDigit4');
      digits5 = await prefs.getString('tripleDigitTestDigit5');
      digits6 = await prefs.getString('tripleDigitTestDigit6');
      digits7 = await prefs.getString('tripleDigitTestDigit7');
      digits8 = await prefs.getString('tripleDigitTestDigit8');
      digits9 = await prefs.getString('tripleDigitTestDigit9');
      digits10 = await prefs.getString('tripleDigitTestDigit10');
      digits11 = await prefs.getString('tripleDigitTestDigit11');
      digits12 = await prefs.getString('tripleDigitTestDigit12');
    }
    setState(() {});
  }

  void updateStatus() async {
    await prefs.setBool(tripleDigitTestActiveKey, false);
    await prefs.updateActivityState(tripleDigitTimedTestPrepKey, 'review');
    await prefs.updateActivityVisible(tripleDigitTimedTestPrepKey, false);
    await prefs.updateActivityState(tripleDigitTimedTestKey, 'todo');
    await prefs.updateActivityVisible(tripleDigitTimedTestKey, true);
    await prefs.updateActivityVisibleAfter(
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
                color: Colors.deepOrange[50],
              ),
              TimedTestPrepRowContainer(
                digits: digits2,
                color: Colors.deepOrange[100],
              ),
              TimedTestPrepRowContainer(
                digits: digits3,
                color: Colors.deepOrange[200],
              ),
            ]),
            SizedBox(height: 25),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              TimedTestPrepRowContainer(
                digits: digits4,
                color: Colors.deepOrange[50],
              ),
              TimedTestPrepRowContainer(
                digits: digits5,
                color: Colors.deepOrange[100],
              ),
              TimedTestPrepRowContainer(
                digits: digits6,
                color: Colors.deepOrange[200],
              ),
            ]),
            SizedBox(height: 25),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              TimedTestPrepRowContainer(
                digits: digits7,
                color: Colors.deepOrange[50],
              ),
              TimedTestPrepRowContainer(
                digits: digits8,
                color: Colors.deepOrange[100],
              ),
              TimedTestPrepRowContainer(
                digits: digits9,
                color: Colors.deepOrange[200],
              ),
            ]),
            SizedBox(height: 25),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              TimedTestPrepRowContainer(
                digits: digits10,
                color: Colors.deepOrange[50],
              ),
              TimedTestPrepRowContainer(
                digits: digits11,
                color: Colors.deepOrange[100],
              ),
              TimedTestPrepRowContainer(
                digits: digits12,
                color: Colors.deepOrange[200],
              ),
            ]),
            SizedBox(
              height: 50,
            ),
            BasicFlatButton(
              text: 'I\'m ready!',
              color: colorTripleDigitLighter,
              splashColor: colorTripleDigitStandard,
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
    return HelpScreen(
      title: 'Triple Digit Timed Test Preparation',
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

  TimedTestPrepRowContainer({this.digits, this.color});

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
