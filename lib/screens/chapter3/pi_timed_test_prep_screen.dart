import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/standard/basic_flat_button.dart';

import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'dart:async';
import 'package:mem_plus_plus/screens/templates/help_dialog.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:flutter/services.dart';

class PiTimedTestPrepScreen extends StatefulWidget {
  final Function() callback;

  PiTimedTestPrepScreen({required this.callback});

  @override
  _PiTimedTestPrepScreenState createState() => _PiTimedTestPrepScreenState();
}

class _PiTimedTestPrepScreenState extends State<PiTimedTestPrepScreen> {
  PrefsUpdater prefs = PrefsUpdater();
  Duration testDuration = debugModeEnabled
      ? Duration(seconds: debugTestTimeSeconds)
      : Duration(hours: 6);

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  getSharedPrefs() {
    prefs.checkFirstTime(context, piTimedTestPrepFirstHelpKey,
        PiTimedTestPrepScreenHelp(callback: widget.callback));
  }

  updateStatus() {
    prefs.setBool(piTestActiveKey, false);
    prefs.updateActivityState(piTimedTestPrepKey, 'review');
    prefs.updateActivityVisible(piTimedTestPrepKey, false);
    prefs.updateActivityState(piTimedTestKey, 'todo');
    prefs.updateActivityVisible(piTimedTestKey, true);
    prefs.updateActivityVisibleAfter(
        piTimedTestKey, DateTime.now().add(testDuration));
    Timer(testDuration, widget.callback);
    notifyDuration(testDuration, 'Timed test (pi) is ready!', 'Good luck!',
        piTimedTestKey);
    widget.callback();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          title: Text('Pi: timed test prep', style: TextStyle(fontSize: 18)),
          backgroundColor: colorChapter3Standard,
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return PiTimedTestPrepScreenHelp(
                          callback: widget.callback);
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
              'The first 100 digits of Pi are: ',
              style: TextStyle(fontSize: 24, color: backgroundHighlightColor),
            )),
            SizedBox(
              height: 30,
            ),
            Text(
              '3.',
              style: TextStyle(fontSize: 34, color: backgroundHighlightColor),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              '141592 653589 793238',
              style: TextStyle(
                fontSize: 24,
                color: backgroundHighlightColor,
              ),
            ),
            Text(
              '462643 383279 502884',
              style: TextStyle(
                fontSize: 24,
                color: backgroundHighlightColor,
              ),
            ),
            Text(
              '197169 399375 105820',
              style: TextStyle(
                fontSize: 24,
                color: backgroundHighlightColor,
              ),
            ),
            Text(
              '974944 592307 816406',
              style: TextStyle(
                fontSize: 24,
                color: backgroundHighlightColor,
              ),
            ),
            Text(
              '286208 998628 034825',
              style: TextStyle(
                fontSize: 24,
                color: backgroundHighlightColor,
              ),
            ),
            Text(
              '342117 0679',
              style: TextStyle(
                fontSize: 24,
                color: backgroundHighlightColor,
              ),
            ),
            SizedBox(
              height: 60,
            ),
            BasicFlatButton(
              text: 'I\'m ready!',
              color: colorChapter3Darker,
              onPressed: () => showConfirmDialog(
                  context: context,
                  function: updateStatus,
                  confirmText:
                      'Are you sure you\'d like to start this test? The number will no longer be available to view!',
                  confirmColor: colorChapter3Standard),
              fontSize: 30,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Text(
                '(You\'ll be quizzed on this in six hours!)',
                style: TextStyle(fontSize: 18, color: backgroundHighlightColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PiTimedTestPrepScreenHelp extends StatelessWidget {
  final Function callback;
  PiTimedTestPrepScreenHelp({Key? key, required this.callback})
      : super(key: key);
  final List<String> information = [
    '    Welcome, welcome. We\'re going to really make you a nerd now... '
        'you\'re about to break your record for the longest number you\'ve ever memorized! '
        'Here you are going to memorize 100 digits of pi. Why, you ask? Because you can! \n    It will also '
        'continue to improve your capacity and speed for memorizing shorter, more reasonable and useful numbers. ',
    '    I\'ll separate the digits into segments of 6 so that you have an easier time breaking the number into '
        'scenes. Really make sure that your transitions/connections between scenes are strong!\n    If this '
        'is your first time memorizing something this long, it might take you a few sessions to put together all the '
        'scenes and link them up. No rush! ',
  ];

  @override
  Widget build(BuildContext context) {
    return HelpDialog(
      title: 'Pi - Timed Test Preparation',
      information: information,
      buttonColor: colorChapter3Standard,
      buttonSplashColor: colorChapter3Darker,
      firstHelpKey: piTimedTestPrepFirstHelpKey,
      callback: callback,
    );
  }
}
