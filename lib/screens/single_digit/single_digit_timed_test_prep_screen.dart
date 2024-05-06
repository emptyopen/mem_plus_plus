import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/standard/basic_flat_button.dart';
import 'package:mem_plus_plus/screens/templates/help_dialog.dart';

import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'dart:math';
import 'package:mem_plus_plus/services/services.dart';
import 'dart:async';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:flutter/services.dart';

class SingleDigitTimedTestPrepScreen extends StatefulWidget {
  final Function() callback;

  SingleDigitTimedTestPrepScreen({required this.callback});

  @override
  _SingleDigitTimedTestPrepScreenState createState() =>
      _SingleDigitTimedTestPrepScreenState();
}

class _SingleDigitTimedTestPrepScreenState
    extends State<SingleDigitTimedTestPrepScreen> {
  String digit1 = '';
  String digit2 = '';
  String digit3 = '';
  String digit4 = '';
  PrefsUpdater prefs = PrefsUpdater();
  Duration testDuration =
      debugModeEnabled ? Duration(seconds: debugTestTime) : Duration(hours: 1);

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    prefs.checkFirstTime(context, singleDigitTimedTestPrepFirstHelpKey,
        SingleDigitTimedTestPrepScreenHelp());
    setState(() {
      // if digits are null, randomize values and store them,
      // then update DateTime available for singleDigitTest
      if (!prefs.getBool(singleDigitTestActiveKey)) {
        print('no active test, setting new values');
        var random = new Random();
        digit1 = random.nextInt(9).toString();
        digit2 = random.nextInt(9).toString();
        digit3 = random.nextInt(9).toString();
        digit4 = random.nextInt(9).toString();
        prefs.setString('singleDigitTestDigit1', digit1);
        prefs.setString('singleDigitTestDigit2', digit2);
        prefs.setString('singleDigitTestDigit3', digit3);
        prefs.setString('singleDigitTestDigit4', digit4);
        prefs.setBool(singleDigitTestActiveKey, true);
      } else {
        print('found active test, restoring values');
        digit1 = (prefs.getString('singleDigitTestDigit1'));
        digit2 = (prefs.getString('singleDigitTestDigit2'));
        digit3 = (prefs.getString('singleDigitTestDigit3'));
        digit4 = (prefs.getString('singleDigitTestDigit4'));
      }
    });
  }

  void updateStatus() async {
    prefs.setBool(singleDigitTestActiveKey, false);
    prefs.updateActivityState(singleDigitTimedTestPrepKey, 'review');
    prefs.updateActivityVisible(singleDigitTimedTestPrepKey, false);
    prefs.updateActivityState(singleDigitTimedTestKey, 'todo');
    prefs.updateActivityVisible(singleDigitTimedTestKey, true);
    prefs.updateActivityFirstView(singleDigitTimedTestKey, true);
    prefs.updateActivityVisibleAfter(
        singleDigitTimedTestKey, DateTime.now().add(testDuration));
    Timer(testDuration, widget.callback);
    notifyDuration(testDuration, 'Timed test (single digit) is ready!',
        'Good luck!', singleDigitTimedTestKey);
    widget.callback();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          title: Text('Single digit: timed test preparation'),
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
                      return SingleDigitTimedTestPrepScreenHelp();
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
              'Your number is: ',
              style: TextStyle(fontSize: 34, color: backgroundHighlightColor),
            )),
            SizedBox(
              height: 50,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: 60,
                decoration: BoxDecoration(
                    color: Colors.amber[50],
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                child: Center(
                  child: Text(
                    digit1,
                    style: TextStyle(fontSize: 44),
                  ),
                ),
              ),
              Container(
                width: 60,
                decoration: BoxDecoration(
                    color: Colors.amber[100],
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                child: Center(
                  child: Text(
                    digit2,
                    style: TextStyle(fontSize: 44),
                  ),
                ),
              ),
              Container(
                width: 60,
                decoration: BoxDecoration(
                    color: Colors.amber[200],
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                child: Center(
                  child: Text(
                    digit3,
                    style: TextStyle(fontSize: 44),
                  ),
                ),
              ),
              Container(
                width: 60,
                decoration: BoxDecoration(
                    color: Colors.amber[300],
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                child: Center(
                  child: Text(
                    digit4,
                    style: TextStyle(fontSize: 44),
                  ),
                ),
              ),
            ]),
            SizedBox(
              height: 100,
            ),
            BasicFlatButton(
              text: 'I\'m ready!',
              color: colorSingleDigitLighter,
              onPressed: () => showConfirmDialog(
                  context: context,
                  function: updateStatus,
                  confirmText:
                      'Are you sure you\'d like to start this test? The number will no longer be available to view!',
                  confirmColor: colorSingleDigitStandard),
              fontSize: 30,
              padding: 10,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Text(
                '(You\'ll be quizzed on this in one hour!)',
                style: TextStyle(fontSize: 18, color: backgroundHighlightColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SingleDigitTimedTestPrepScreenHelp extends StatelessWidget {
  final List<String> information = [
    '    Great job so far! Now your goal is to memorize a 4 digit number by converting the digits '
        'to their associated objects and imagining a crazy scene where those objects '
        'appear in order. \n    Once you feel confident, select "I\'m ready!" and the numbers will become unavailable. '
        'In an hour you will have to decode the scene back into numbers.',
    '    For example, let\'s look at the number 1234. Let\'s say that translates to STICK, BIRD, BRA, and SAILBOAT. We '
        'could imagine a STICK falling out of the sky, landing and skewering a BIRD. Ouch! '
        'The bird is in a lot of pain. Luckily, it finds a BRA and makes a tourniquet out of it. '
        'Now the bird can make it to the fancy dinner party on the SAILBOAT tonight! Phew!',
    '    Really make that scene vivid! CLOSE your eyes and physically imagine the details in your mind. '
        'Was that STICK an ancient Roman spear? A bayonet? How much does that BIRD squawk when it gets speared out of nowhere? '
        'I would squawk like crazy. \n    Was the bird a swan? So lucky it had that super sexy BRA. The bra is all bloody '
        'but it saved someone\'s life tonight!'
        '\n    Think about all of the swan\'s friends that would be sad if the swan doesn\'t show up to the SAILBOAT party.',
    '    Now let\'s attach that scene to this quiz. It\'s a timed test, so let\'s imagine '
        'you up in the clouds, about to take this test. A huge timer clock is above you... ah, '
        'yes, this is the place to take a timed test. And the first thing that happens is you '
        'drop your pencil, and it rockets towards the earth, skewering that swan...',
    '    Yes, I know this is ridiculous, and time consuming. You can probably remember this 4 digit number without this dumb system, right?\n    '
        'Well, this is still going to be useful, both as a template for learning more complex systems, and as a necessary part of '
        'compound memorization techniques.\n\n    Anyways, just trust me! Start visualizing!'
  ];

  @override
  Widget build(BuildContext context) {
    return HelpDialog(
      title: 'Single Digit - Timed Test Preparation',
      information: information,
      buttonColor: Colors.amber[100]!,
      buttonSplashColor: Colors.amber[300]!,
      firstHelpKey: singleDigitTimedTestPrepFirstHelpKey,
    );
  }
}
