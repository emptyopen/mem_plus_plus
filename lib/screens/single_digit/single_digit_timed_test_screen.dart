import 'package:flutter/material.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:mem_plus_plus/constants/colors.dart';

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
    prefs.checkFirstTime(context, 'SingleDigitTimedTestFirstHelp', SingleDigitTimedTestScreenHelp());
    // grab the digits
    digit1 = await prefs.getString('singleDigitTestDigit1');
    digit2 = await prefs.getString('singleDigitTestDigit2');
    digit3 = await prefs.getString('singleDigitTestDigit3');
    digit4 = await prefs.getString('singleDigitTestDigit4');
    print('real answer: $digit1$digit2$digit3$digit4');
    setState(() {

    });
  }

  void checkAnswer() async {
    if (textController.text == '$digit1$digit2$digit3$digit4') {
      print('success');
      // every time
      await prefs.updateActivityVisible('SingleDigitTimedTest', false);
      await prefs.updateActivityVisible('SingleDigitTimedTestPrep', true);

      // just first time
      if (await prefs.getBool('SingleDigitTimedTestComplete') == null) {
        await prefs.updateActivityState('SingleDigitTimedTest', 'review');
        await prefs.updateActivityVisible('AlphabetEdit', true);
        await prefs.updateActivityFirstView('AlphabetEdit', true);
      }
      showSnackBar(
        scaffoldState: widget.globalKey.currentState,
        snackBarText: 'Congratulations! You\'ve unlocked the Alphabet system!',
        textColor: Colors.white,
        backgroundColor: colorAlphabetDarker,
        durationSeconds: 5,
        isSuper: true,
      );
    } else {
      showSnackBar(
        scaffoldState: widget.globalKey.currentState,
        snackBarText: 'Incorrect. Keep trying to remember, or give up and try again!',
        backgroundColor: colorIncorrect,
        durationSeconds: 3,
      );
    }
    textController.text = '';
    widget.callback();
    Navigator.pop(context);
  }

  void giveUp() async {
    await prefs.updateActivityState('SingleDigitTimedTest', 'review');
    await prefs.updateActivityVisible('SingleDigitTimedTest', false);
    await prefs.updateActivityVisible('SingleDigitTimedTestPrep', true);
    if (await prefs.getBool('SingleDigitTimedTestComplete') == null) {
      await prefs.updateActivityState('SingleDigitTimedTestPrep', 'todo');
    }
    showSnackBar(
      scaffoldState: widget.globalKey.currentState,
      snackBarText: 'The correct answer was: $digit1$digit2$digit3$digit4\nTry the timed test again to unlock the next system.',
      backgroundColor: colorIncorrect,
      durationSeconds: 5
    );
    Navigator.pop(context);
    widget.callback();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Single digit: timed test'),
        backgroundColor: Colors.amber[200],
        actions: <Widget>[
        // action button
        IconButton(
          icon: Icon(Icons.info),
          onPressed: () {
            Navigator.of(context).push(PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) {
                  return SingleDigitTimedTestScreenHelp();
                }));
          },
        ),
      ]),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Text(
                'Enter the number: ',
                style: TextStyle(fontSize: 30),
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
                style: TextStyle(fontSize: 30, fontFamily: 'SpaceMono'),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(5),
                    border: OutlineInputBorder(),
                    hintText: 'XXXX',
                    hintStyle: TextStyle(fontSize: 30, fontFamily: 'SpaceMono')),
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
                SizedBox(width: 10,),
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
    );
  }
}

class SingleDigitTimedTestScreenHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'Single Digit Timed Test',
      information: ['    Time to remember your story! If you recall this correctly, you\'ll '
        'unlock the next system! Good luck!'],
      buttonColor: Colors.amber[100],
      buttonSplashColor: Colors.amber[300],
    );
  }
}
