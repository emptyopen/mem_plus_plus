import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/standard/basic_flat_button.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_dialog.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:flutter/services.dart';

class AlphabetTimedTestScreen extends StatefulWidget {
  final Function() callback;
  final GlobalKey<ScaffoldState> globalKey;

  AlphabetTimedTestScreen({required this.callback, required this.globalKey});

  @override
  _AlphabetTimedTestScreenState createState() =>
      _AlphabetTimedTestScreenState();
}

class _AlphabetTimedTestScreenState extends State<AlphabetTimedTestScreen> {
  String char1 = '';
  String char2 = '';
  String char3 = '';
  String char4 = '';
  String char5 = '';
  String char6 = '';
  String char7 = '';
  String char8 = '';
  final textController1 = TextEditingController();
  final textController2 = TextEditingController();
  PrefsUpdater prefs = PrefsUpdater();

  @override
  void dispose() {
    textController1.dispose();
    textController2.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  getSharedPrefs() {
    prefs.checkFirstTime(context, 'AlphabetTimedTestFirstHelp',
        AlphabetTimedTestScreenHelp(callback: widget.callback));
    // grab the digits
    char1 = (prefs.getString('alphabetTestChar1'));
    char2 = (prefs.getString('alphabetTestChar2'));
    char3 = (prefs.getString('alphabetTestChar3'));
    char4 = (prefs.getString('alphabetTestChar4'));
    char5 = (prefs.getString('alphabetTestChar5'));
    char6 = (prefs.getString('alphabetTestChar6'));
    char7 = (prefs.getString('alphabetTestChar7'));
    char8 = (prefs.getString('alphabetTestChar8'));
    print('real answer: $char1$char2$char3$char4 $char5$char6$char7$char8');
    setState(() {});
  }

  checkAnswer() {
    HapticFeedback.lightImpact();
    if (textController1.text.toLowerCase().trim() ==
            '$char1$char2$char3$char4'.toLowerCase() &&
        textController2.text.toLowerCase().trim() ==
            '$char5$char6$char7$char8'.toLowerCase()) {
      prefs.updateActivityVisible(alphabetTimedTestKey, false);
      prefs.updateActivityVisible(alphabetTimedTestPrepKey, true);
      prefs.updateActivityVisible(lesson2Key, true);
      if (!prefs.getBool(alphabetTimedTestCompleteKey)) {
        prefs.updateActivityState(alphabetTimedTestKey, 'review');
        prefs.setBool(alphabetTimedTestCompleteKey, true);
        showSnackBar(
          context: context,
          snackBarText:
              'Congratulations! You\'ve mastered the Alphabet system!',
          textColor: Colors.white,
          backgroundColor: colorAlphabetDarker,
          durationSeconds: 3,
          isSuper: true,
        );
        showSnackBar(
          context: context,
          snackBarText: 'You\'ve unlocked Chapter 2!',
          textColor: Colors.black,
          backgroundColor: colorChapter2Darker,
          durationSeconds: 3,
          isSuper: true,
        );
      } else {
        showSnackBar(
          context: context,
          snackBarText: 'Congratulations! You aced it!',
          textColor: Colors.black,
          backgroundColor: colorAlphabetStandard,
          durationSeconds: 2,
        );
      }
    } else {
      showSnackBar(
        context: context,
        snackBarText:
            'Incorrect. Keep trying to remember, or give up and try again!',
        textColor: Colors.black,
        backgroundColor: colorIncorrect,
        durationSeconds: 3,
      );
    }
    textController1.text = '';
    textController2.text = '';
    Navigator.pop(context);
    widget.callback();
  }

  giveUp() {
    HapticFeedback.lightImpact();
    prefs.updateActivityState(alphabetTimedTestKey, 'review');
    prefs.updateActivityVisible(alphabetTimedTestKey, false);
    prefs.updateActivityVisible(alphabetTimedTestPrepKey, true);
    if (!prefs.getBool(alphabetTimedTestCompleteKey)) {
      prefs.updateActivityState(alphabetTimedTestPrepKey, 'todo');
    }
    showSnackBar(
      context: context,
      snackBarText:
          'It was: $char1$char2$char3$char4 $char5$char6$char7$char8. Try the timed test again to unlock the next system.',
      textColor: Colors.black,
      backgroundColor: colorIncorrect,
      durationSeconds: 3,
    );
    Navigator.pop(context);
    widget.callback();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          title: Text('Alphabet: timed test', style: TextStyle(fontSize: 18)),
          backgroundColor: Colors.blue[200],
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return AlphabetTimedTestScreenHelp(
                          callback: widget.callback);
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
                  height: 30,
                ),
                Container(
                  child: Text(
                    'Enter the characters: ',
                    style: TextStyle(
                        fontSize: 30, color: backgroundHighlightColor),
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  child: TextFormField(
                    controller: textController1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'SpaceMono',
                        color: backgroundHighlightColor),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: backgroundHighlightColor),
                        ),
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder(),
                        hintText: 'XXXX',
                        hintStyle: TextStyle(
                          fontSize: 30,
                          color: Colors.grey,
                        )),
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
                      color: backgroundHighlightColor,
                    ),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: backgroundHighlightColor),
                      ),
                      contentPadding: EdgeInsets.all(5),
                      border: OutlineInputBorder(),
                      hintText: 'XXXX',
                      hintStyle: TextStyle(
                        fontSize: 30,
                        color: Colors.grey,
                      ),
                    ),
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
                      color: Colors.blue[200]!,
                      onPressed: () => checkAnswer(),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AlphabetTimedTestScreenHelp extends StatelessWidget {
  final Function callback;
  AlphabetTimedTestScreenHelp({Key? key, required this.callback})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return HelpDialog(
      title: 'Alphabet - Timed Test',
      information: [
        '    Time to recall your story! If you recall this correctly, you\'ll '
            'unlock the next system! Good luck!'
      ],
      buttonColor: Colors.blue[100]!,
      buttonSplashColor: Colors.blue[300]!,
      firstHelpKey: alphabetTimedTestFirstHelpKey,
      callback: callback,
    );
  }
}
