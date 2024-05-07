import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mem_plus_plus/components/standard/basic_flat_button.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_dialog.dart';

import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:flutter/services.dart';

class PiTimedTestScreen extends StatefulWidget {
  final Function() callback;
  final GlobalKey<ScaffoldState> globalKey;

  PiTimedTestScreen({required this.callback, required this.globalKey});

  @override
  _PiTimedTestScreenState createState() => _PiTimedTestScreenState();
}

class _PiTimedTestScreenState extends State<PiTimedTestScreen> {
  final textController = TextEditingController();
  int lives = 3;
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
    prefs.checkFirstTime(context, piTimedTestFirstHelpKey,
        PiTimedTestScreenHelp(callback: widget.callback));
    setState(() {});
  }

  void checkAnswer() async {
    setState(() {
      showError = false;
    });
    HapticFeedback.lightImpact();
    if (textController.text.replaceAll(' ', '').length != 100) {
      setState(() {
        showError = true;
      });
      return;
    }
    if (textController.text.replaceAll(' ', '') == '$piString') {
      prefs.updateActivityVisible(piTimedTestKey, false);
      prefs.updateActivityVisible(piTimedTestPrepKey, true);
      prefs.setBool(irrationalGameAvailableKey, true);
      if (!prefs.getBool(irrationalGameFirstViewKey)) {
        prefs.setBool(newGamesAvailableKey, true);
        prefs.setBool(irrationalGameFirstViewKey, true);
      }
      if (!prefs.getBool(piTimedTestCompleteKey)) {
        prefs.updateActivityState(piTimedTestKey, 'review');
        prefs.setBool(piTimedTestCompleteKey, true);
        if (!prefs.getBool(face2TimedTestCompleteKey)) {
          showSnackBar(
            context: context,
            snackBarText:
                'Awesome job! Complete the Face (hard) test to unlock the next system!',
            textColor: Colors.black,
            backgroundColor: colorChapter3Darker,
            durationSeconds: 3,
          );
          showSnackBar(
            context: context,
            snackBarText:
                'Congratulations! You\'ve unlocked the Irra/ional game!',
            textColor: Colors.white,
            backgroundColor: colorGamesDarker,
            durationSeconds: 3,
            isSuper: true,
          );
        } else {
          prefs.updateActivityVisible(deckEditKey, true);
          showSnackBar(
            context: context,
            snackBarText: 'Congratulations! You\'ve unlocked the Deck system!',
            textColor: Colors.white,
            backgroundColor: colorDeckDarker,
            durationSeconds: 3,
            isSuper: true,
          );
          prefs.updateActivityVisible(tripleDigitEditKey, true);
          showSnackBar(
            context: context,
            snackBarText:
                'Congratulations! You\'ve unlocked the Triple Digit system!',
            textColor: Colors.white,
            backgroundColor: colorTripleDigitDarker,
            durationSeconds: 3,
            isSuper: true,
          );
        }
        textController.text = '';
        Navigator.pop(context);
      } else {
        showSnackBar(
          context: context,
          snackBarText: 'Congratulations! You aced it!',
          textColor: Colors.black,
          backgroundColor: colorChapter3Standard,
          durationSeconds: 2,
        );
        textController.text = '';
        Navigator.pop(context);
      }
    } else if (lives > 1) {
      lives -= 1;
      setState(() {});
      showSnackBar(
        context: context,
        snackBarText: 'Incorrect. You have $lives lives left!',
        textColor: Colors.black,
        backgroundColor: colorIncorrect,
        durationSeconds: 3,
      );
    } else {
      showSnackBar(
        context: context,
        snackBarText:
            'Incorrect. Keep trying to remember, or give up and try again!',
        textColor: Colors.black,
        backgroundColor: colorIncorrect,
        durationSeconds: 3,
      );
      Navigator.pop(context);
      textController.text = '';
    }
    widget.callback();
  }

  void giveUp() async {
    HapticFeedback.lightImpact();
    prefs.updateActivityState(piTimedTestKey, 'review');
    prefs.updateActivityVisible(piTimedTestKey, false);
    prefs.updateActivityVisible(piTimedTestPrepKey, true);
    showSnackBar(
        context: context,
        snackBarText: 'Head back to test prep to study up!',
        backgroundColor: colorIncorrect,
        durationSeconds: 3);
    Navigator.pop(context);
    widget.callback();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
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
                HapticFeedback.lightImpact();
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return PiTimedTestScreenHelp(callback: widget.callback);
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
                    'The first 100 digits of Pi \nafter \'3.\' are:',
                    style: TextStyle(
                        fontSize: 26, color: backgroundHighlightColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '${textController.text.length} / 100 digits entered',
                  style: TextStyle(
                      fontSize: 16, color: backgroundSemiHighlightColor),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 25),
                Container(
                  width: screenWidth * 0.8,
                  height: 260,
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
                    keyboardType: TextInputType.phone,
                    onChanged: (String s) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: backgroundHighlightColor)),
                        contentPadding: EdgeInsets.all(20),
                        border: OutlineInputBorder(),
                        hintText: '100 digits here!',
                        hintStyle: TextStyle(fontSize: 18, color: Colors.grey)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                showError
                    ? Column(
                        children: <Widget>[
                          Text(
                            'Your guess is not 100 digits!',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      )
                    : SizedBox(
                        height: 16,
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    lives >= 1
                        ? Icon(
                            MdiIcons.heart,
                            size: 40,
                            color: Colors.red,
                          )
                        : Icon(
                            MdiIcons.heartOutline,
                            size: 40,
                            color: Colors.red,
                          ),
                    lives >= 2
                        ? Icon(
                            MdiIcons.heart,
                            size: 40,
                            color: Colors.red,
                          )
                        : Icon(
                            MdiIcons.heartOutline,
                            size: 40,
                            color: Colors.red,
                          ),
                    lives >= 3
                        ? Icon(
                            MdiIcons.heart,
                            size: 40,
                            color: Colors.red,
                          )
                        : Icon(
                            MdiIcons.heartOutline,
                            size: 40,
                            color: Colors.red,
                          ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '$lives lives remaining!',
                  style:
                      TextStyle(fontSize: 20, color: backgroundHighlightColor),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    BasicFlatButton(
                      text: 'Give up',
                      onPressed: () => giveUp(),
                      color: Colors.grey[200]!,
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
  final Function callback;
  PiTimedTestScreenHelp({Key? key, required this.callback}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return HelpDialog(
      title: 'Pi - Timed Test',
      information: [
        '    Time to recall your story! If you recall this correctly, you\'ll '
            'unlock the next system! Good luck!\n\n    You can leave the spaces in if it\'s easier '
            'for you to type it out like that!'
      ],
      buttonColor: colorChapter3Standard,
      buttonSplashColor: colorChapter3Darker,
      firstHelpKey: piTimedTestFirstHelpKey,
      callback: callback,
    );
  }
}
