import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/standard/basic_flat_button.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_dialog.dart';

import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:flutter/services.dart';

class PAOTimedTestScreen extends StatefulWidget {
  final Function() callback;
  final GlobalKey<ScaffoldState> globalKey;

  PAOTimedTestScreen({required this.callback, required this.globalKey});

  @override
  _PAOTimedTestScreenState createState() => _PAOTimedTestScreenState();
}

class _PAOTimedTestScreenState extends State<PAOTimedTestScreen> {
  String digits1 = '';
  String digits2 = '';
  String digits3 = '';
  String digits4 = '';
  String digits5 = '';
  String digits6 = '';
  String digits7 = '';
  String digits8 = '';
  String digits9 = '';
  final textController1 = TextEditingController();
  final textController2 = TextEditingController();
  final textController3 = TextEditingController();
  PrefsUpdater prefs = PrefsUpdater();

  @override
  void dispose() {
    textController1.dispose();
    textController2.dispose();
    textController3.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  getSharedPrefs() {
    PrefsUpdater prefs = PrefsUpdater();
    prefs.checkFirstTime(context, 'PAOTimedTestFirstHelp',
        PAOTimedTestScreenHelp(callback: widget.callback));
    // grab the digits
    digits1 = prefs.getString('paoTestDigits1');
    digits2 = prefs.getString('paoTestDigits2');
    digits3 = prefs.getString('paoTestDigits3');
    digits4 = prefs.getString('paoTestDigits4');
    digits5 = prefs.getString('paoTestDigits5');
    digits6 = prefs.getString('paoTestDigits6');
    digits7 = prefs.getString('paoTestDigits7');
    digits8 = prefs.getString('paoTestDigits8');
    digits9 = prefs.getString('paoTestDigits9');
    print(
        'real answer: $digits1$digits2$digits3 $digits4$digits5$digits6 $digits7$digits8$digits9');
    setState(() {});
  }

  checkAnswer() {
    HapticFeedback.lightImpact();
    if (textController1.text.trim() == '$digits1$digits2$digits3' &&
        textController2.text.trim() == '$digits4$digits5$digits6' &&
        textController3.text.trim() == '$digits7$digits8$digits9') {
      prefs.updateActivityVisible(paoTimedTestKey, false);
      prefs.updateActivityVisible(paoTimedTestPrepKey, true);
      prefs.updateActivityVisible(lesson3Key, true);
      if (!prefs.getBool(paoTimedTestCompleteKey)) {
        prefs.setBool(paoTimedTestCompleteKey, true);
        prefs.updateActivityState(paoTimedTestKey, 'review');
        showSnackBar(
          context: context,
          snackBarText: 'Congratulations! You\'ve mastered the PAO system!',
          textColor: Colors.white,
          backgroundColor: colorPAODarker,
          durationSeconds: 3,
          isSuper: true,
        );
        showSnackBar(
          context: context,
          snackBarText: 'You\'ve unlocked Chapter 3!',
          textColor: Colors.white,
          backgroundColor: colorChapter3Darker,
          durationSeconds: 3,
          isSuper: true,
        );
      } else {
        showSnackBar(
          context: context,
          snackBarText: 'Congratulations! You aced it!',
          textColor: Colors.black,
          backgroundColor: colorPAOStandard,
          durationSeconds: 2,
        );
      }
    } else {
      showSnackBar(
        context: context,
        snackBarText:
            'Incorrect. Keep trying to remember, or give up and try again!',
        textColor: Colors.black,
        backgroundColor: colorPAODarkest,
        durationSeconds: 3,
      );
    }
    textController1.text = '';
    textController2.text = '';
    textController3.text = '';
    widget.callback();
    Navigator.pop(context);
  }

  giveUp() {
    HapticFeedback.lightImpact();
    prefs.updateActivityState(paoTimedTestKey, 'review');
    prefs.updateActivityVisible(paoTimedTestKey, false);
    prefs.updateActivityVisible(paoTimedTestPrepKey, true);
    if (!prefs.getBool(paoTimedTestCompleteKey)) {
      prefs.updateActivityState(paoTimedTestPrepKey, 'todo');
    }
    showSnackBar(
        context: context,
        snackBarText:
            'The correct answers were: \n$digits1$digits2$digits3\n$digits4$digits5$digits6\n$digits7$digits8$digits9\nTry the timed test again to unlock the next system.',
        backgroundColor: colorPAODarkest,
        durationSeconds: 12);
    Navigator.pop(context);
    widget.callback();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          title: Text('PAO: timed test', style: TextStyle(fontSize: 18)),
          backgroundColor: colorPAOStandard,
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return PAOTimedTestScreenHelp(callback: widget.callback);
                    }));
              },
            ),
          ]),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(color: backgroundColor),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 25,
                ),
                Container(
                  child: Text(
                    'Enter the digits: ',
                    style: TextStyle(
                        fontSize: 30, color: backgroundHighlightColor),
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  width: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: TextFormField(
                    controller: textController1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'SpaceMono',
                        color: backgroundHighlightColor),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: backgroundHighlightColor)),
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder(),
                        hintText: 'XXXXXX',
                        hintStyle: TextStyle(fontSize: 30, color: Colors.grey)),
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  width: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: TextFormField(
                    controller: textController2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'SpaceMono',
                        color: backgroundHighlightColor),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: backgroundHighlightColor)),
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder(),
                        hintText: 'XXXXXX',
                        hintStyle: TextStyle(fontSize: 30, color: Colors.grey)),
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  width: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: TextFormField(
                    controller: textController3,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'SpaceMono',
                        color: backgroundHighlightColor),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: backgroundHighlightColor)),
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder(),
                        hintText: 'XXXXXX',
                        hintStyle: TextStyle(fontSize: 30, color: Colors.grey)),
                  ),
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    BasicFlatButton(
                      text: 'Give up',
                      onPressed: () => giveUp(),
                      color: Colors.grey[200]!,
                      fontSize: 24,
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    BasicFlatButton(
                      text: 'Submit',
                      onPressed: () => checkAnswer(),
                      color: colorPAOStandard,
                      fontSize: 24,
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PAOTimedTestScreenHelp extends StatelessWidget {
  final Function callback;
  PAOTimedTestScreenHelp({Key? key, required this.callback}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return HelpDialog(
      title: 'PAO - Timed Test',
      information: [
        '    Time to recall your story! If you recall this correctly, you\'ll '
            'unlock the next system! Good luck!'
      ],
      buttonColor: colorPAOStandard,
      buttonSplashColor: colorPAODarker,
      firstHelpKey: paoTimedTestFirstHelpKey,
      callback: callback,
    );
  }
}
