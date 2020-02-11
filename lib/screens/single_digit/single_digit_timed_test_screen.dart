import 'package:flutter/material.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/components/standard.dart';

class SingleDigitTimedTestScreen extends StatefulWidget {
  final Function callback;
  final Function callbackSnackbar;

  SingleDigitTimedTestScreen({this.callback, this.callbackSnackbar});

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
  String singleDigitTestActiveKey = 'SingleDigitTestActive';
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
      widget.callbackSnackbar('Congratulations! You\'ve unlocked the Alphabet system!', Colors.white, Colors.blue, 5);
    } else {
      widget.callbackSnackbar('Incorrect. Keep trying to remember, or give up and try again!', Colors.white, Colors.red, 4);
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
    widget.callbackSnackbar('Try the timed test again to unlock the next system.', Colors.white, Colors.red, 3);
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
    );
  }
}
