import 'package:flutter/material.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:flutter/services.dart';

class SingleDigitTimedTestScreen extends StatefulWidget {
  final Function callback;
  final GlobalKey<ScaffoldState> globalKey;

  SingleDigitTimedTestScreen({this.callback, this.globalKey});

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

  Future<Null> getSharedPrefs() async {
    var prefs = PrefsUpdater();
    prefs.checkFirstTime(context, 'SingleDigitTimedTestFirstHelp',
        SingleDigitTimedTestScreenHelp());
    // grab the digits
    digit1 = await prefs.getString('singleDigitTestDigit1');
    digit2 = await prefs.getString('singleDigitTestDigit2');
    digit3 = await prefs.getString('singleDigitTestDigit3');
    digit4 = await prefs.getString('singleDigitTestDigit4');
    print('real answer: $digit1$digit2$digit3$digit4');
    setState(() {});
  }

  void checkAnswer() async {
    if (textController.text == '$digit1$digit2$digit3$digit4') { 
      await prefs.updateActivityVisible(singleDigitTimedTestKey, false);
      await prefs.updateActivityVisible(singleDigitTimedTestPrepKey, true);
      await prefs.updateActivityState(singleDigitTimedTestKey, 'review');
      if (await prefs.getBool(singleDigitTimedTestCompleteKey) == null) {
        await prefs.setBool(singleDigitTimedTestCompleteKey, true);
        await prefs.updateActivityVisible(alphabetEditKey, true);
        showSnackBar(
          scaffoldState: widget.globalKey.currentState,
          snackBarText:
              'Congratulations! You\'ve unlocked the Alphabet system!',
          textColor: Colors.white,
          backgroundColor: colorAlphabetDarker,
          durationSeconds: 4,
          isSuper: true,
        );
      } else {
        showSnackBar(
          scaffoldState: widget.globalKey.currentState,
          snackBarText:
              'Congratulations! You aced it!',
          textColor: Colors.black,
          backgroundColor: colorSingleDigitStandard,
          durationSeconds: 2,
        );
      }
    } else {
      showSnackBar(
        scaffoldState: widget.globalKey.currentState,
        snackBarText:
            'Incorrect. Keep trying to remember, or give up and try again!',
        backgroundColor: colorIncorrect,
        durationSeconds: 3,
      );
    }
    textController.text = '';
    widget.callback();
    Navigator.pop(context);
  }

  void giveUp() async {
    await prefs.updateActivityState(singleDigitTimedTestKey, 'review');
    await prefs.updateActivityVisible(singleDigitTimedTestKey, false);
    await prefs.updateActivityVisible(singleDigitTimedTestPrepKey, true);
    if (await prefs.getBool(singleDigitTimedTestCompleteKey) == null) {
      await prefs.updateActivityState(singleDigitTimedTestPrepKey, 'todo');
    }
    showSnackBar(
        scaffoldState: widget.globalKey.currentState,
        snackBarText:
            'The correct answer was: $digit1$digit2$digit3$digit4\nTry the timed test again to unlock the next system.',
        backgroundColor: colorIncorrect,
        durationSeconds: 5);
    Navigator.pop(context);
    widget.callback();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          title: Text('Single digit: timed test'),
          backgroundColor: Colors.amber[200],
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                HapticFeedback.heavyImpact();
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return SingleDigitTimedTestScreenHelp();
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
                          borderSide: BorderSide(color: backgroundSemiColor)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: backgroundHighlightColor)),
                      hintText: 'XXXX',
                      hintStyle: TextStyle(
                          fontSize: 30,
                          fontFamily: 'SpaceMono',
                          color: backgroundHighlightColor)),
                ),
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  BasicFlatButton(
                    text: 'Give up',
                    fontSize: 24,
                    color: Colors.grey[200],
                    splashColor: Colors.amber,
                    onPressed: () => giveUp(),
                    padding: 10,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  BasicFlatButton(
                    text: 'Submit',
                    fontSize: 24,
                    color: Colors.amber[200],
                    splashColor: Colors.amber,
                    onPressed: () => checkAnswer(),
                    padding: 10,
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
  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'Single Digit Timed Test',
      information: [
        '    Time to remember your story! If you recall this correctly, you\'ll '
            'unlock the next system! Good luck!'
      ],
      buttonColor: Colors.amber[100],
      buttonSplashColor: Colors.amber[300],
      firstHelpKey: singleDigitTimedTestFirstHelpKey,
    );
  }
}
