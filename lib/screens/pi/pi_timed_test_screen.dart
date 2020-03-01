import 'package:flutter/material.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:flutter/services.dart';

class PiTimedTestScreen extends StatefulWidget {
  final Function() callback;
  final GlobalKey<ScaffoldState> globalKey;

  PiTimedTestScreen({this.callback, this.globalKey});

  @override
  _PiTimedTestScreenState createState() => _PiTimedTestScreenState();
}

class _PiTimedTestScreenState extends State<PiTimedTestScreen> {
  final textController = TextEditingController();
  String piString =
      '1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679';
  bool showError = false;
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
    prefs.checkFirstTime(
        context, piTimedTestFirstHelpKey, PiTimedTestScreenHelp());
    setState(() {});
  }

  void checkAnswer() async {
    setState(() {
      showError = false;
    });
    HapticFeedback.heavyImpact();
    if (textController.text.length != 100) {
      setState(() {
        showError = true;
      });
      return;
    }
    if (textController.text.trim() == '$piString') {
      await prefs.updateActivityVisible(piTimedTestKey, false);
      await prefs.updateActivityVisible(piTimedTestPrepKey, true);
      await prefs.updateActivityVisible(deckEditKey, true);
      if (await prefs.getBool(piTimedTestKey) == null) {
        await prefs.updateActivityState(piTimedTestKey, 'review');
        await prefs.setBool(piTimedTestKey, true);
        showSnackBar(
          scaffoldState: widget.globalKey.currentState,
          snackBarText: 'Congratulations! You\'ve unlocked the Deck system!',
          textColor: Colors.white,
          backgroundColor: colorDeckDarker,
          durationSeconds: 3,
          isSuper: true,
        );
      } else {
        showSnackBar(
          scaffoldState: widget.globalKey.currentState,
          snackBarText: 'Congratulations! You aced it!',
          textColor: Colors.black,
          backgroundColor: colorChapter3Standard,
          durationSeconds: 2,
        );
      }
    } else {
      showSnackBar(
        scaffoldState: widget.globalKey.currentState,
        snackBarText:
            'Incorrect. Keep trying to remember, or give up and try again!',
        textColor: Colors.black,
        backgroundColor: colorIncorrect,
        durationSeconds: 3,
      );
    }
    textController.text = '';
    widget.callback();
    Navigator.pop(context);
  }

  void giveUp() async {
    HapticFeedback.heavyImpact();
    await prefs.updateActivityState(piTimedTestKey, 'review');
    await prefs.updateActivityVisible(piTimedTestKey, false);
    await prefs.updateActivityVisible(piTimedTestPrepKey, true);
    if (await prefs.getBool(piTimedTestCompleteKey) == null) {
      await prefs.updateActivityState(piTimedTestPrepKey, 'todo');
    }
    showSnackBar(
        scaffoldState: widget.globalKey.currentState,
        snackBarText: 'Head back to test prep to study up!',
        backgroundColor: colorIncorrect,
        durationSeconds: 3);
    Navigator.pop(context);
    widget.callback();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          title: Text('Pi: timed test'),
          backgroundColor: colorChapter3Standard,
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                HapticFeedback.heavyImpact();
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return PiTimedTestScreenHelp();
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
                  height: 50,
                ),
                Container(
                  child: Text(
                    'The first 100 digits of Pi after \'3.\' are:',
                    style: TextStyle(
                        fontSize: 30, color: backgroundHighlightColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  width: 250,
                  height: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: TextFormField(
                    controller: textController,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 22,
                        fontFamily: 'SpaceMono',
                        color: backgroundHighlightColor),
                    minLines: 10,
                    maxLines: 12,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: backgroundSemiColor)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: backgroundHighlightColor)),
                        contentPadding: EdgeInsets.all(20),
                        border: OutlineInputBorder(),
                        hintText: '100 digits here!',
                        hintStyle: TextStyle(fontSize: 18, color: Colors.grey)),
                  ),
                ),
                SizedBox(height: 10,),
                showError
                    ? Text(
                        'Your guess is not 100 digits!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      )
                    : SizedBox(height: 16,),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    BasicFlatButton(
                      text: 'Give up',
                      onPressed: () => giveUp(),
                      color: Colors.grey[200],
                      splashColor: Colors.grey,
                      padding: 10,
                      fontSize: 24,
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    BasicFlatButton(
                      text: 'Submit',
                      onPressed: () => checkAnswer(),
                      color: colorChapter3Standard,
                      splashColor: colorChapter3Darker,
                      padding: 10,
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

class PiTimedTestScreenHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'Pi Timed Test',
      information: [
        '    Time to recall your story! If you recall this correctly, you\'ll '
            'unlock the next system! Good luck!'
      ],
      buttonColor: colorChapter3Standard,
      buttonSplashColor: colorChapter3Darker,
      firstHelpKey: piTimedTestFirstHelpKey,
    );
  }
}
